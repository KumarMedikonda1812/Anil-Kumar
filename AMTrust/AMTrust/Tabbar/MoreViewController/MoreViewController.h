//
//  MoreViewController.h
//  AMTrust
//
//  Created by kishore kumar on 23/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviteFriendsViewController.h"
#import "RateViewController.h"
#import "TermsViewController.h"
#import "WalkthroughViewController.h"
#import "CountrySelectionViewController.h"
#import "OnboardingViewController.h"
#import "CustomTabBarController.h"

@interface MoreViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
    
@property (weak, nonatomic) IBOutlet UITableView *moreTableView;

@end
