//
//  BuyOptionTableViewCell.m
//  TECPROTEC
//
//  Created by kishore kumar on 06/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "BuyOptionTableViewCell.h"

@implementation BuyOptionTableViewCell
@synthesize costLabel;
@synthesize dateLabel;
@synthesize isTablet;
@synthesize costTextField;
@synthesize dateTextField;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clipsToBounds = YES;
    costTextField.tag = 0;
    dateTextField.tag = 1;

}

-(void)updateContent
{
    costTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Gadget price", nil, [[Helper sharedInstance] getLocalBundle], nil);
    
    dateTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Date", nil, [[Helper sharedInstance] getLocalBundle], nil);

    if(isTablet)
    {
        costLabel.text = NSLocalizedStringFromTableInBundle(@"How much did your tablet cost?", nil, [[Helper sharedInstance] getLocalBundle], nil);
        dateLabel.text = NSLocalizedStringFromTableInBundle(@"When did you buy your tablet?", nil, [[Helper sharedInstance] getLocalBundle], nil);
    }else
    {
        costLabel.text = NSLocalizedStringFromTableInBundle(@"How much did your gadget cost?", nil, [[Helper sharedInstance] getLocalBundle], nil);
        dateLabel.text = NSLocalizedStringFromTableInBundle(@"When did you buy your gadget?", nil, [[Helper sharedInstance] getLocalBundle], nil);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
