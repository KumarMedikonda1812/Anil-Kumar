//
//  ProfileSegmentedPagerController.m
//  AMTrust
//
//  Created by kishore kumar on 31/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "ProfileSegmentedPagerController.h"

@implementation ProfileSegmentedPagerController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    vc1 = [storyboard instantiateViewControllerWithIdentifier:@"MyPlansViewController"];
    vc1.delegate = self;
    
    vc2 = [storyboard instantiateViewControllerWithIdentifier:@"MyClaimsViewController"];
    vc2.delegate = self;
    
    vc3 = [storyboard instantiateViewControllerWithIdentifier:@"MyActivitiesViewController"];
    
    myPlansArray = [[NSMutableArray alloc] init];
    
    profileParallaxHeaderView = [[ProfileParallaxHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,280)];
    
    [profileParallaxHeaderView.editProfileButton addTarget:self action:@selector(btnEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    [profileParallaxHeaderView.btnNotificationScreen addTarget:self action:@selector(btnNotification:) forControlEvents:UIControlEventTouchUpInside];
    
    profileParallaxHeaderView.imgProfile.layer.cornerRadius = 62.5;
    profileParallaxHeaderView.editProfileButton.layer.borderWidth = 1;
    profileParallaxHeaderView.editProfileButton.layer.borderColor = [Helper colorWithHexString:@"FD334F"].CGColor;
    
    self.segmentedPager.parallaxHeader.view = profileParallaxHeaderView;
    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.segmentedPager.parallaxHeader.height = 280;
    self.segmentedPager.parallaxHeader.minimumHeight = 20;
    self.segmentedPager.parallaxHeader.contentView.userInteractionEnabled = YES;
    self.segmentedPager.backgroundColor = [UIColor whiteColor];
    self.segmentedPager.pager.transitionStyle = MXPagerViewTransitionStyleTab;
    self.segmentedPager.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedPager.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor],NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14]};
    self.segmentedPager.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [Helper colorWithHexString:@"FF304B"]};
    self.segmentedPager.segmentedControl.selectionIndicatorColor = [Helper colorWithHexString:@"FF304B"];
    self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedPager.segmentedControl.selectionIndicatorHeight = 1;
    self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [vc1 refresh];
    
    [[Helper sharedInstance] trackingScreen:@"Profile_IOS"];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    NSDictionary *profileDetails = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];
    
    if(profileDetails != nil)
    {
        NSString *fullName = [NSString stringWithFormat:@"%@ %@",[profileDetails objectForKey:@"firstname"],[profileDetails objectForKey:@"lastname"]];
        NSString *imagePathStr = [profileDetails objectForKey:@"imagename"];
        NSString *fullPath = @"";

        if([imagePathStr containsString:@"http://"])
        {
            fullPath = imagePathStr;
        }else
        {
            fullPath = [NSString stringWithFormat:@"%@%@",BASEIMAGEURL,imagePathStr];
        }
        
        
        profileParallaxHeaderView.lblHeader.text = fullName;
        [profileParallaxHeaderView.imgProfile sd_setImageWithURL:[NSURL URLWithString:fullPath] placeholderImage:[UIImage imageNamed:@"manPlaceholder"]];
    }
    
}

-(IBAction)btnNotification:(id)sender
{
    NotificationViewController *notificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    notificationViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:notificationViewController animated:YES];
}

-(IBAction)btnEdit:(id)sender
{
    NSDictionary *profileDetails = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];
    
    if(profileDetails==nil)
    {
        [Helper popUpMessage:@"Please login to edit Profile" titleForPopUp:@"" view:[UIView new]];
    }
    else
    {
        EditProfileViewController *editProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
        editProfileViewController.hidesBottomBarWhenPushed=YES;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:editProfileViewController];

        [self.tabBarController presentViewController:navigationController animated:YES completion:nil];
    }
}

#pragma mark <MXSegmentedPagerDelegate>

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithTitle:(NSString *)title {
    NSLog(@"%@ page selected.", title);
}

-(void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithIndex:(NSInteger)index
{
    NSLog(@"%ld page selected.", (long)index);
}

#pragma mark <MXPageControllerDataSource>
- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    return 3;
}

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    NSString *planLocalized = NSLocalizedStringFromTableInBundle(@"My Plans", nil, [[Helper sharedInstance] getLocalBundle], nil);
    NSString *claimsLocalized =  NSLocalizedStringFromTableInBundle(@"My Claims", nil, [[Helper sharedInstance] getLocalBundle], nil);
    NSString *activityLocalized =  NSLocalizedStringFromTableInBundle(@"My Activities", nil, [[Helper sharedInstance] getLocalBundle], nil);
    return @[planLocalized,claimsLocalized,activityLocalized][index];
}

- (UIView *)segmentedPager:(MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index {
    
    if(index == 0)
    {
        return vc1.view;
    }else if(index == 1)
    {
        return vc2.view;
    }else
    {
        return vc3.view;
    }
}

- (CGFloat)heightForSegmentedControlInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    return 35.f;
}

#pragma mark - My Plan Delegate

-(void)myPlanRedirection:(NSDictionary *)selectedPlanDict withCategoryArray:(NSArray *)categoryArray
{
    PlanDetailViewController *detailViewController = [[PlanDetailViewController alloc] initWithNibName:@"PlanDetailViewController" bundle:nil];
    detailViewController.deviceCategory = [selectedPlanDict objectForKey:@"device_category"];
    detailViewController.policyID = [selectedPlanDict objectForKey:@"policyid"];
    detailViewController.hidesBottomBarWhenPushed = YES;
    detailViewController.myPlanArray = categoryArray;
    
    [self.navigationController pushViewController:detailViewController animated:YES];

}
    
-(void)showHomeScreen
{
    [self.tabBarController setSelectedIndex:0];

}
    
#pragma mark - MyClaimDelegate
    
-(void)redirectToClaimDetails:(NSString *)claimID
{
    MyClaimsDetailsViewController *myClaimsDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyClaimsDetailsViewController"];
    myClaimsDetailsViewController.claimId = claimID;
    [self.navigationController pushViewController:myClaimsDetailsViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
