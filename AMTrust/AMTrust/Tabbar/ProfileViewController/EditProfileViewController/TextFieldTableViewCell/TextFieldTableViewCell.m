//
//  TextFieldTableViewCell.m
//  AMTrust
//
//  Created by kishore kumar on 26/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "TextFieldTableViewCell.h"

@implementation TextFieldTableViewCell
@synthesize btnPassword,btnEmailQuestion;
- (void)awakeFromNib {
    [super awakeFromNib];
    
    btnPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEmailQuestion = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPassword setBackgroundImage:[UIImage imageNamed:@"unhide"] forState:UIControlStateNormal];
    [btnEmailQuestion setBackgroundImage:[UIImage imageNamed:@"question"] forState:UIControlStateNormal];
    [self addSubview:btnPassword];
    [self addSubview:btnEmailQuestion];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
