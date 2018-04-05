//
//  PolicyHeaderTableViewCell.m
//  Tecprotec
//
//  Created by kishore kumar on 08/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "PolicyHeaderTableViewCell.h"

@implementation PolicyHeaderTableViewCell
@synthesize damageLabel;
@synthesize damageImageView;
@synthesize liquidLabel;
@synthesize liquidImageView;
@synthesize btnBack;
@synthesize lblHeader;
@synthesize lblDescription;
@synthesize hearderBackground;
@synthesize theftLabel;
@synthesize imgFeatures;
@synthesize threeImageView;
@synthesize twoImageView;

- (void)awakeFromNib {
    [super awakeFromNib];

    theftLabel.text = NSLocalizedStringFromTableInBundle(@"Theft", nil, [[Helper sharedInstance] getLocalBundle], nil);
    damageLabel.text = NSLocalizedStringFromTableInBundle(@"Damage", nil, [[Helper sharedInstance] getLocalBundle], nil);
    liquidLabel.text = NSLocalizedStringFromTableInBundle(@"Liquid", nil, [[Helper sharedInstance] getLocalBundle], nil);
}

-(void)updateContent:(PolicyModel *)model withIsTablet:(BOOL)isTablet
{
    lblHeader.text = model.planName;
    lblDescription.text = model.planDescriptions;
    
    if([model.planName isEqualToString:@"proPREMIUM"])
    {
        threeImageView.hidden = NO;
        twoImageView.hidden = YES;
    }else{
        threeImageView.hidden = YES;
        twoImageView.hidden = NO;
    }
    
    if(isTablet)
    {
        damageImageView.image = [UIImage imageNamed:@"broken2"];
        liquidImageView.image = [UIImage imageNamed:@"water2"];
    }else{
        damageImageView.image = [UIImage imageNamed:@"broken"];
        liquidImageView.image = [UIImage imageNamed:@"water"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
