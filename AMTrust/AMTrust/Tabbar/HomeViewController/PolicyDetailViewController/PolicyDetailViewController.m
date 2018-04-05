//
//  PolicyDetailViewController.m
//  Tecprotec
//
//  Created by kishore kumar on 07/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "PolicyDetailViewController.h"

@interface PolicyDetailViewController ()
 
@end

@implementation PolicyDetailViewController
@synthesize dicProductDetails;
@synthesize rangeInput;
@synthesize productId;
@synthesize backgroundColor;
@synthesize currencyCode;
@synthesize isTablet;

- (void)viewDidLoad {
    [super viewDidLoad];
    

    policyModel = [[PolicyModel alloc] init];
    arrayForTitle = @[@"Header",@"Price",@"Benefits",@"Exclusions",@"Terms & Conditions"];

    [self setupNIB];
    
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [btnBuyNow setTitle:NSLocalizedStringFromTableInBundle(@"Proceed", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
    
    [[Helper sharedInstance] trackingScreen:@"ProductDetail_IOS"];
}

-(void)setupNIB
{
    [policyDetailsTableView registerNib:[UINib nibWithNibName:@"PolicyHeaderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PolicyHeaderTableViewCell"];
    
    [policyDetailsTableView registerNib:[UINib nibWithNibName:@"PolicyPriceTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PolicyPriceTableViewCell"];
    
    [policyDetailsTableView registerNib:[UINib nibWithNibName:@"TextTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TextTableViewCell"];
    
    [policyDetailsTableView registerNib:[UINib nibWithNibName:@"StarTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"StarTableViewCell"];
    
    [policyDetailsTableView registerNib:[UINib nibWithNibName:@"ButtonTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ButtonTableViewCell"];
}

-(void)getData
{
    [SVProgressHUD showWithStatus:@"loading.."];
    
    rangeInput = [rangeInput stringByReplacingOccurrencesOfString:@"," withString:@""];
    rangeInput = [rangeInput stringByReplacingOccurrencesOfString:@"." withString:@""];

    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    NSString *apiLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"ApiCurrentLanguage"];
   
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:BASEURL];
    
    response.POSTDictionary = @{@"operation":@"ams.product_detail",
                                @"sessionName":sessionName,
                                @"productid":productId,
                                @"rangeinput":rangeInput,
                                @"language":apiLanguage
                                };
    
    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        @try {
            NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&error];
            json = [json replaceNullsWithObject:@"NA"];

            BOOL success = [[json objectForKey:@"success"] boolValue];
            NSDictionary *resultDict = [json objectForKey:@"result"];
            NSString *status = [resultDict objectForKey:@"status"];
            
            if(success)
            {
                [SVProgressHUD dismiss];
                

                if([status isEqualToString:@"success"])
                {
                    NSDictionary *dataDict = [resultDict objectForKey:@"data"];
                   
                    [policyModel updateModelWithDictionary:dataDict];
                    
                    //using this back in Summary Page to showcase the details of policy
                    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                    [def setObject:[NSKeyedArchiver archivedDataWithRootObject:dataDict] forKey:@"summary"];
                    [def setObject:backgroundColor forKey:@"ProductColor"];
                    [def synchronize];
                    
                    [policyDetailsTableView reloadData];
                }
                else
                {
                    [Helper popUpMessage:[resultDict objectForKey:@"message"] titleForPopUp:@"" view:[UIView new]];
                }
            }
            else
            {
                [SVProgressHUD dismiss];
                [Helper popUpMessage:[[json objectForKey:@"error"] objectForKey:@"message"] titleForPopUp:@"Error" view:[UIView new]];
            }
            
        }@catch (NSException *exception) {
            [SVProgressHUD dismiss];
            [Helper catchPopUp:body titleForPopUp:@""];
        }
    };
    response.errorBlock = ^(NSError *error) {

        [SVProgressHUD dismiss];
        
        LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:@"" message:error.localizedDescription style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"Retry" destructiveButtonTitle:@"Cancel" actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
        } cancelHandler:^(LGAlertView * _Nonnull alertView) {
            
            [self getData];
            
        } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        alertView.tintColor = THEMECOLOR;
        [alertView show];

    };
    
    [response startAsynchronous];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[arrayForTitle objectAtIndex:section] isEqualToString:@"Benefits"])
    {
        NSArray *policyArray = [policyModel.planBenifits componentsSeparatedByString:@"\n"];
        return policyArray.count;
    }
    else if ([[arrayForTitle objectAtIndex:section] isEqualToString:@"Exclusions"])
    {
        NSArray *exclusionArray = [policyModel.planExclusions componentsSeparatedByString:@"\n"];
        return exclusionArray.count;
    }
   
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrayForTitle.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[arrayForTitle objectAtIndex:indexPath.section] isEqualToString:@"Header"])
    {
        PolicyHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PolicyHeaderTableViewCell"];
        
        if(!cell)
        {
            cell = [[PolicyHeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        cell.hearderBackground.backgroundColor = [Helper colorWithHexString:backgroundColor];
        [cell.btnBack addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.imgFeatures.image = _img;

        [cell updateContent:policyModel withIsTablet:isTablet];
        
        
        return cell;
    }
    else if([[arrayForTitle objectAtIndex:indexPath.section] isEqualToString:@"Price"])
    {
        PolicyPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PolicyPriceTableViewCell"];
        
        if(!cell)
        {
            cell = [[PolicyPriceTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PolicyPriceTableViewCell"];
        }
        NSString *priceOftheCost = policyModel.planPrice;
        
        [[NSUserDefaults standardUserDefaults] setObject:priceOftheCost forKey:@"listPrice"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        cell.currencyLabel.text = currencyCode;
        cell.priceLabel.text = policyModel.planPrice;

        return cell;
    }
    else if([[arrayForTitle objectAtIndex:indexPath.section] isEqualToString:@"Benefits"])
    {
        TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextTableViewCell"];
        if(!cell)
        {
            cell = [[TextTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TextTableViewCell"];
        }
        
        NSArray *policyArray = [policyModel.planBenifits componentsSeparatedByString:@"\n"];

        [cell updateText:[policyArray objectAtIndex:indexPath.row]];

        return cell;
    }
    else if([[arrayForTitle objectAtIndex:indexPath.section] isEqualToString:@"Exclusions"])
    {
        TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextTableViewCell"];
        if(!cell)
        {
            cell = [[TextTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TextTableViewCell"];
        }
        
        NSArray *exclusionArray = [policyModel.planExclusions componentsSeparatedByString:@"\n"];

        [cell updateText:[exclusionArray objectAtIndex:indexPath.row]];

        return cell;
    }
    else
    {
        ButtonTableViewCell *cellButton = [tableView dequeueReusableCellWithIdentifier:@"ButtonTableViewCell"];
        if(!cellButton)
        {
            cellButton = [[ButtonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextFieldTableViewCell"];
        }
        [cellButton.btnPassword setTitle:NSLocalizedStringFromTableInBundle(@"Terms & Conditions", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
        [cellButton.btnPassword addTarget:self action:@selector(actionPdf:) forControlEvents:UIControlEventTouchUpInside];
        
        return cellButton;
        
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if([[arrayForTitle objectAtIndex:section] isEqualToString:@"Header"]||[[arrayForTitle objectAtIndex:section] isEqualToString:@"Terms & Conditions"])
    {
        return 0;
    }
    else
    {
        return 50;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    v.backgroundColor = [UIColor clearColor];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[arrayForTitle objectAtIndex:indexPath.section] isEqualToString:@"Benefits"])
    {
        NSArray *policyArray = [policyModel.planBenifits componentsSeparatedByString:@"\n"];

        NSString *strArticleData = [NSString stringWithFormat:@"%@",[policyArray objectAtIndex:indexPath.row]];
        CGFloat height = [Helper getHeightForText:strArticleData withFont:[UIFont systemFontOfSize:21 weight:UIFontWeightRegular] andWidth:self.view.frame.size.width];
        return height + 5;
    }
    
    if([[arrayForTitle objectAtIndex:indexPath.section] isEqualToString:@"Exclusions"])
    {
        NSArray *exclusionArray = [policyModel.planExclusions componentsSeparatedByString:@"\n"];

        NSString *strArticleData = [NSString stringWithFormat:@"%@",[exclusionArray objectAtIndex:indexPath.row]];
        CGFloat height = [Helper getHeightForText:strArticleData withFont:[UIFont systemFontOfSize:21 weight:UIFontWeightRegular] andWidth:self.view.frame.size.width];
        return height;
    }
    else if ([[arrayForTitle objectAtIndex:indexPath.section] isEqualToString:@"Terms & Conditions"])
    {
        return 50;
    }
    else if ([[arrayForTitle objectAtIndex:indexPath.section] isEqualToString:@"Header"])
    {
        return 350;
    }
    else
    {
        return 60;
    }
}

-(IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)ActionTechStart:(id)sender
{
    if(isTablet)
    {
        TestDataCollectionViewController *testDataCollectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TestDataCollectionViewController"];
        testDataCollectionViewController.isTablet = YES;
        [self.navigationController pushViewController:testDataCollectionViewController animated:YES];
    }
    else
    {
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TechStart"];
        [viewController.navigationController setNavigationBarHidden:YES animated:YES];
        [self.navigationController pushViewController:viewController animated:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"TECEXPERT"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.tableHeaderView.frame.size.height)];
    view.backgroundColor = [UIColor whiteColor];
    
    if(section!=0)
    {
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(20,10, tableView.frame.size.width-40, 0.5)];
        viewLine.backgroundColor = [UIColor grayColor];
        [view addSubview:viewLine];
    }
    /* Create custom view to display section header... */
    if([[arrayForTitle objectAtIndex:section] isEqualToString:@"Terms & Conditions"])
    {
    }
    else if ([[arrayForTitle objectAtIndex:section] isEqualToString:@"Exclusions"])
    {
        NSArray *exclusionArray = [policyModel.planExclusions componentsSeparatedByString:@"\n"];

        if(exclusionArray.count!=0)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,30, tableView.frame.size.width, 20)];
            [label setFont:[UIFont fontWithName:@"Roboto-Medium" size:16]];
            label.textColor = [UIColor blackColor];
            
            label.text = NSLocalizedStringFromTableInBundle([arrayForTitle objectAtIndex:section], nil, [[Helper sharedInstance] getLocalBundle], nil);
            [view addSubview:label];
        }
    }
    else
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,30, tableView.frame.size.width, 20)];
        [label setFont:[UIFont fontWithName:@"Roboto-Medium" size:16]];
        label.textColor = [UIColor blackColor];
        
        label.text = NSLocalizedStringFromTableInBundle([arrayForTitle objectAtIndex:section], nil, [[Helper sharedInstance] getLocalBundle], nil);
        [view addSubview:label];
    }
    
    return view;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0)
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    v.backgroundColor = [UIColor clearColor];

}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0)
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    v.backgroundColor = [UIColor clearColor];

}
- (BOOL)allowsHeaderViewsToFloat
{
    return NO;
}
- (BOOL)allowsFooterViewToFloat
{
    return NO;
}
-(void)actionPdf:(id)sender
{
    WebViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webViewController.check = YES;
    webViewController.strURL = policyModel.planTnC;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
