//
//  MoreViewController.m
//  AMTrust
//
//  Created by kishore kumar on 23/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController
@synthesize moreTableView;
    
    - (void)viewDidLoad {
        [super viewDidLoad];

        moreTableView.tableFooterView = [UIView new];
        
    }
    
    -(void)viewWillAppear:(BOOL)animated
    {
        [super viewWillAppear:animated];
        
        [[Helper sharedInstance] trackingScreen:@"MoreScreen_ios"];
        self.title = NSLocalizedStringFromTableInBundle(@"More", nil, [[Helper sharedInstance] getLocalBundle], nil);
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        CustomTabBarController *tabBar = (CustomTabBarController *) self.tabBarController;
        [tabBar refresh];
                                    
        
        [moreTableView reloadData];
    }
    
    -(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
    {
        return 3;
    }

    -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        if(section==2)
        {
            return 8;
        }
        
        return 1;
    }

    -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MoreBack"]];

        if(indexPath.section==0)
        {
            cell.textLabel.text = NSLocalizedStringFromTableInBundle(@"Share with your friends", nil,  [[Helper sharedInstance] getLocalBundle], nil);
        }
        else if (indexPath.section==1)
        {
            cell.textLabel.text = NSLocalizedStringFromTableInBundle(@"Rate our app", nil,  [[Helper sharedInstance] getLocalBundle], nil);
        }
        else
        {
            if(indexPath.row==0)
            {
                cell.textLabel.text = NSLocalizedStringFromTableInBundle(@"About us", nil,  [[Helper sharedInstance] getLocalBundle], nil);
            }
            else if (indexPath.row==1)
            {
                cell.textLabel.text = NSLocalizedStringFromTableInBundle(@"App tour", nil,  [[Helper sharedInstance] getLocalBundle], nil);
            }
            if(indexPath.row==2)
            {
                cell.textLabel.text = NSLocalizedStringFromTableInBundle(@"Privacy policy", nil,  [[Helper sharedInstance] getLocalBundle], nil);
            }
            else if (indexPath.row==3)
            {
                cell.textLabel.text = NSLocalizedStringFromTableInBundle(@"Disclaimer", nil,  [[Helper sharedInstance] getLocalBundle], nil);
            }
            else if (indexPath.row==4)
            {
                cell.textLabel.text = NSLocalizedStringFromTableInBundle(@"Change country / language", nil,  [[Helper sharedInstance] getLocalBundle], nil);
            }
            else if (indexPath.row==5)
            {
                cell.textLabel.text = NSLocalizedStringFromTableInBundle(@"Version", nil,  [[Helper sharedInstance] getLocalBundle], nil);
                NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
                cell.detailTextLabel.text = appVersionString;
                cell.accessoryView = nil;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            }else if (indexPath.row==6)
            {
                cell.textLabel.text = NSLocalizedStringFromTableInBundle(@"Build", nil,  [[Helper sharedInstance] getLocalBundle], nil);
                NSString * buildStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
                cell.detailTextLabel.text = buildStr;
                cell.accessoryView = nil;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            else if (indexPath.row==7)
            {
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                if(!cell)
                {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }
                
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.textColor = [UIColor blackColor];
                cell.textLabel.textColor = [Helper colorWithHexString:@"FF304B"];
                
                
                if([[Helper sharedInstance] isLogin])
                {
                    cell.textLabel.text = NSLocalizedStringFromTableInBundle(@"Logout",nil,  [[Helper sharedInstance] getLocalBundle], nil);
                }
                else
                {
                    cell.textLabel.text = NSLocalizedStringFromTableInBundle(@"Login", nil,  [[Helper sharedInstance] getLocalBundle], nil);
                }
                
                return cell;
            }
        }
        
        return cell;
    }

    #pragma mark TableViewDidSelect

    -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
        if(indexPath.section==0)
        {
            InviteFriendsViewController *inviteViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteFriendsViewController"];
            inviteViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:inviteViewController animated:YES];
        }
        else if (indexPath.section==1)
        {
            NSDictionary *profile = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];
           
            if(profile.count!=0)
            {
                RateViewController *rateViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RateViewController"];
                rateViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:rateViewController animated:YES];
            }
            else
            {
                NSString *localization = NSLocalizedStringFromTableInBundle(@"Please login to review the app",nil,  [[Helper sharedInstance] getLocalBundle], nil);
                [Helper popUpMessage:localization titleForPopUp:@"" buttonTitle:@"ok"];
            }
        }
        else
        {
            if(indexPath.row==1)
            {
                WalkthroughViewController *walkthroughViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WalkthroughViewController"];
                walkthroughViewController.originScreen = @"more";
                walkthroughViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:walkthroughViewController animated:YES];
            }
            else if(indexPath.row==0)
            {
                TermsViewController *termsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
                termsViewController.strTitle = @"About us";
                termsViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:termsViewController animated:YES];
            }
            else if(indexPath.row==2)
            {
                TermsViewController *termsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
                termsViewController.strTitle = @"Privacy policy";
                termsViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:termsViewController animated:YES];
            }
            else if(indexPath.row==3)
            {
                TermsViewController *termsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
                termsViewController.strTitle = @"Disclaimer";//Terms of Use
                termsViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:termsViewController animated:YES];
            }
            else if(indexPath.row==4)
            {
                CountrySelectionViewController *languageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CountrySelectionViewController"];
                languageViewController.isFromMoreController = YES;
                languageViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:languageViewController animated:YES];
            }
            else if (indexPath.row==7)
            {
                if([[Helper sharedInstance] isLogin])
                {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"profile"];
                    [[Helper sharedInstance] getTokenString];
                    
                    CustomTabBarController *tabBar = (CustomTabBarController *)self.tabBarController;
                    [tabBar logout];
                }
                else
                {
                    OnboardingViewController *onboardingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OnboardingViewController"];
                    onboardingViewController.hidesBottomBarWhenPushed = YES;
                    onboardingViewController.originScreen = @"more";
                    
                    [self.navigationController pushViewController:onboardingViewController animated:YES];
                }
                    
            }
        }
    }

    #pragma mark moretableview header section
    -(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
    {
        if(section==0)
        {
            return NSLocalizedStringFromTableInBundle(@"Invite your friends", nil,  [[Helper sharedInstance] getLocalBundle], nil);
        }
        else if (section==1)
        {
            return NSLocalizedStringFromTableInBundle(@"Feedback to Us", nil,  [[Helper sharedInstance] getLocalBundle], nil);
        }
        else
        {
            return NSLocalizedStringFromTableInBundle(@"General information", nil,  [[Helper sharedInstance] getLocalBundle], nil);
        }
    }

    -(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
    {
        return 40;
    }
    
    - (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
    {
        if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
            
            UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
            tableViewHeaderFooterView.textLabel.textAlignment = NSTextAlignmentCenter;
            tableViewHeaderFooterView.textLabel.textColor = [UIColor grayColor];
            tableViewHeaderFooterView.textLabel.font = [UIFont boldSystemFontOfSize:15];
        }
    }

    - (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end
