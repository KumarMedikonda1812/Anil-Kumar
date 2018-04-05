//
//  TipsDetailsViewController.h
//  Tecprotec
//
//  Created by kishore kumar on 15/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipsDataCollectionViewCell.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"

@interface TipsDetailsViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>
{
    NSMutableArray *arrTips;
}
@property (weak, nonatomic) IBOutlet UICollectionView *tipsCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;
@property (strong, nonatomic) NSString *strId;

@end
