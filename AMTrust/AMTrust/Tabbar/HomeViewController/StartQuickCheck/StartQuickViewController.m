///Users/Kishore/Documents/iOS/tecprotec-ios 2/AMTrust/TecProtec.xcodeproj
//  StartQuickViewController.m
//  Tecprotec
//
//  Created by kishore kumar on 12/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "StartQuickViewController.h"

@interface StartQuickViewController ()

@end

@implementation StartQuickViewController
@synthesize btnCancel,lblTitle,lblDetails,btnStartNow;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [btnCancel setTitle:NSLocalizedStringFromTableInBundle(@"Cancel", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
    lblTitle.text = NSLocalizedStringFromTableInBundle(@"Let’s check if your phone is working", nil, [[Helper sharedInstance] getLocalBundle], nil);
  //  lblDetails.text = NSLocalizedStringFromTableInBundle(@"Before you proceed, please note that you’ll need access to a mirror and bank card/ payment details.", nil, localeBundle, nil);
    [btnStartNow setTitle:NSLocalizedStringFromTableInBundle(@"Start now", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ActionClose:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)ActionHealthCheck:(id)sender {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0,300,320)];
//    UILabel *lblTitlePop = [[UILabel alloc] initWithFrame:CGRectMake(20, 10,self.view.frame.size.width-40, 30)];
//    lblTitlePop.numberOfLines = 0;
//    [lblTitlePop setFont:[UIFont fontWithName:@"Roboto-Medium" size:15]];
//    lblTitlePop.textAlignment = NSTextAlignmentCenter;
//    lblTitlePop.text = @"A few points before you start";
//    [view addSubview:lblTitlePop];
    
    UILabel *lblTitleSecond = [[UILabel alloc] initWithFrame:CGRectMake(20,0,300-40, 50)];
    lblTitleSecond.numberOfLines = 0;
    [lblTitleSecond setFont:[UIFont fontWithName:@"Roboto-Regular" size:15]];
    lblTitleSecond.textAlignment = NSTextAlignmentCenter;
    lblTitleSecond.text = NSLocalizedStringFromTableInBundle(@"Switch on your device WiFi & Bluetooth", nil, [[Helper sharedInstance] getLocalBundle], nil);
    [view addSubview:lblTitleSecond];

    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(lblTitleSecond.frame),260, 60)];
    imgView.image = [UIImage imageNamed:@"wifi_bluetooth"];
    imgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imgView];
    
    BOOL tecExpert = [[[NSUserDefaults standardUserDefaults] objectForKey:@"TECEXPERT"] boolValue];
    if(tecExpert)
    {
        view.frame = CGRectMake(0,0,300,150);
    }
    else
    {
        UILabel *lblTitleThird = [[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(imgView.frame)+5,300-40,50)];
        lblTitleThird.numberOfLines = 0;
        [lblTitleThird setFont:[UIFont fontWithName:@"Roboto-Regular" size:15]];
        lblTitleThird.textAlignment = NSTextAlignmentCenter;
        lblTitleThird.text = NSLocalizedStringFromTableInBundle(@"You need access to a mirror to check the phone screen.", nil, [[Helper sharedInstance] getLocalBundle], nil);
        [view addSubview:lblTitleThird];
        
        UIImageView *imgViewSecond = [[UIImageView alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(lblTitleThird.frame),300-40, 60)];
        imgViewSecond.image = [UIImage imageNamed:@"sevenS"];
        imgViewSecond.backgroundColor = [UIColor groupTableViewBackgroundColor];
        imgViewSecond.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imgViewSecond];
        
        UILabel *lblTitlefour = [[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(imgViewSecond.frame)+5,300-40,40)];
        lblTitlefour.numberOfLines = 0;
        [lblTitlefour setFont:[UIFont fontWithName:@"Roboto-Regular" size:15]];
        lblTitlefour.textAlignment = NSTextAlignmentCenter;
        lblTitlefour.text = NSLocalizedStringFromTableInBundle(@"You need your payment card or online bank details.", nil, [[Helper sharedInstance] getLocalBundle], nil);
        [view addSubview:lblTitlefour];
        
        UIImageView *imgViewThird = [[UIImageView alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(lblTitlefour.frame),300-40, 60)];
        imgViewThird.image = [UIImage imageNamed:@"card"];
        imgViewThird.backgroundColor = [UIColor groupTableViewBackgroundColor];
        imgViewThird.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imgViewThird];

    }
    NSString *lets =  NSLocalizedStringFromTableInBundle(@"Let's get started!", nil, [[Helper sharedInstance] getLocalBundle], nil);
    LGAlertView *alertView = [[LGAlertView alloc]initWithViewAndTitle:NSLocalizedStringFromTableInBundle(@"A few points before you start", nil, [[Helper sharedInstance] getLocalBundle], nil) message:@"" style:LGAlertViewStyleAlert view:view buttonTitles:@[lets] cancelButtonTitle:nil destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
        
        if([title isEqualToString:lets])
        {
            QuickDiagonasisTestViewController *quickDiagonasisTestViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QuickDiagonasisTestViewController"];
            [self.navigationController pushViewController:quickDiagonasisTestViewController animated:YES];
        }
    } cancelHandler:^(LGAlertView * _Nonnull alertView) {

    } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
        
    }];
    alertView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [alertView show];

}
@end
