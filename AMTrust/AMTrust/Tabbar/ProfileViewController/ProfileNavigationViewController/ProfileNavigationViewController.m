//
//  ProfileNavigationViewController.m
//  AMTrust
//
//  Created by kishore kumar on 26/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "ProfileNavigationViewController.h"

@interface ProfileNavigationViewController ()

@end

@implementation ProfileNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
    
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController = self.topViewController;
    
    if(self.topViewController == nil || [viewController isKindOfClass:[ProfileLoginViewController class]])
    {
        if([[Helper sharedInstance] isLogin])
        {
            UIViewController *vc1 = [storyboard instantiateViewControllerWithIdentifier:@"ProfileSegmentedPagerController"];
            [self setViewControllers:@[vc1] animated:NO];
            
        }else
        {
            UIViewController *vc1 = [storyboard instantiateViewControllerWithIdentifier:@"ProfileLoginViewController"];
            [self setViewControllers:@[vc1] animated:NO];
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
