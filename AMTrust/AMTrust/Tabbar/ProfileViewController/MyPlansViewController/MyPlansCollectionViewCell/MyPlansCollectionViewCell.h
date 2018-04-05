//
//  MyPlansCollectionViewCell.h
//  AMTrust
//
//  Created by kishore kumar on 31/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPlansCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIView *addCellView;
@property (weak, nonatomic) IBOutlet UIView *planCellView;

@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDetails;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintsForAdd;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UILabel *lblProductDetails;




@end
