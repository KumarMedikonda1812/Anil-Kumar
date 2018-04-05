//
//  MyActivitiesTableViewCell.m
//  AMTrust
//
//  Created by kishore kumar on 31/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "MyActivitiesTableViewCell.h"

@implementation MyActivitiesTableViewCell
@synthesize myActivityView;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    myActivityView.layer.borderWidth = 1;
    myActivityView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
