//
//  TipsDataCollectionViewCell.h
//  TecProtec
//
//  Created by kishore kumar on 04/08/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipsDataCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tipsImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLblDetails;
@property (weak, nonatomic) IBOutlet UILabel *tipsLblHeader;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControllerTips;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
