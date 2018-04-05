//
//  ChangePasswordViewController.m
//  TecProtec
//
//  Created by kishore kumar on 08/09/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackMore"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    backButton.tintColor = [Helper colorWithHexString:@"#FF304B"];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedStringFromTableInBundle(@"Save", nil, [[Helper sharedInstance] getLocalBundle], nil) style:UIBarButtonItemStylePlain target:self action:@selector(ActionSave:)];
    rightButton.tintColor = [Helper colorWithHexString:@"#FF304B"];
    
    self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"Change password", nil, [[Helper sharedInstance] getLocalBundle], nil);
    
    _currentPasswordTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Current password", nil, [[Helper sharedInstance] getLocalBundle], nil);
    _PasswordTextField.placeholder = NSLocalizedStringFromTableInBundle(@"New password", nil, [[Helper sharedInstance] getLocalBundle], nil);
    _confirmPasswordTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Confirm password", nil, [[Helper sharedInstance] getLocalBundle], nil);
    
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = rightButton;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[Helper sharedInstance] trackingScreen:@"ChangePassword_ios"];

}
-(IBAction)ActionSave:(id)sender
{
    if([_currentPasswordTextField.text isEqualToString:@""])
    {
        [Helper popUpMessage:@"Please enter current password" titleForPopUp:@"" view:[UIView new]];
    }
    else if ([_PasswordTextField.text isEqualToString:@""])
    {
        [Helper popUpMessage:@"Please enter new password" titleForPopUp:@"" view:[UIView new]];
    }
    else if ([_confirmPasswordTextField.text isEqualToString:@""])
    {
        [Helper popUpMessage:@"Please enter confirm password" titleForPopUp:@"" view:[UIView new]];
    }
    else if (![_confirmPasswordTextField.text isEqualToString:_PasswordTextField.text])
    {
        [Helper popUpMessage:@"your new password and confirm password is mismatch" titleForPopUp:@"" view:[UIView new]];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"Changing password.."];
        
        STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
       NSDictionary* profileDetails = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];

        NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
        response.POSTDictionary =@{@"operation":@"ams.changepwd",
                                   @"sessionName":sessionName,
                                   @"email":[profileDetails objectForKey:@"email"],
                                   @"current_passwd":_currentPasswordTextField.text,
                                   @"new_passwd":_confirmPasswordTextField.text};
        
        
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

            if(success)
            {
                [SVProgressHUD dismiss];
                NSString *failure = [[json objectForKey:@"result"] objectForKey:@"status"];
                
                if([failure isEqualToString:@"failure"])
                {
                    [Helper popUpMessage:[[json objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"" view:[UIView new]];
                }
                else
                {
                    LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:@"Success! Your Password has been changed!" message:@"" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"ok" destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
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
                [SVProgressHUD dismiss];
                [Helper popUpMessage:[[json objectForKey:@"error"] objectForKey:@"message"] titleForPopUp:@"Error" view:[UIView new]];
            }
        };
        response.errorBlock = ^(NSError *error) {
            // ...
            [SVProgressHUD dismiss];
            [Helper popUpMessage:error.localizedDescription titleForPopUp:@"Error" view:[UIView new]];
        };
        
        [response startAsynchronous];
        
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

- (IBAction)ActionCurrentPassword:(id)sender {
    
    UIButton *btnSelected = (UIButton *)sender;
    
    if(btnSelected.selected)
    {
        btnSelected.selected = NO;
        _currentPasswordTextField.secureTextEntry = YES;
        [btnSelected setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateNormal];
    }
    else
    {
        btnSelected.selected = YES;
        _currentPasswordTextField.secureTextEntry = NO;
        [btnSelected setImage:[UIImage imageNamed:@"unhide"] forState:UIControlStateNormal];
    }

}
- (IBAction)ActionNewPassword:(id)sender {
    
    UIButton *btnSelected = (UIButton *)sender;

    if(btnSelected.selected)
    {
        btnSelected.selected = NO;
        _PasswordTextField.secureTextEntry = YES;
        [btnSelected setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateNormal];
    }
    else
    {
        btnSelected.selected = YES;
        _PasswordTextField.secureTextEntry = NO;
        [btnSelected setImage:[UIImage imageNamed:@"unhide"] forState:UIControlStateNormal];
    }

}

- (IBAction)ActionConfirmPassword:(id)sender {
    UIButton *btnSelected = (UIButton *)sender;
    
    if(btnSelected.selected)
    {
        btnSelected.selected = NO;
        _confirmPasswordTextField.secureTextEntry = YES;
        [btnSelected setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateNormal];
    }
    else
    {
        btnSelected.selected = YES;
        _confirmPasswordTextField.secureTextEntry = NO;
        [btnSelected setImage:[UIImage imageNamed:@"unhide"] forState:UIControlStateNormal];
    }

}
@end
