//
//  ProfileLoginViewController.m
//  TECPROTEC
//
//  Created by Sethu on 31/1/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import "ProfileLoginViewController.h"

@interface ProfileLoginViewController ()

@end

@implementation ProfileLoginViewController
@synthesize facebookButton;
@synthesize createAccountButton;
@synthesize loginButton;

- (void)viewDidLoad {
    [super viewDidLoad];

    createAccountButton.layer.borderWidth = 1;
    createAccountButton.layer.borderColor = [Helper colorWithHexString:@"FF304B"].CGColor;
    
    loginButton.layer.borderWidth = 1;
    loginButton.layer.borderColor = [Helper colorWithHexString:@"FF304B"].CGColor;
    facebookButton.backgroundColor = [Helper colorWithHexString:@"#3B5998"];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}
    
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [facebookButton setTitle:NSLocalizedStringFromTableInBundle(@"Create account with Facebook", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
    
    [createAccountButton setTitle:NSLocalizedStringFromTableInBundle(@"Create account with mobile number", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
    [loginButton setTitle:NSLocalizedStringFromTableInBundle(@"Login", nil,[[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
    
    
- (IBAction)loginAction:(id)sender {
    LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    loginViewController.shouldShowTabBarOnSuccess = NO;
    loginViewController.originScreen = @"profile";
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    navigationController.navigationBarHidden = YES;

    [self.tabBarController presentViewController:navigationController animated:YES completion:nil];
}
    
- (IBAction)createAccountAction:(id)sender {
    
    SignUpViewController *signUpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    signUpViewController.isPresentedModally = YES;
    signUpViewController.originScreen = @"profile";

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:signUpViewController];
    navigationController.navigationBarHidden = YES;
    
    [self.tabBarController presentViewController:navigationController animated:YES completion:nil];

}
    
- (IBAction)facebookLoginAction:(id)sender {
    
    FacebookViewController *facebookViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FacebookViewController"];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:facebookViewController];
    navigationController.navigationBarHidden = YES;
    
    [self.tabBarController presentViewController:navigationController animated:NO completion:nil];
}


    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
