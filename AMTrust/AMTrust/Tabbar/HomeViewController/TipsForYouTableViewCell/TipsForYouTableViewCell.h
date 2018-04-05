//
//  TipsForYouTableViewCell.h
//  AMTrust
//
//  Created by kishore kumar on 05/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipsCollectionViewCell.h"
#import "TipsDetailsViewController.h"

@protocol TipDetailDelegate <NSObject>
@required
-(void)returnTipsDetail:(NSUInteger )number;

@end

@interface TipsForYouTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
{
    IBOutlet UICollectionView *tipsCollectionView;
}

@property( nonatomic, weak) id<TipDetailDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *arrTips;

@end
