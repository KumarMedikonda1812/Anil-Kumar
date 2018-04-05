//
//  TechExpertTableViewCell.h
//  Tecprotec
//
//  Created by kishore kumar on 14/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TechExpertTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgTips;

@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@end
