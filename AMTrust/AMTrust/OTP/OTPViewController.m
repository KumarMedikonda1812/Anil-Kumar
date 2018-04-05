//
//  OTPViewController.m
//  AMTrust
//
//  Created by kishore kumar on 30/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "OTPViewController.h"

@interface OTPViewController ()

@end

@implementation OTPViewController
@synthesize isTablet;
@synthesize isPresentedModally;
@synthesize isFromLogin;
@synthesize originScreen;
@synthesize mobileNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resendAction)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [resendLbl addGestureRecognizer:tapGestureRecognizer];
    resendLbl.userInteractionEnabled = YES;
    
    [self updateLanguage];
    if ([originScreen  isEqual: @"Login"]) {
        [self resendAction];

    }
    
}

-(void)updateLanguage
{
    lblVerify.text = NSLocalizedStringFromTableInBundle(@"Verify Mobile Number", nil, [[Helper sharedInstance] getLocalBundle], nil);
    lblSecond.text = NSLocalizedStringFromTableInBundle(@"Please enter the 4 digit verification code sent to your registered mobile number", nil, [[Helper sharedInstance] getLocalBundle], nil);
    [btnLogin setTitle:NSLocalizedStringFromTableInBundle(@"Login", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
    resendLbl.text = NSLocalizedStringFromTableInBundle(@"Resend the code", nil, [[Helper sharedInstance] getLocalBundle], nil);
    lblReceived.text = NSLocalizedStringFromTableInBundle(@"Didn't receive anything?", nil, [[Helper sharedInstance] getLocalBundle], nil);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [[Helper sharedInstance] trackingScreen:@"OTPScreen_IOS"];
    
    [firstTextField becomeFirstResponder];
}

#pragma mark - Button Action

- (IBAction)loginAction:(id)sender {
    
    if([firstTextField.text isEqualToString:@""] && [secondTextField.text isEqualToString:@""] && [thirdTextField.text isEqualToString:@""] && [fifthTextField.text isEqualToString:@""])
    {
        [Helper popUpMessage:@"Please enter all fields" titleForPopUp:@"" view:[UIView new]];
    }else if (firstTextField.text.length!=0 && secondTextField.text.length!=0 && thirdTextField.text!=0 &&fifthTextField.text.length!=0)
    {
        [self otpGeneration];
    }
    else
    {
        [Helper popUpMessage:@"Please check all fields" titleForPopUp:@"" view:[UIView new]];
    }
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resendAction
{
    [SVProgressHUD showWithStatus:@"Resending.."];
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    
    NSLog(@"%@%@%@",[NSString stringWithFormat:@"%@%@%@%@",firstTextField.text,secondTextField.text,thirdTextField.text,fifthTextField.text],mobileNumber,sessionName);
    response.POSTDictionary =@{@"operation":@"ams.resendotp",
                               @"mobile":[NSString stringWithFormat:@"%@%@",@"+",mobileNumber],
                               @"sessionName":sessionName};
    
    NSLog(@"PARAMETER = %@",response.POSTDictionary);
    
    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        
        json = [json replaceNullsWithObject:@"NA"];

        BOOL success = [[json objectForKey:@"success"] boolValue];
        
        NSLog(@"RESPONSE = %@",json);
        
        NSString *failure = [[json objectForKey:@"result"] objectForKey:@"status"];
        //
        if(success)
        {
            [SVProgressHUD dismiss];
            
            if([failure isEqualToString:@"failure"])
            {
                [Helper popUpMessage:[[json objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"Alert" view:[UIView new]];
            }
            else
            {
                
            }
        }
        else
        {
            
        }
    };
    response.errorBlock = ^(NSError *error) {
        // ...
        [SVProgressHUD dismiss];
        [Helper popUpMessage:error.localizedDescription titleForPopUp:@"Error" view:[UIView new]];
    };
    
    [response startAsynchronous];
}

#pragma mark - Textfield Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag<10) {
        
        if ((textField.text.length >= 1) && (string.length > 0))
        {
            
            NSInteger nextText = textField.tag + 1;
            // Try to find next responder
            UIResponder* nextResponder = [textField.superview viewWithTag:nextText];
            if (! nextResponder)
                [textField resignFirstResponder];
            // nextResponder = [textField.superview viewWithTag:1];
            
            if (nextResponder){
                // Found next responder, so set it.
                [nextResponder becomeFirstResponder];
                UITextField *nextTextfield= (UITextField*) [textField.superview viewWithTag:nextText];
                if (nextTextfield.text.length<1) {
                    if(nextTextfield.tag==4){
                        [nextTextfield setText:string];
                        [nextTextfield resignFirstResponder];
                    }else{
                        [nextTextfield setText:string];
                    }
                    
                    
                }
                
                return NO;
                
            }
            
        }
    }
    
    return YES;
    
}

#pragma mark - API Call

- (void)otpGeneration
{
    [SVProgressHUD showWithStatus:@"Loading.."];
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    
    NSLog(@"%@%@%@",[NSString stringWithFormat:@"%@%@%@%@",firstTextField.text,secondTextField.text,thirdTextField.text,fifthTextField.text],mobileNumber,sessionName);
    response.POSTDictionary =@{@"operation":@"ams.verifyotp",
                               @"otp":[NSString stringWithFormat:@"%@%@%@%@",firstTextField.text,secondTextField.text,thirdTextField.text,fifthTextField.text],
                               @"mobile":[NSString stringWithFormat:@"%@%@",@"+",mobileNumber],
                               @"sessionName":sessionName};
    
    
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
            
            NSLog(@"RESPONSE = %@",json);
            
            if(success)
            {
                [SVProgressHUD dismiss];
                
                NSString *status = [[json objectForKey:@"result"] objectForKey:@"status"];
                
                if([status isEqualToString:@"success"])
                {
                    NSDictionary *profile = [[json objectForKey:@"result"] objectForKey:@"data"];
                    if(profile.count!=0)
                    {
                        [[NSUserDefaults standardUserDefaults] setObject:[[json objectForKey:@"result"] objectForKey:@"data"] forKey:@"profile"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        if([originScreen isEqualToString:@"welcome"])
                        {
                            UITabBarController *homeTab = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomTabBarController"];
                            
                            [self.navigationController pushViewController:homeTab animated:YES];
                        }else if([originScreen isEqualToString:@"more"])
                        {
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }else if([originScreen isEqualToString:@"quickCheck"])
                        {
                            SummaryViewController *summaryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SummaryViewController"];
                            summaryViewController.strIMEI = _strimei;
                            summaryViewController.strMake = _strMake;
                            summaryViewController.isTablet = isTablet;
                            [self.navigationController pushViewController:summaryViewController animated:YES];
                        }
                        else
                        {
                            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                        }
                    }
                    else
                    {
                        [Helper catchPopUp:body titleForPopUp:@"Customer details not available please login"];
                    }
                }
                else
                {
                    [Helper popUpMessage:[[json objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"Alert" view:[UIView new]];
                }
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

@end
