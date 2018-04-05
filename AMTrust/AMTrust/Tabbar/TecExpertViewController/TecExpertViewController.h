//
//  TecExpertViewController.h
//  Tecprotec
//
//  Created by kishore kumar on 14/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TechExpertTableViewCell.h"
#import "TechHeaderTableViewCell.h"
#import "TipsDetailsViewController.h"
#import "QuickDiagonasisTestViewController.h"
#import "TipsForYouTableViewCell.h"
#import "TipsHeaderCollectionReusableView.h"
#import "FooterCollectionReusableView.h"

@interface TecExpertViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,CommonRequestDelegate>
{
    NSMutableArray *arrayTipsDetails;
    CommonRequest *commonRequest;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionTips;
@end
