//
//  TextFieldTableViewCell.h
//  AMTrust
//
//  Created by kishore kumar on 26/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACFloatingTextField.h"

@interface TextFieldTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet ACFloatingTextField *profileTextField;
@property (strong, nonatomic) UIButton *btnPassword;
@property (strong,nonatomic) UIButton *btnEmailQuestion;
@end
