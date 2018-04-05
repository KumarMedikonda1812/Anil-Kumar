//
//  WalkthroughCollectionViewCell.h
//  TECPROTEC
//
//  Created by Sethu on 29/1/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalkthroughCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *walkthroughHeader;
@property (weak, nonatomic) IBOutlet UILabel *walkthroughDetails;
@property (weak, nonatomic) IBOutlet UIImageView *walkthroughImageView;

@end
