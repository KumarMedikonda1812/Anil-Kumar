//
//  TermsAndConditionTableViewCell.h
//  TecProtec
//
//  Created by kishore kumar on 08/09/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMCheckBox.h"
@interface TermsAndConditionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet BEMCheckBox *bemCheckBox;
@property (weak, nonatomic) IBOutlet BEMCheckBox *bemCheckBoxThree;
@property (weak, nonatomic) IBOutlet BEMCheckBox *bemCheckBoxTwo;

@property (weak, nonatomic) IBOutlet UILabel *lblTermsAndCondition;
@property (weak, nonatomic) IBOutlet UILabel *lblPrivacyPolicy;
@property (weak, nonatomic) IBOutlet UILabel *lblMobileTermsandCondition;


@end
