//
//  SummaryScreenTableViewCell.h
//  TecProtec
//
//  Created by kishore kumar on 08/09/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryScreenTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIView *hearderBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgFeatures;

@end
