//
//  CustomTabBarController.m
//  TECPROTEC
//
//  Created by Sethu on 30/1/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import "CustomTabBarController.h"

@interface CustomTabBarController ()

@end

@implementation CustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self refresh];
}
    
-(void)refresh
{
    NSMutableArray *mutableViewControllers = [self.viewControllers mutableCopy];
    
    if([[Helper sharedInstance] isLogin])
    {
        // If logged in we load all the 5 tab bars at the bottom
        // TecExpert tab is available only if the user is logged in. The below code checks whether the 2nd tab is TecExpert and if it is not then we insert TexExpert tab in position 2
        
        UIViewController *controller = [mutableViewControllers objectAtIndex:1];
        
        if(![controller.tabBarItem.title isEqualToString:@"TecExpert"])
        {
            TechExpertNavigationViewController *techExpertNavigationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DiagnosisViewController"];
            
            [mutableViewControllers insertObject:techExpertNavigationViewController atIndex:1];
        }
        
    }else
    {
        UIViewController *controller = [mutableViewControllers objectAtIndex:1];
        
        if([controller.tabBarItem.title isEqualToString:@"TecExpert"])
        {
            [mutableViewControllers removeObjectAtIndex:1];
        }
    }
    
    self.viewControllers = mutableViewControllers;
    
    [self reloadInputViews];

}
    
-(void)logout
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:nil forKey:@"planArray"];
    [userDefaults setObject:nil forKey:@"profile"];
    [userDefaults setObject:@"NO" forKey:@"FBLOGIN"];
    
    [userDefaults synchronize];
    
    for (UIViewController *controller in self.navigationController.viewControllers) {

        if ([controller isKindOfClass:[WelcomeViewController class]]) {
            
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            break;
        }
    }
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

