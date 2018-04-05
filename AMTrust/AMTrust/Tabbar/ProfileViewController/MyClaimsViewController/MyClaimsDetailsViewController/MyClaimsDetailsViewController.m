//
//  MyClaimsDetailsViewController.m
//  AMTrust
//
//  Created by kishore kumar on 01/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "MyClaimsDetailsViewController.h"

@interface MyClaimsDetailsViewController ()

@end

@implementation MyClaimsDetailsViewController
@synthesize myClaimDetailsTableview;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Claim details";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackMore"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    backButton.tintColor = [Helper colorWithHexString:@"#FF304B"];
    self.navigationItem.leftBarButtonItem = backButton;

    [myClaimDetailsTableview registerNib:[UINib nibWithNibName:@"MyClaimDetailsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyClaimDetailsTableViewCell"];
    myClaimDetailsTableview.backgroundColor = [UIColor clearColor];
    myClaimDetailsTableview.hidden = YES;
    [self myClaimDetail:_claimId];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[Helper sharedInstance] trackingScreen:@"ClaimDetails_IOS"];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)myClaimDetail:(NSString *)contactID
{
    [SVProgressHUD showWithStatus:@"loading.."];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    
    
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:BASEURL];
    
    response.POSTDictionary = @{@"operation":@"ams.claim_detail",
                                @"sessionName":sessionName,
                                @"claimid":contactID
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

            if(success)
            {
                [SVProgressHUD dismiss];
                
                if([failure isEqualToString:@"failure"])
                {
                    [Helper popUpMessage:[[json objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"" view:[UIView new]];
                }
                else
                {
                    claimDetailDictionary = [[json objectForKey:@"result"] objectForKey:@"data"];
                    myClaimDetailsTableview.hidden = NO;
                    [myClaimDetailsTableview reloadData];
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
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyClaimDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyClaimDetailsTableViewCell"];
    if(!cell)
    {
        cell = [[MyClaimDetailsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyClaimDetailsTableViewCell"];
    }
    
    if(indexPath.section==0)
    {
        cell.lblHeader.text = @"e-Submission no.";
        cell.lblValue.text = [NSString stringWithFormat:@"%@",[claimDetailDictionary objectForKey:@"contract_no"]];
        //contract_no
    }
    else if (indexPath.section==1)
    {
        cell.lblHeader.text = @"Name.";
        cell.lblValue.text = [NSString stringWithFormat:@"%@ %@",[claimDetailDictionary objectForKey:@"firstname"],[claimDetailDictionary objectForKey:@"lastname"]];
    }
    else if (indexPath.section==2)
    {
        cell.lblHeader.text = @"Ref No.";
        cell.lblValue.text = [NSString stringWithFormat:@"%@",[claimDetailDictionary objectForKey:@"cf_1393"]];
        //cf_2190
    }
    else if (indexPath.section==3)
    {
        cell.lblHeader.text = @"Claim type";
        cell.lblValue.text = [NSString stringWithFormat:@"%@",[claimDetailDictionary objectForKey:@"cf_2030"]];
    }
    else if (indexPath.section==4)
    {
        cell.lblHeader.text = @"Status";
        cell.lblValue.text = [NSString stringWithFormat:@"%@",[claimDetailDictionary objectForKey:@"cf_2008"]];
    }
    else if (indexPath.section==5)
    {
        cell.lblHeader.text = @"Submitted date";
        cell.lblValue.text =  [NSString stringWithFormat:@"%@",[claimDetailDictionary objectForKey:@"createdtime"]];
    }


    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3;
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
