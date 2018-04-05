//
//  MyActivitiesTableViewCell.h
//  AMTrust
//
//  Created by kishore kumar on 31/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyActivitiesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *myActivityView;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@end
