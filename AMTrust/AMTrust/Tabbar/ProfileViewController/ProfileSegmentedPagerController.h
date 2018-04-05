//
//  ProfileSegmentedPagerController.h
//  AMTrust
//
//  Created by kishore kumar on 31/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSegmentedPager.h"
#import "MXSegmentedPagerController.h"
#import "EditProfileViewController.h"
#import "ProfileParallaxHeaderView.h"
#import "NotificationViewController.h"
#import "MyPlansViewController.h"
#import "MyClaimsViewController.h"
#import "MyActivitiesViewController.h"

@interface ProfileSegmentedPagerController : MXSegmentedPagerController<MyPlanDelegate,MyClaimDelegate>
{
    ProfileParallaxHeaderView *profileParallaxHeaderView;
    NSMutableArray *myPlansArray;
    
    MyPlansViewController *vc1;
    MyClaimsViewController *vc2;
    MyActivitiesViewController *vc3;
}
    

    
@end
