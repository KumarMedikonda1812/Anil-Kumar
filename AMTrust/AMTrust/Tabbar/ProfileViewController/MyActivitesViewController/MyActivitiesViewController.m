//
//  MyActivitiesViewController.m
//  AMTrust
//
//  Created by kishore kumar on 31/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "MyActivitiesViewController.h"

@interface MyActivitiesViewController ()

@end

@implementation MyActivitiesViewController
@synthesize myActivitiesTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [myActivitiesTableView registerNib:[UINib nibWithNibName:@"MyActivitiesTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyActivitiesTableViewCell"];
    myActivitiesTableView.backgroundColor = [UIColor clearColor];
    arrActivityTips = [[NSMutableArray alloc]init];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDictionary *dicPersonal = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];
    if(dicPersonal.count!=0)
    {
        [self myActivities:[dicPersonal objectForKey:@"customerid"]];
    }
    
    [[Helper sharedInstance] trackingScreen:@"MyActivities_IOS"];
}

-(void)myActivities:(NSString *)email_id
{
    [SVProgressHUD showWithStatus:@"loading.."];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    
    
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:BASEURL];
    
    response.POSTDictionary = @{@"operation":@"ams.userlog",
                                @"sessionName":sessionName,
                                @"contactid":email_id,
                                };
    NSLog(@"PARAMETER = %@",response.POSTDictionary);
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
                    NSString *strMessage = [[json objectForKey:@"result"] objectForKey:@"message"];
                    if([strMessage isEqualToString:@"Error while retrieve information try again."])
                    {
                    }
                    else
                    {
                        [Helper popUpMessage:[[json objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"" view:[UIView new]];
                    }
                }
                else
                {
                    arrActivityTips = [[json objectForKey:@"result"] objectForKey:@"data"];
                    arrActivityTips = [[[arrActivityTips reverseObjectEnumerator] allObjects] mutableCopy];

                    [myActivitiesTableView reloadData];
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
    return arrActivityTips.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyActivitiesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyActivitiesTableViewCell"];
    if(!cell)
    {
        cell = [[MyActivitiesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyActivitiesTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *description = [[arrActivityTips objectAtIndex:indexPath.section] objectForKey:@"description"];
    
    cell.lblName.text = [description stripHtml];
    cell.lblDate.text = [NSString stringWithFormat:@"%@",[[arrActivityTips objectAtIndex:indexPath.section] objectForKey:@"date"]];
    //}
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.0;
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

@end
