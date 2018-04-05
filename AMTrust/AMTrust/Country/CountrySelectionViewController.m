//
//  CountrySelectionViewController.m
//  TecProtec
//
//  Created by kishore kumar on 17/08/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "CountrySelectionViewController.h"

@interface CountrySelectionViewController ()

@end

@implementation CountrySelectionViewController
@synthesize isFromMoreController;
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [countryButton setTitle:@"Indonesia" forState:UIControlStateNormal];

    [[NSUserDefaults standardUserDefaults] setObject:INDO_COUNTRY_ID forKey:@"Country"];
    [[NSUserDefaults standardUserDefaults] setObject:INDO_COUNTRY_NAME forKey:@"CountryName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [countryButton.layer setBorderColor:[Helper colorWithHexString:@"FF304B"].CGColor];
    [languageButton.layer setBorderColor:[Helper colorWithHexString:@"FF304B"].CGColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [[Helper sharedInstance] trackingScreen:@"CountrySelection_IOS"];

    [submitButton setTitle:NSLocalizedStringFromTableInBundle(@"Submit", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];

    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguage"];
    
    if(language)
    {
        if([language isEqualToString:@"id"])
        {
            [languageButton setTitle:@"Bahasa (Indonesia)" forState:UIControlStateNormal];
        }else
        {
            [languageButton setTitle:@"English" forState:UIControlStateNormal];
        }
    }else
    {
        [self languageOption:@"en" apiLanguage:@"english"];
        [languageButton setTitle:@"English" forState:UIControlStateNormal];

    }
}

-(void)languageOption:(NSString *)currentLanguage apiLanguage:(NSString *)apiCurrentLanguage
{
    NSString *path = [[NSBundle mainBundle] pathForResource:currentLanguage ofType:@"lproj"];
    
    [[NSUserDefaults standardUserDefaults]setObject:path forKey:@"BundlePath"];
    [[NSUserDefaults standardUserDefaults]setObject:currentLanguage forKey:@"CurrentLanguage"];
    [[NSUserDefaults standardUserDefaults]setObject:apiCurrentLanguage forKey:@"ApiCurrentLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Button Action

- (IBAction)submitAction:(id)sender {
    
    if(isFromMoreController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        WalkthroughViewController * walkthroughViewController= [self.storyboard instantiateViewControllerWithIdentifier:@"WalkthroughViewController"];
        walkthroughViewController.showBackButton = YES;
        [self.navigationController pushViewController:walkthroughViewController animated:YES];
    }
}

- (IBAction)countryAction:(id)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Indonesia" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[NSUserDefaults standardUserDefaults] setObject:INDO_COUNTRY_ID forKey:@"Country"];
        [[NSUserDefaults standardUserDefaults] setObject:INDO_COUNTRY_NAME forKey:@"CountryName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [countryButton setTitle:@"Indonesia" forState:UIControlStateNormal];
    }]];
    
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)languageAction:(id)sender {
    
    NSString *indo = [[NSUserDefaults standardUserDefaults]objectForKey:@"CountryName"];
    
    if(indo.length!=0)
    {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"English" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [languageButton setTitle:@"English" forState:UIControlStateNormal];
            [self languageOption:@"en" apiLanguage:@"english"];
        }]];
        
        
        if([indo isEqualToString:@"Indonesia"])
        {
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Bahasa (Indonesia)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [languageButton setTitle:@"Bahasa (Indonesia)" forState:UIControlStateNormal];
                [self languageOption:@"id" apiLanguage:@"bahasa"];
            }]];
        }
        
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
