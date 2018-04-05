//
//  WalkthroughViewController.m
//  AMTrust
//
//  Created by kishore kumar on 29/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "WalkthroughViewController.h"

@interface WalkthroughViewController ()

@end

@implementation WalkthroughViewController
@synthesize showBackButton;
@synthesize originScreen;
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [walkthroughCollectionView registerNib:[UINib nibWithNibName:@"WalkthroughCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WalkthroughCollectionViewCell"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    contentArray = [self getData];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if(showBackButton)
    {
        backButton.hidden = NO;
    }else
    {
        backButton.hidden = YES;
    }
    
    if([originScreen isEqualToString:@"more"])
    {
        [btnStart setTitle:NSLocalizedStringFromTableInBundle(@"Done", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
    }else
    {
        [btnStart setTitle:NSLocalizedStringFromTableInBundle(@"Start now", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
    }
    
    [walkthroughCollectionView reloadData];
}

#pragma mark - Data

- (NSArray *)getData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"walkthrough" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

#pragma mark - CollectionView Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return contentArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WalkthroughCollectionViewCell *wCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WalkthroughCollectionViewCell" forIndexPath:indexPath];
    
    NSDictionary *dict = [contentArray objectAtIndex:indexPath.row];
    
    wCell.walkthroughHeader.text = NSLocalizedStringFromTableInBundle([dict objectForKey:@"header"], nil, [[Helper sharedInstance] getLocalBundle], nil);
    wCell.walkthroughDetails.text = NSLocalizedStringFromTableInBundle([dict objectForKey:@"details"], nil, [[Helper sharedInstance] getLocalBundle], nil);
    wCell.walkthroughImageView.image = [UIImage imageNamed:[dict objectForKey:@"image"]];

    return wCell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
    
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = walkthroughCollectionView.frame.size.width;
    pageControl.currentPage = walkthroughCollectionView.contentOffset.x / pageWidth;
}
    
#pragma mark - Button Action

- (IBAction)submitAction:(id)sender {
    
    if([originScreen isEqualToString:@"more"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"WALKTHROUGH"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        WelcomeViewController *welcomeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
        [self.navigationController pushViewController:welcomeViewController animated:YES];
    }
}

-(IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
