//
//  NotificationViewController.m
//  TecProtec
//
//  Created by kishore kumar on 18/09/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "NotificationViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController
@synthesize notificationTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackMore"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    backButton.tintColor = [Helper colorWithHexString:@"#FF304B"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"NotificationCame"];
    [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"NotificationCame"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Notification"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"Notification", nil, [[Helper sharedInstance] getLocalBundle], nil);

    self.navigationItem.leftBarButtonItem = backButton;
    
    arrResult = [[NSArray alloc]init];
    
    [self getNotification];

    NSDictionary *dicPersonal = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];
    if(dicPersonal.count!=0)
    {
        commonRequest = [CommonRequest sharedInstance];
        commonRequest.delegate = self;
        [commonRequest getMyPlans];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)commonRequestGetResponse:(NSDictionary *)response withAPIName:(NSString *)name
{
    if([name isEqualToString:@"getMyPlans"])
    {
        BOOL success = [[response objectForKey:@"success"] boolValue];
        NSString *status = [[response objectForKey:@"result"] objectForKey:@"status"];
        
        if(success)
        {
            [SVProgressHUD dismiss];
            
            if([status isEqualToString:@"success"])
            {
                NSArray *arrPlans = [[response objectForKey:@"result"] objectForKey:@"data"];
                arrPlans = [[[arrPlans reverseObjectEnumerator] allObjects] mutableCopy];
                
                for (int i =0; i < arrPlans.count; i++) {
                    
                    NSString *strPolicyName = [NSString stringWithFormat:@"%@",[[arrPlans objectAtIndex:i] objectForKey:@"device_category"]];
                    
                    if(![strPolicyName isEqualToString:@"Tablet"])
                    {
                        policyId =  [NSString stringWithFormat:@"%@",[[arrPlans objectAtIndex:i] objectForKey:@"policyid"]];
                    }
                }
            }
            
        }
    }
}

-(void)getNotification
{
    [SVProgressHUD showWithStatus:@"loading..."];
    
    NSString *deviceid = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    
    if(deviceid.length==0)
    {
        deviceid = @"2c63004c785f57e6a42e6312c49fe986fe91f874da002e6bb7a84b5ee4ce7d63";
    }
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:BASEURL];
    
    response.POSTDictionary = @{@"operation":@"notifylist",
                                @"sessionName":sessionName,
                                @"deviceid":deviceid
                                };
    
    NSLog(@"this is my notification history post messages= %@",response.POSTDictionary);

    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        @try {
            NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:kNilOptions
                                                                          error:&error];
            
            json = [json replaceNullsWithObject:@"NA"];
            
            BOOL success = [[json objectForKey:@"success"] boolValue];
            NSString *failure; //= [[json objectForKey:@"result"] objectForKey:@"status"];
            
            //
            if(success)
            {
                [SVProgressHUD dismiss];
                
                if([failure isEqualToString:@"failure"])
                {
                    [Helper popUpMessage:[[json objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"" view:[UIView new]];
                }
                else
                {
                    arrResult = [json objectForKey:@"result"];
                    arrResult = [[arrResult reverseObjectEnumerator] allObjects];

                    if(arrResult.count==0)
                    {
                        notificationTableView.hidden = YES;
                        _lblNotificationText.text = NSLocalizedStringFromTableInBundle(@"No notification available", nil, [[Helper sharedInstance] getLocalBundle], nil);
                    }
                    else
                    {
                        notificationTableView.hidden = NO;
                    }
                    [notificationTableView reloadData];
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
    return arrResult.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.numberOfLines = 0;
    NSString *html = [[arrResult objectAtIndex:indexPath.row] objectForKey:@"message"];
    
    NSString *date = [NSString stringWithFormat:@"%@<br>%@",html,[[arrResult objectAtIndex:indexPath.row] objectForKey:@"notifytime"]];
    
    NSMutableAttributedString *attrStr = [[[NSAttributedString alloc] initWithData:[date dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil] mutableCopy];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Regular" size:15] range:NSMakeRange(0, html.length)];


    cell.textLabel.attributedText = attrStr;
    
    
    return cell;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strText = [[arrResult objectAtIndex:indexPath.row] objectForKey:@"message"];
    return [Helper getHeightForText:strText withFont:[UIFont systemFontOfSize:20] andWidth:self.view.frame.size.width]+20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *html = [[arrResult objectAtIndex:indexPath.row] objectForKey:@"ticketstaus"];
    
    if([html isEqualToString:@"Reject"])
    {
        PlanDetailViewController *planDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlanDetailViewController"];
        planDetailViewController.policyID = policyId;
        [self.navigationController pushViewController:planDetailViewController animated:YES];
    }
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
