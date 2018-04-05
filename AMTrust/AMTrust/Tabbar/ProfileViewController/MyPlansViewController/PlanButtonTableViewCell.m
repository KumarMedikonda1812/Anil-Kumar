//
//  PlanButtonTableViewCell.m
//  TECPROTEC
//
//  Created by Sethu on 23/2/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import "PlanButtonTableViewCell.h"

@implementation PlanButtonTableViewCell
@synthesize actionButton;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    actionButton.layer.cornerRadius = 5.0f;
    actionButton.layer.masksToBounds = YES;
    actionButton.layer.borderColor = UIColor.blackColor.CGColor;
    actionButton.layer.borderWidth = 1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
