//
//  DetailedTableViewCell.m
//  TECPROTEC
//
//  Created by kishore kumar on 06/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "DetailedTableViewCell.h"

@implementation DetailedTableViewCell
@synthesize planLabel;
@synthesize planDetailsLabel;
@synthesize logoImageView;
@synthesize backgroundCustomView;
@synthesize checkBox;
@synthesize currencyLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

-(void)updateContent: (NSDictionary *)planDict withTablet:(BOOL)isTablet withColorCode:(NSString *)colorCode forIndexPath:(NSIndexPath *)indexPath
{
    NSString *planName = [planDict objectForKey:@"productname"];
    NSString *description = [planDict objectForKey:@"description"];
    NSString *currency = [planDict objectForKey:@"currency_symbol"];
    NSString *price = [planDict objectForKey:@"price_inc_vat"];
    
    planLabel.text = planName;
    backgroundCustomView.backgroundColor = [Helper colorWithHexString:colorCode];
    
    if(isTablet)
    {
        //Only handling proClassic case
        logoImageView.image = [UIImage imageNamed:@"broken2"];
    }
    else
    {
        NSArray *imageArray = @[@"Device",@"popular_plan",@"basic_plan",@"Device"];
        logoImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    }
    
    planDetailsLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:13];
    planDetailsLabel.text = [description stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    NSString *formattedPrice = [[Helper sharedInstance] getCurrencyFormatting:price];
    NSString *from = NSLocalizedStringFromTableInBundle(@"From", nil, [[Helper sharedInstance] getLocalBundle], nil);
    NSString *priceStr = [NSString stringWithFormat:@"%@ %@ %@",from,currency,formattedPrice];
    
    currencyLabel.text = priceStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
