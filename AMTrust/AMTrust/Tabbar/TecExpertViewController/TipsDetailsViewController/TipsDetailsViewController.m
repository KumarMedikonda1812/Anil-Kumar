//
//  TipsDetailsViewController.m
//  Tecprotec
//
//  Created by kishore kumar on 15/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "TipsDetailsViewController.h"

@interface TipsDetailsViewController ()

@end

@implementation TipsDetailsViewController
@synthesize tipsCollectionView,strId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"TECEXPERT";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackMore"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    backButton.tintColor = [Helper colorWithHexString:@"FF304B"];
    self.navigationItem.leftBarButtonItem = backButton;
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    arrTips = [[NSMutableArray alloc]init];

    [self tecProtecDetails];
    
    UINib *tipsNib = [UINib nibWithNibName:@"TipsDataCollectionViewCell" bundle:nil];
    [tipsCollectionView registerNib:tipsNib forCellWithReuseIdentifier:@"TipsDataCollectionViewCell"];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    tipsCollectionView.collectionViewLayout = layout;

}

-(void)tecProtecDetails
{
    [SVProgressHUD showWithStatus:@"Updating.."];
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    NSString *apiLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"ApiCurrentLanguage"];
    response.POSTDictionary =@{@"operation":@"ams.tipdetail",
                               @"sessionName":sessionName,
                               @"support_id":strId,
                               @"language":apiLanguage
                               };
    
    NSLog(@"this is tips data= %@",response.POSTDictionary);
    
    
    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        @try {
            
            NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&error];
            
            json = [json replaceNullsWithObject:@"NA"];

            BOOL success = [[json objectForKey:@"success"] boolValue];
            
            NSLog(@"tips value = %@",json);
            
            
            NSString *failure = [[json objectForKey:@"result"] objectForKey:@"status"];
            //
            if(success)
            {
                [SVProgressHUD dismiss];
                
                if([failure isEqualToString:@"failed"]||[failure isEqualToString:@"failure"])
                {
                    [Helper popUpMessage:[[json objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"Alert" view:[UIView new]];
                }
                else
                {
                    arrTips = [[json objectForKey:@"result"] objectForKey:@"data"];
                    self.pageController.numberOfPages = arrTips.count;
                    self.pageController.currentPage = 0;
                    [tipsCollectionView reloadData];
                }
            }
            else
            {
                [SVProgressHUD dismiss];
                [Helper popUpMessage:[[json objectForKey:@"error"] objectForKey:@"message"] titleForPopUp:@"Error" view:[UIView new]];
            }
        } @catch (NSException *exception) {
            
            [Helper catchPopUp:body titleForPopUp:@""];
        }
    };
    response.errorBlock = ^(NSError *error) {
        // ...
        [SVProgressHUD dismiss];
        [Helper popUpMessage:error.localizedDescription titleForPopUp:@"Error" view:[UIView new]];
    };
    
    [response startAsynchronous];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    [[Helper sharedInstance] trackingScreen:@"TecexpertDetail_IOS"];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrTips.count;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TipsDataCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TipsDataCollectionViewCell" forIndexPath:indexPath];
    
    NSString *imageURL = [NSString stringWithFormat:@"%@%@",BASEIMAGEURL,[[arrTips objectAtIndex:indexPath.row] objectForKey:@"tip_detail_image_url"]];
    [cell.tipsImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    NSString *html = [NSString stringWithFormat:@"%@",[[arrTips objectAtIndex:indexPath.row] objectForKey:@"tip_sup_answer"]];
    NSMutableAttributedString *attrStr = [[[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil] mutableCopy];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Regular" size:15] range:NSMakeRange(0, attrStr.length)];
    
    cell.tipsLblDetails.attributedText = attrStr;
    cell.tipsLblDetails.textAlignment = NSTextAlignmentCenter;
    
    cell.tipsLblHeader.text = [NSString stringWithFormat:@"%@",[[arrTips objectAtIndex:indexPath.row] objectForKey:@"tip_detail_name"]];
    self.pageController.currentPage = indexPath.row;
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];
    tapGesture1.numberOfTapsRequired = 1;
    [tapGesture1 setDelegate:self];
    cell.tipsImageView.tag = indexPath.row;
    cell.tipsImageView.userInteractionEnabled = YES;
    [cell.tipsImageView addGestureRecognizer:tapGesture1];
    
 //   CGFloat screenHeight = [Helper getHeightForText:cellHeight withFont:[UIFont systemFontOfSize:20] andWidth:screenWidth]+screenRect.size.height+100;
    //cell.scrollView.contentSize = CGSizeMake(screenWidth, screenHeight);

    return cell;
}
- (void)tapGesture:(id)sender
{
    UIGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    NSInteger tag = gesture.view.tag;
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    NSString *imageURL = [NSString stringWithFormat:@"%@%@",BASEIMAGEURL,[[arrTips objectAtIndex:tag] objectForKey:@"tip_detail_image_url"]];
    UIImageView *imgView = [[UIImageView alloc]init];
    [imgView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    imageInfo.image = imgView.image;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
//    if(screenHeight<screenHeight+screenRect.size.height*0.8)
//    {
//        screenHeight = screenRect.size.height;
//    }
    return CGSizeMake(screenWidth,screenRect.size.height-100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(1,1,1,1);
}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    
//    for (TipsDataCollectionViewCell *cell in [tipsCollectionView visibleCells]) {
//        NSIndexPath *indexPath = [tipsCollectionView indexPathForCell:cell];
//        
//        NSLog(@"index path = %lu",indexPath.row);
//    }
//
//}

-(IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat scrollPos = tipsTableView.contentOffset.y ;
//    
//    if(scrollPos <= 400){
//        //Fully hide your toolbar
//        [UIView animateWithDuration:2.25 animations:^{
//            [self.navigationController setNavigationBarHidden:YES animated:YES];
//            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//            
//        }];
//    } else {
//        //Slide it up incrementally, etc.
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }
//    
//}



#pragma mark - <RMPZoomTransitionAnimating>

//- (UIImageView *)transitionSourceImageView
//{
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.imgMainView.image];
//    imageView.contentMode = self.imgMainView.contentMode;
//    imageView.clipsToBounds = YES;
//    imageView.userInteractionEnabled = NO;
//    imageView.frame = self.imgMainView.frame;
//    return imageView;
//}
//
//- (UIColor *)transitionSourceBackgroundColor
//{
//    return self.view.backgroundColor;
//}
//
//- (CGRect)transitionDestinationImageViewFrame
//{
//    CGFloat width = CGRectGetWidth(self.view.frame);
//    CGRect frame = self.imgMainView.frame;
//    frame.size.width = width;
//    return frame;
//}

#pragma mark - <RMPZoomTransitionDelegate>

//- (void)zoomTransitionAnimator:(RMPZoomTransitionAnimator *)animator
//         didCompleteTransition:(BOOL)didComplete
//      animatingSourceImageView:(UIImageView *)imageView
//{
//    self.imgMainView.image = imageView.image;
//}

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
