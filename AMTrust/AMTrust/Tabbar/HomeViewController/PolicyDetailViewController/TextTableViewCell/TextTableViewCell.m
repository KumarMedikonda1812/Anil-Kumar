//
//  TextTableViewCell.m
//  TecProtec
//
//  Created by kishore kumar on 31/08/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "TextTableViewCell.h"

@implementation TextTableViewCell
@synthesize lblText;
@synthesize lblTitle;
@synthesize imgView;

- (void)awakeFromNib {
    [super awakeFromNib];

    imgView.image = [UIImage imageNamed:@"Oval"];
}

-(void)updateText:(NSString *)textStr
{
    NSString *outputStr = [textStr stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
    
    NSMutableAttributedString *attrStr = [[[NSAttributedString alloc] initWithData:[outputStr dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil] mutableCopy];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Regular" size:15] range:NSMakeRange(0, attrStr.length)];
    lblText.attributedText = attrStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
