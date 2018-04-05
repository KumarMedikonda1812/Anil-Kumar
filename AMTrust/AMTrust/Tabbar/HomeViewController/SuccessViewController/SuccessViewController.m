//
//  SuccessViewController.m
//  Tecprotec
//
//  Created by kishore kumar on 18/07/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "SuccessViewController.h"

@interface SuccessViewController ()

@end

@implementation SuccessViewController
@synthesize successTest,imgStatus,lblStatus;
- (void)viewDidLoad {
    [super viewDidLoad];

    [_btnContinue setTitle:NSLocalizedStringFromTableInBundle(@"Continue", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];

    if(successTest)
    {
        lblStatus.text = NSLocalizedStringFromTableInBundle(@"GREAT!", nil, [[Helper sharedInstance] getLocalBundle], nil);
        _lblSecond.text = NSLocalizedStringFromTableInBundle(@"Great! Your smartphone is in good health and no faults found.", nil, [[Helper sharedInstance] getLocalBundle], nil);
        imgStatus.image = [UIImage imageNamed:@"success"];
    }
    else
    {
        lblStatus.text = NSLocalizedStringFromTableInBundle(@"SORRY!", nil, [[Helper sharedInstance] getLocalBundle], nil);
        _lblSecond.text = NSLocalizedStringFromTableInBundle(@"We found some problems with your smartphone. Check out our TecExpert for usability issues. Contact the manufacturer for warranty issues and TecProtec to know if it’s covered by your plan.", nil, [[Helper sharedInstance] getLocalBundle], nil);
        imgStatus.image = [UIImage imageNamed:@"error"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ActionCancel:(id)sender {
    
        BOOL tecExpert = [[[NSUserDefaults standardUserDefaults] objectForKey:@"TECEXPERT"] boolValue];
        if(tecExpert)
        {
            [[Helper sharedInstance] trackingScreen:@"Healthcheck_From_TecExpert_IOS"];

            LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:@"" message:@"You have completed the test" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"ok" destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
            } cancelHandler:^(LGAlertView * _Nonnull alertView) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
                
            }];
            alertView.tintColor = THEMECOLOR;
            [alertView show];

        }
        else
        {
            if(successTest)
            {
                TestDataCollectionViewController *testDataCollectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TestDataCollectionViewController"];
                [self.navigationController pushViewController:testDataCollectionViewController animated:YES];
                
                [[Helper sharedInstance] trackingScreen:@"Healthcheck_Success_IOS"];

            }
            else
            {
                [[Helper sharedInstance] trackingScreen:@"Healthcheck_Fails_IOS"];

                UITabBarController *homeTab = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomTabBarController"];
                [self presentViewController:homeTab animated:YES completion:nil];
            }
        }
}

- (IBAction)ActionContinue:(id)sender {
    
}
@end
