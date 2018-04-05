//
//  MyClaimsViewController.m
//  AMTrust
//
//  Created by kishore kumar on 31/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "MyClaimsViewController.h"

@interface MyClaimsViewController ()

@end

@implementation MyClaimsViewController
@synthesize myClaimsTableView;
@synthesize delegate;
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [myClaimsTableView registerNib:[UINib nibWithNibName:@"MyClaimsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyClaimsTableViewCell"];
    myClaimsTableView.backgroundColor = [UIColor clearColor];
    
    arrClaimDetails = [[NSMutableArray alloc]init];

    _btnClaimNow.layer.cornerRadius = 5;
    _btnClaimNow.layer.borderWidth = 1;
    _btnClaimNow.layer.borderColor = [UIColor grayColor].CGColor;

    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDictionary *dicPersonal = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];
    if(dicPersonal.count!=0)
    {
        [self myClaims:[dicPersonal objectForKey:@"customerid"]];
    }

    [[Helper sharedInstance] trackingScreen:@"MyClaims_IOS"];
    
    self.navigationController.navigationBarHidden = YES;
}
    
-(IBAction)ActionClaimNow:(id)sender
{
    WebViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
}
-(void)myClaims:(NSString *)customerId
{
    [SVProgressHUD showWithStatus:@"loading.."];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:BASEURL];
    
    response.POSTDictionary = @{@"operation":@"ams.myclaims",
                                @"sessionName":sessionName,
                                @"contactid":customerId,
                                @"policyid":@""
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
            NSString *failure = [[json objectForKey:@"result"] objectForKey:@"status"];
            
            NSLog(@"RESPONSE = %@",json);
            //
            if(success)
            {
                [SVProgressHUD dismiss];
                
                if([failure isEqualToString:@"failure"])
                {
                    myClaimsTableView.hidden = YES;
                }
                else
                {
                    arrClaimDetails = [[json objectForKey:@"result"] objectForKey:@"data"];
                    [myClaimsTableView reloadData];
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
        // ...
        [SVProgressHUD dismiss];
        [Helper popUpMessage:error.localizedDescription titleForPopUp:@"Error" view:[UIView new]];
    };
    
    [response startAsynchronous];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrClaimDetails.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyClaimsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyClaimsTableViewCell"];
    if(!cell)
    {
        cell = [[MyClaimsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyClaimsTableViewCell"];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSString *claimName = [NSString stringWithFormat:@"%@",[[arrClaimDetails objectAtIndex:indexPath.section] objectForKey:@"cf_2030"]];
    cell.lblName.text = claimName;
    cell.lblDate.text = [NSString stringWithFormat:@"%@",[[arrClaimDetails objectAtIndex:indexPath.section] objectForKey:@"createdtime"]];
    cell.imgViewLogo.image = [UIImage imageNamed:@"mobile"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *claimID = [NSString stringWithFormat:@"%@",[[arrClaimDetails objectAtIndex:indexPath.section] objectForKey:@"claimid"]];
    
    [delegate redirectToClaimDetails:claimID];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0;
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 2.0;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.backgroundColor = [UIColor whiteColor];
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
