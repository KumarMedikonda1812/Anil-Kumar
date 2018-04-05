//
//  RateViewController.m
//  AMTrust
//
//  Created by kishore kumar on 25/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "RateViewController.h"

@interface RateViewController ()

@end

@implementation RateViewController
@synthesize reviewTextField;
@synthesize btnOne,btnTwo,btnThree,btnFour,btnFive;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedStringFromTableInBundle(@"Rate our app", nil, [[Helper sharedInstance] getLocalBundle], nil);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackMore"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    backButton.tintColor = [Helper colorWithHexString:@"FF304B"];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    reviewTextField.layer.borderWidth = 0.5;
    reviewTextField.layer.borderColor = [UIColor grayColor].CGColor;
    
     [_btnRateUs setTitle:NSLocalizedStringFromTableInBundle(@"Rate our app", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Helper sharedInstance] trackingScreen:@"RateViewController_ios"];

}

-(void)review_app
{
    [SVProgressHUD showWithStatus:@"Loading.."];
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    response.POSTDictionary =@{@"operation":@"ams.rate_our_app",
                               @"sessionName":sessionName,
                               @"rating":@(ratings),
                               @"contactid":[[[NSUserDefaults standardUserDefaults] objectForKey:@"profile"] objectForKey:@"customerid"],
                               @"description":reviewTextField.text
                               };
    
    
    NSLog(@"this is tips data= %@",response.POSTDictionary);
    
    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        @try {
            NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:kNilOptions
                                                                          error:&error];
            
            json = [json replaceNullsWithObject:@"NA"];
            
            BOOL success = [[json objectForKey:@"success"] boolValue];
            
            NSLog(@"category details value = %@",json);
            
            NSString *status = [[json objectForKey:@"result"] objectForKey:@"status"];
 
            if(success)
            {
                [SVProgressHUD dismiss];
                
                if([status isEqualToString:@"success"])
                {
//                    [SVProgressHUD showSuccessWithStatus:@"Rated Successfully!"];
                    
                    [Helper popUpMessage:[[json objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"" view:[UIView new]];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"Rated"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [Helper popUpMessage:[[json objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"" view:[UIView new]];
                    reviewTextField.text = @"";
                }
            }
            else
            {
                [SVProgressHUD dismiss];
                [Helper popUpMessage:[[json objectForKey:@"error"] objectForKey:@"message"] titleForPopUp:@"Error" view:[UIView new]];
            }
            
            
        } @catch (NSException *exception) {
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

- (IBAction)ActionSubmitReview:(id)sender {
    
    if ([reviewTextField.text isEqualToString:@""])
    {
        NSString *warning = NSLocalizedStringFromTableInBundle(@"Please enter your review", nil, [[Helper sharedInstance] getLocalBundle], nil);
          [Helper popUpMessage:warning titleForPopUp:@"" view:[UIView new]];
    }
    else if (ratings==0)
    {
        NSString *warning = NSLocalizedStringFromTableInBundle(@"Please provide your rating", nil, [[Helper sharedInstance] getLocalBundle], nil);

        [Helper popUpMessage:warning titleForPopUp:@"" view:[UIView new]];    }
    else
    {
        [self review_app];
    }
}
-(IBAction)ActionBtnOne:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.isSelected)
    {
        btn.selected = NO;
        [btnOne setImage:[UIImage imageNamed:@"rate5"] forState:UIControlStateNormal];
        [btnTwo setImage:[UIImage imageNamed:@"rate4"] forState:UIControlStateNormal];
        [btnThree setImage:[UIImage imageNamed:@"rate3"] forState:UIControlStateNormal];
        [btnFour setImage:[UIImage imageNamed:@"rate2"] forState:UIControlStateNormal];
        [btnFive setImage:[UIImage imageNamed:@"rate1"] forState:UIControlStateNormal];
        ratings = 0;
    }
    else
    {
        btn.selected = YES;
        [btnOne setImage:[UIImage imageNamed:@"rate5s"] forState:UIControlStateNormal];
        ratings = 1;
    }
}
-(IBAction)ActionBtnTwo:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.isSelected)
    {
        btn.selected = NO;
        [btnTwo setImage:[UIImage imageNamed:@"rate4"] forState:UIControlStateNormal];
        [btnThree setImage:[UIImage imageNamed:@"rate3"] forState:UIControlStateNormal];
        [btnFour setImage:[UIImage imageNamed:@"rate2"] forState:UIControlStateNormal];
        [btnFive setImage:[UIImage imageNamed:@"rate1"] forState:UIControlStateNormal];
        ratings = 1;
    }
    else
    {
        btn.selected = YES;
        [btnOne setImage:[UIImage imageNamed:@"rate5s"] forState:UIControlStateNormal];
        [btnTwo setImage:[UIImage imageNamed:@"rate4s"] forState:UIControlStateNormal];
        ratings = 2;
    }
}
-(IBAction)ActionBtnThree:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.isSelected)
    {
        btn.selected = NO;
        [btnThree setImage:[UIImage imageNamed:@"rate3"] forState:UIControlStateNormal];
        [btnFour setImage:[UIImage imageNamed:@"rate2"] forState:UIControlStateNormal];
        [btnFive setImage:[UIImage imageNamed:@"rate1"] forState:UIControlStateNormal];
        ratings = 2;
    }
    else
    {
        btn.selected = YES;
        [btnOne setImage:[UIImage imageNamed:@"rate5s"] forState:UIControlStateNormal];
        [btnTwo setImage:[UIImage imageNamed:@"rate4s"] forState:UIControlStateNormal];
        [btnThree setImage:[UIImage imageNamed:@"rate3s"] forState:UIControlStateNormal];
        ratings = 3;
    }
}
-(IBAction)ActionBtnFour:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.isSelected)
    {
        btn.selected = NO;
        [btnFour setImage:[UIImage imageNamed:@"rate2"] forState:UIControlStateNormal];
        [btnFive setImage:[UIImage imageNamed:@"rate1"] forState:UIControlStateNormal];
        [btnThree setImage:[UIImage imageNamed:@"rate3"] forState:UIControlStateNormal];
        ratings = 3;
    }
    else
    {
        btn.selected = YES;
        [btnOne setImage:[UIImage imageNamed:@"rate5s"] forState:UIControlStateNormal];
        [btnTwo setImage:[UIImage imageNamed:@"rate4s"] forState:UIControlStateNormal];
        [btnThree setImage:[UIImage imageNamed:@"rate3s"] forState:UIControlStateNormal];
        [btnFour setImage:[UIImage imageNamed:@"rate2s"] forState:UIControlStateNormal];
        ratings = 4;
    }
}
-(IBAction)ActionBtnFive:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.isSelected)
    {
        btn.selected = NO;
        [btnFive setImage:[UIImage imageNamed:@"rate1"] forState:UIControlStateNormal];
        ratings = 4;
    }
    else
    {
        btn.selected = YES;
        ratings = 5;
        [btnOne setImage:[UIImage imageNamed:@"rate5s"] forState:UIControlStateNormal];
        [btnTwo setImage:[UIImage imageNamed:@"rate4s"] forState:UIControlStateNormal];
        [btnThree setImage:[UIImage imageNamed:@"rate3s"] forState:UIControlStateNormal];
        [btnFour setImage:[UIImage imageNamed:@"rate2s"] forState:UIControlStateNormal];
        [btnFive setImage:[UIImage imageNamed:@"rate1s"] forState:UIControlStateNormal];
    }
}
@end
