//
//  ChangePasswordViewController.h
//  TecProtec
//
//  Created by kishore kumar on 08/09/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACFloatingTextField.h"
@interface ChangePasswordViewController : UIViewController
{
    BOOL textOne,textTwo,textThree;
}
@property (weak, nonatomic) IBOutlet ACFloatingTextField *currentPasswordTextField;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *PasswordTextField;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *confirmPasswordTextField;
- (IBAction)ActionCurrentPassword:(id)sender;
- (IBAction)ActionNewPassword:(id)sender;
- (IBAction)ActionConfirmPassword:(id)sender;
@end
