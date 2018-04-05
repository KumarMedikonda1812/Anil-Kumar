//
//  OnboardingViewController.m
//  TECPROTEC
//
//  Created by Sethu on 31/1/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import "OnboardingViewController.h"

@interface OnboardingViewController ()

@end

@implementation OnboardingViewController
@synthesize originScreen;
@synthesize isPresentedModally;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Setup Color
    createAccountButton.layer.borderColor = [Helper colorWithHexString:THEMECOLORSTR].CGColor;
    loginButton.layer.borderColor = [Helper colorWithHexString:THEMECOLORSTR].CGColor;
    facebookButton.backgroundColor = [Helper colorWithHexString:FACEBOOKBLUESTR];

    //Setup Border
    createAccountButton.layer.borderWidth = 1;
    loginButton.layer.borderWidth = 1;
}
    
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self updateLanguage];
}

-(void)updateLanguage
{
    [facebookButton setTitle:NSLocalizedStringFromTableInBundle(@"Create account with Facebook", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
    
    [createAccountButton setTitle:NSLocalizedStringFromTableInBundle(@"Create account with mobile number", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
    [loginButton setTitle:NSLocalizedStringFromTableInBundle(@"Login", nil,[[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
}

#pragma mark - Button Action

- (IBAction)closeAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Button Action


- (IBAction)loginAction:(id)sender {
    LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    loginViewController.shouldShowTabBarOnSuccess = YES;
    loginViewController.originScreen = originScreen;
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (IBAction)createAccountAction:(id)sender {
    
    SignUpViewController *signUpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    signUpViewController.isPresentedModally = isPresentedModally;
    signUpViewController.originScreen = originScreen;
    [self.navigationController pushViewController:signUpViewController animated:YES];
}
    
- (IBAction)facebookAction:(id)sender {
    
    [FBSDKAccessToken setCurrentAccessToken:nil];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorBrowser;
    [login
     logInWithReadPermissions: @[@"public_profile",@"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             [SVProgressHUD showWithStatus:@"Loading..."];
             if ([FBSDKAccessToken currentAccessToken]) {
                 
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"email,first_name,last_name,picture.type(large)"}]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      if (!error) {
                          
                          NSLog(@"facebook result = %@",result);
                          NSString *fname = [NSString stringWithFormat:@"%@",[result objectForKey:@"first_name"]];
                          NSString *lname = [NSString stringWithFormat:@"%@",[result objectForKey:@"last_name"]];
                          NSString *emailid = [NSString stringWithFormat:@"%@",[result objectForKey:@"email"]];
                          NSString *image = [NSString stringWithFormat:@"%@",[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                          NSString *fbid = [NSString stringWithFormat:@"%@",[result objectForKey:@"id"]];
                          [[NSUserDefaults standardUserDefaults] setObject:fbid forKey:@"FBKEY"];
                          NSString *fbAccessToken = [FBSDKAccessToken currentAccessToken].tokenString;
                          [[NSUserDefaults standardUserDefaults] setObject:fbAccessToken forKey:@"FBACCESS"];
                          
                          NSDictionary *paramDict = @{
                                                      @"fname":fname,
                                                      @"lname":lname,
                                                      @"fbId":fbid,
                                                      @"email":emailid,
                                                      @"fbToken":fbAccessToken,
                                                      @"img":image
                                                      };
                          
                          SignUpViewController *signUpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
                          signUpViewController.isPresentedModally = isPresentedModally;
                          signUpViewController.originScreen = originScreen;
                          signUpViewController.fbVariation = YES;
                          signUpViewController.fbDic = paramDict;
                          [self.navigationController pushViewController:signUpViewController animated:YES];
                          
                      }
                      else
                      {
                          NSLog(@"this is localized string = %@",error.localizedDescription);
                      }
                  }];
             }
             [SVProgressHUD dismiss];
         }
     }];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
@end

