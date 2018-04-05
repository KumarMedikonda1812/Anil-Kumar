//
//  WelcomeViewController.m
//  TECPROTEC
//
//  Created by Sethu on 31/1/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    protectedButton.layer.borderWidth = 1;
    protectedButton.layer.borderColor = [Helper colorWithHexString:@"FF304B"].CGColor;
}
    
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
        
    NSString *termsStr = NSLocalizedStringFromTableInBundle(@"Terms of Service and Privacy Policy", nil, [[Helper sharedInstance] getLocalBundle], nil);
    NSString *loginTitleStr = NSLocalizedStringFromTableInBundle(@"Protect your gadgets today!", nil, [[Helper sharedInstance] getLocalBundle], nil);
    NSString *protectedStr = NSLocalizedStringFromTableInBundle(@"My gadget is protected", nil, [[Helper sharedInstance] getLocalBundle], nil);
    NSString *protectStr = NSLocalizedStringFromTableInBundle(@"Protect my gadget", nil, [[Helper sharedInstance] getLocalBundle], nil);

    [termsButton setTitle:termsStr forState:UIControlStateNormal];
    loginTitle.text = loginTitleStr;
    [protectedButton setTitle:protectedStr forState:UIControlStateNormal];
    [protectButton setTitle:protectStr forState:UIControlStateNormal];
}

#pragma mark - Button Action

- (IBAction)showPrivacyAction:(id)sender
{
    TermsViewController *termsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
    termsViewController.strTitle = @"Privacy policy";
    termsViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:termsViewController animated:YES];
}
    
- (IBAction)loginAction:(id)sender {
    OnboardingViewController *onboardingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OnboardingViewController"];
    onboardingViewController.originScreen = @"welcome";
    
    [self.navigationController pushViewController:onboardingViewController animated:YES];
}
    
- (IBAction)homeAction:(id)sender {
    
    UITabBarController *customTabBar = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomTabBarController"];
    [self.navigationController pushViewController:customTabBar animated:YES];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

