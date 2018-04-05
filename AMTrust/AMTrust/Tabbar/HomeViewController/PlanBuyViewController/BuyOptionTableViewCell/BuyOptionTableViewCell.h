//
//  BuyOptionTableViewCell.h
//  TECPROTEC
//
//  Created by kishore kumar on 06/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyOptionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *costTextField;

@property BOOL isTablet;

-(void)updateContent;

@end
