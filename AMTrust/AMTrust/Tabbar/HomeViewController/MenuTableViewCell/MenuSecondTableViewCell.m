//
//  MenuSecondTableViewCell.m
//  TecProtec
//
//  Created by kishore kumar on 31/07/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "MenuSecondTableViewCell.h"

@implementation MenuSecondTableViewCell
@synthesize lblHeader;
@synthesize lblFrom;
@synthesize img;
@synthesize lblCurrecy;
@synthesize lblPrice;
@synthesize lblPaise;
@synthesize lblDay;
@synthesize lblPerDay;

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)updateContent:(NSDictionary *)dict
{
    lblHeader.text = [dict objectForKey:@"device_category"];
    lblPrice.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"price_inc_vat"]];
    NSString *srtUrl = [NSString stringWithFormat:@"%@%@",BASEIMAGEURL,[dict objectForKey:@"imagename"]];
    
    lblPerDay.text = NSLocalizedStringFromTableInBundle(@"Per Day", nil, [[Helper sharedInstance] getLocalBundle], nil);
    lblFrom.text = NSLocalizedStringFromTableInBundle(@"From", nil, [[Helper sharedInstance] getLocalBundle], nil);
    
    [img sd_setImageWithURL:[NSURL URLWithString:srtUrl] placeholderImage:[UIImage imageNamed:@"tablet_plan"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
