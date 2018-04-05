//
//  MyClaimDetailsTableViewCell.m
//  AMTrust
//
//  Created by kishore kumar on 01/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "MyClaimDetailsTableViewCell.h"

@implementation MyClaimDetailsTableViewCell
@synthesize viewBackground;
- (void)awakeFromNib {
    [super awakeFromNib];
    
    viewBackground.layer.borderWidth = 1;
    viewBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
