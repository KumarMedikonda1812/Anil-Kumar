//
//  FacebookViewController.m
//  TECPROTEC
//
//  Created by Sethu on 5/2/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import "FacebookViewController.h"

@interface FacebookViewController ()

@end

@implementation FacebookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FBSDKAccessToken setCurrentAccessToken:nil];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorBrowser;
    
    [login logInWithReadPermissions: @[@"public_profile",@"email"] fromViewController:self.tabBarController  handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (error) {
            NSLog(@"Process error");
        } else if (result.isCancelled) {
            [self dismissViewControllerAnimated:YES completion:nil];
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
                         signUpViewController.isPresentedModally = YES;
                         signUpViewController.originScreen = @"profile";
                         signUpViewController.fbDic = paramDict;
                         signUpViewController.fbVariation = YES;
                         
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
