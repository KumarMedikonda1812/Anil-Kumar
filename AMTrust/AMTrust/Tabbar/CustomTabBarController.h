//
//  CustomTabBarController.h
//  TECPROTEC
//
//  Created by Sethu on 30/1/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileNavigationViewController.h"
#import "MoreNavigationViewController.h"
#import "TechExpertNavigationViewController.h"
#import "ProfileNavigationViewController.h"
#import "WelcomeViewController.h"

@interface CustomTabBarController : UITabBarController

@property (weak, nonatomic) IBOutlet UITabBar *tabbarItem;

-(void)logout;
-(void)refresh;

@end

