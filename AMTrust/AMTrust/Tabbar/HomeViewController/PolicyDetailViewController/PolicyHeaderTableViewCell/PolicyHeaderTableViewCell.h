//
//  PolicyHeaderTableViewCell.h
//  Tecprotec
//
//  Created by kishore kumar on 08/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PolicyModel.h"

@interface PolicyHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *multiply;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIView *hearderBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgFeatures;

@property (weak, nonatomic) IBOutlet UIView *threeImageView;
@property (weak, nonatomic) IBOutlet UIView *twoImageView;

@property (weak, nonatomic) IBOutlet UILabel *theftLabel;
@property (weak, nonatomic) IBOutlet UILabel *damageLabel;
@property (weak, nonatomic) IBOutlet UILabel *liquidLabel;

@property (weak, nonatomic) IBOutlet UIImageView *damageImageView;
@property (weak, nonatomic) IBOutlet UIImageView *liquidImageView;

-(void)updateContent:(PolicyModel *)model withIsTablet:(BOOL)isTablet;

@end
