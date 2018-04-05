//
//  DetailedTableViewCell.h
//  TECPROTEC
//
//  Created by kishore kumar on 06/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMCheckBox.h"
@interface DetailedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *planLabel;
@property (weak, nonatomic) IBOutlet UILabel *planDetailsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *backgroundCustomView;
@property (weak, nonatomic) IBOutlet BEMCheckBox *checkBox;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;

-(void)updateContent: (NSDictionary *)planDict withTablet:(BOOL)isTablet withColorCode:(NSString *)colorCode forIndexPath:(NSIndexPath *)indexPath;

@end
