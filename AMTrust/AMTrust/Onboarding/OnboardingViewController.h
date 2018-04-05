//
//  OnboardingViewController.h
//  TECPROTEC
//
//  Created by Sethu on 31/1/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "SignUpViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface OnboardingViewController : UIViewController
{
    IBOutlet UIButton *facebookButton;
    IBOutlet UIButton *createAccountButton;
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *closeButton;
}

@property  BOOL isPresentedModally;
@property (strong, nonatomic)  NSString *originScreen;


@end

