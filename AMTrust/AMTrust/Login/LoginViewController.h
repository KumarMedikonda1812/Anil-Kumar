//
//  LoginViewController.h
//  AMTrust
//
//  Created by kishore kumar on 29/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACFloatingTextField.h"
#import "ForgotPasswordViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "SummaryViewController.h"
#import "CustomTabBarController.h"

@interface LoginViewController : UIViewController<CommonRequestDelegate>
{
    IBOutlet UISegmentedControl *segmentController;
    
    IBOutlet ACFloatingTextField *emailTextField;
    IBOutlet ACFloatingTextField *passwordTextField;

    IBOutlet UILabel *lblLogin;
    IBOutlet UILabel *lblOr;

    IBOutlet UIButton *btnLogin;
    IBOutlet UIButton *btnPassword;
    IBOutlet UIButton *btnForgotPassword;
    IBOutlet UIButton *btnFb;
    
    IBOutlet NSLayoutConstraint *plusConstraints;
}

@property (strong, nonatomic)  NSString *strimei;
@property (strong, nonatomic)  NSString *strMake;
@property (strong, nonatomic)  NSString *originScreen;

@property BOOL shouldShowTabBarOnSuccess;
    
@end
