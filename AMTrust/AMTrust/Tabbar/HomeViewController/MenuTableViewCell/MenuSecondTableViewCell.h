//
//  MenuSecondTableViewCell.h
//  TecProtec
//
//  Created by kishore kumar on 31/07/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuSecondTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblFrom;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrecy;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblPaise;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UILabel *lblPerDay;

-(void)updateContent:(NSDictionary *)dict;

@end
