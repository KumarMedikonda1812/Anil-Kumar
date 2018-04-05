//
//  ForgotPasswordViewController.m
//  AMTrust
//
//  Created by kishore kumar on 05/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    phoneNumberTextField.text = [Helper countryCode];
    [self setupKeyboardDone:phoneNumberTextField];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[Helper sharedInstance] trackingScreen:@"ForgotPassword_ios"];
}

#pragma mark - Button Action

- (void)setupKeyboardDone:(UITextField *)textField
{
    UIToolbar *ViewForDoneButtonOnKeyboard = [[UIToolbar alloc] init];
    [ViewForDoneButtonOnKeyboard sizeToFit];
    ViewForDoneButtonOnKeyboard.hidden = YES;
    UIBarButtonItem *btnDoneOnKeyboard = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                          style:UIBarButtonItemStylePlain target:self
                                                                         action:@selector(doneBtnFromKeyboardClicked:)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [ViewForDoneButtonOnKeyboard setItems:[NSArray arrayWithObjects:flexible,btnDoneOnKeyboard, nil]];
    
    textField.inputAccessoryView = ViewForDoneButtonOnKeyboard;
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneBtnFromKeyboardClicked:(id)sender
{
    [phoneNumberTextField resignFirstResponder];
}

- (IBAction)submitAction:(id)sender {
    
    if([forgetPasswordEmailTextField.text isEqualToString:@""]&&[phoneNumberTextField.text isEqualToString:@""])
    {
        forgetPasswordEmailTextField.errorText = @"Please enter your email address";
        [forgetPasswordEmailTextField showError];
        phoneNumberTextField.errorText = @"Please enter your phone number";
        [phoneNumberTextField showError];
    }
    else if (![Helper NSStringIsValidEmail:forgetPasswordEmailTextField.text])
    {
        forgetPasswordEmailTextField.errorText = @"Please enter valid email address";
        [forgetPasswordEmailTextField showError];
    }
    else if([forgetPasswordEmailTextField.text isEqualToString:@""])
    {
        forgetPasswordEmailTextField.errorText = @"Please enter your email address";
        [forgetPasswordEmailTextField showError];
    }
    else if ([phoneNumberTextField.text isEqualToString:@""])
    {
        phoneNumberTextField.errorText = @"Please enter your phone number";
        [phoneNumberTextField showError];
    }
    else
    {
        [self forgotPasswordAPI];
    }
}

#pragma mark - Text Field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - API Call

- (void)forgotPasswordAPI
{
    [SVProgressHUD showWithStatus:@"Loading.."];
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    response.POSTDictionary =@{@"operation":@"ams.forgetpwd",
                               @"email":forgetPasswordEmailTextField.text,
                               @"phone":[NSString stringWithFormat:@"+%@",phoneNumberTextField.text],
                               @"sessionName":sessionName   };
    
    
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
                    LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:@"Success" message:[[json objectForKey:@"result"] objectForKey:@"message"]  style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"ok" destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
                    } cancelHandler:^(LGAlertView * _Nonnull alertView) {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
                        
                    }];
                    alertView.tintColor = THEMECOLOR;
                    [alertView show];
                }
            }
            else
            {
                
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
