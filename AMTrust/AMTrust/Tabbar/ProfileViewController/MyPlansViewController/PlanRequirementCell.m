//
//  PlanRequirementCell.m
//  TECPROTEC
//
//  Created by Sethu on 23/2/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import "PlanRequirementCell.h"

@implementation PlanRequirementCell
@synthesize leftLabel;
@synthesize statusLabel;
@synthesize uploadButton;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    uploadButton.layer.cornerRadius = 5.0f;
    uploadButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
