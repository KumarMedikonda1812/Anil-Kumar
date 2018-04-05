//
//  TecExpertViewController.m
//  Tecprotec
//
//  Created by kishore kumar on 14/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "TecExpertViewController.h"

@interface TecExpertViewController ()

@end

@implementation TecExpertViewController
@synthesize collectionTips;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"TECEXPERT";

    UINib *tipsNib = [UINib nibWithNibName:@"TipsCollectionViewCell" bundle:nil];
    [collectionTips registerNib:tipsNib forCellWithReuseIdentifier:@"TipsCollectionViewCell"];
    arrayTipsDetails = [[NSMutableArray alloc]init];
  
    [collectionTips registerNib:[UINib nibWithNibName:@"TipsHeaderCollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TipsHeaderCollectionReusableView"];
   
    [collectionTips registerNib:[UINib nibWithNibName:@"FooterCollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterCollectionReusableView"];
    
    collectionTips.hidden = YES;
    
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    commonRequest = [CommonRequest sharedInstance];
    commonRequest.delegate = self;
    [commonRequest requestForTopTips:[[[NSUserDefaults standardUserDefaults] objectForKey:@"profile"] objectForKey:@"customerid"]];

    [[Helper sharedInstance] trackingScreen:@"Tecexpert_IOS"];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - Common Request Delegate
- (void)commonRequestGetResponse:(NSDictionary *)response withAPIName:(NSString *)name {
    @try{
        BOOL success = [[response objectForKey:@"success"] boolValue];
        
        NSLog(@"tips value = %@",response);
        
        NSString *failure = [[response objectForKey:@"result"] objectForKey:@"status"];
        //
        if(success)
        {
            [SVProgressHUD dismiss];
            
            if([failure isEqualToString:@"failed"])
            {
                [Helper popUpMessage:[[response objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"Alert" view:[UIView new]];
            }
            else
            {
                arrayTipsDetails = [[response objectForKey:@"result"] objectForKey:@"data"];
                collectionTips.hidden = NO;
                [collectionTips reloadData];
            }
        }
        else
        {
            [SVProgressHUD dismiss];
            [Helper popUpMessage:[[response objectForKey:@"error"] objectForKey:@"message"] titleForPopUp:@"Error" view:[UIView new]];
        }
    }
    @catch(NSException *exception)
    {
        [Helper catchPopUp:[NSString stringWithFormat:@"%@",response] titleForPopUp:@""];
    }
}

#pragma mark - Collection View Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrayTipsDetails.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TipsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TipsCollectionViewCell" forIndexPath:indexPath];
    NSString *imageURL = [NSString stringWithFormat:@"%@%@",BASEIMAGEURL,[[arrayTipsDetails objectAtIndex:indexPath.row] objectForKey:@"imagename"]];
    [cell.tipsImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    NSString *html = [NSString stringWithFormat:@"%@",[[arrayTipsDetails objectAtIndex:indexPath.row] objectForKey:@"question"]];
    NSMutableAttributedString *attrStr = [[[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil] mutableCopy];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Regular" size:15] range:NSMakeRange(0, attrStr.length)];
    
    cell.tipsLblDetails.attributedText = attrStr;
    cell.tipsLblDetails.textAlignment = NSTextAlignmentCenter;
    
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TipsDetailsViewController *tipsDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TipsDetailsViewController"];
    tipsDetailsViewController.strId = [[arrayTipsDetails objectAtIndex:indexPath.row] objectForKey:@"id"];
    tipsDetailsViewController.hidesBottomBarWhenPushed = YES;
    NSLog(@"selected str %@",tipsDetailsViewController.strId);
    [self.navigationController pushViewController:tipsDetailsViewController animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat screenWidth = collectionView.frame.size.width;
    return CGSizeMake(screenWidth/2-10,200);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5,5,5,5);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
   return CGSizeMake(self.view.frame.size.width, 200);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if(arrayTipsDetails.count==0)
        return CGSizeMake(self.view.frame.size.width, 300);
    else
        return CGSizeMake(self.view.frame.size.width, 0);;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    TipsHeaderCollectionReusableView *headerView;
    if (kind == UICollectionElementKindSectionHeader) {
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TipsHeaderCollectionReusableView" forIndexPath:indexPath];
        headerView.btnDeviceHealth.layer.borderWidth = .5;
        headerView.btnDeviceHealth.layer.borderColor = [Helper colorWithHexString:@"FF304B"].CGColor;
        headerView.btnDeviceHealth.layer.cornerRadius = 5;
        [headerView.btnDeviceHealth addTarget:self action:@selector(actionDiagnosis:) forControlEvents:UIControlEventTouchUpInside];
        [headerView.btnDeviceHealth setTitle:NSLocalizedStringFromTableInBundle(@" Device Health Check ", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
        headerView.lblHealthCheck.text = NSLocalizedStringFromTableInBundle(@"Perform a health check now and discover the condition of your device.", nil, [[Helper sharedInstance] getLocalBundle], nil);
        if(arrayTipsDetails.count==0)
        {
            headerView.lblHeightConstraints.constant = 0;
            headerView.lblTipsForYou.text = @"";
        }
        else
        {
            headerView.lblHeightConstraints.constant = 21;
            headerView.lblTipsForYou.text = NSLocalizedStringFromTableInBundle(@"Tips for you", nil, [[Helper sharedInstance] getLocalBundle], nil);
        }
        view = headerView;
    }
    else
    {
        if(arrayTipsDetails.count==0)
        {
            FooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterCollectionReusableView" forIndexPath:indexPath];
            footerView.lblNoTips.text = NSLocalizedStringFromTableInBundle(@"You haven’t purchased a protection plan yet. To access the full features of TecExpert, choose a plan and protect your devices today.", nil, [[Helper sharedInstance] getLocalBundle], nil);
            [footerView.btnExplorePlans setTitle:NSLocalizedStringFromTableInBundle(@"Explore Plans", nil, [[Helper sharedInstance] getLocalBundle], nil)
 forState:UIControlStateNormal];
            [footerView.btnExplorePlans addTarget:self action:@selector(actionHomeScreen:) forControlEvents:UIControlEventTouchUpInside];
            view = footerView;
            //Anda belum memiliki proteksi apapun. Untuk dapat mengakses keseluruhan fitur TecExpert, silahkan membeli proteksi Anda terlebih dahulu
        }
    }
    return view;
}
-(IBAction)actionHomeScreen:(id)sender
{
    [self.tabBarController setSelectedIndex:0];
}
-(IBAction)actionDiagnosis:(id)sender
{
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TechStart"];
    viewController.hidesBottomBarWhenPushed = YES;
    [viewController.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:viewController animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"TECEXPERT"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollPos = collectionTips.contentOffset.y;
    
    if(scrollPos <= 400){
        //Fully hide your toolbar
        [UIView animateWithDuration:2.25 animations:^{
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            
        }];
    } else {
        //Slide it up incrementally, etc.
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
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
