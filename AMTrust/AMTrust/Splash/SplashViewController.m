//
//  SplashViewController.m
//  TECPROTEC
//
//  Created by Sethu on 6/3/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController
@synthesize isFromBackground;
    
- (void)viewDidLoad {
    [super viewDidLoad];

    CommonRequest *commonRequest = [CommonRequest sharedInstance];
    commonRequest.delegate = self;
    
    [commonRequest getAccessKey];
    
    [activityView startAnimating];
}
    
- (void)commonRequestGetResponse:(NSDictionary *)response withAPIName:(NSString *)name{
    [activityView stopAnimating];
    
    if(isFromBackground)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguage"];
        
        if(language == nil)
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
            [[NSUserDefaults standardUserDefaults] setObject:path forKey:@"BundlePath"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
            [[NSUserDefaults standardUserDefaults]setObject:path forKey:@"BundlePath"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc1 = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
        UIViewController *vc2 = [storyboard instantiateViewControllerWithIdentifier:@"CustomTabBarController"];
        
        UIViewController *vc3 = [storyboard instantiateViewControllerWithIdentifier:@"CountrySelectionViewController"];

        if([[Helper sharedInstance] isLogin])
        {
            NSArray *controllers = @[vc1,vc2];
            [self.navigationController setViewControllers:controllers];
        }
        else
        {
            BOOL walkthrough = [[[NSUserDefaults standardUserDefaults] objectForKey:@"WALKTHROUGH"] boolValue];
            
            if(walkthrough)
            {
                NSArray *controllers = @[vc1];
                [self.navigationController setViewControllers:controllers];
            }else
            {
                NSArray *controllers = @[vc3];
                [self.navigationController setViewControllers:controllers];
            }
        }
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

@end
