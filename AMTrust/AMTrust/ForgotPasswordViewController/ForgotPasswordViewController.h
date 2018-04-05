//
//  ForgotPasswordViewController.h
//  AMTrust
//
//  Created by kishore kumar on 05/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACFloatingTextField.h"
#import "OTPViewController.h"

@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate>
{
    UIToolbar *ViewForDoneButtonOnKeyboard;
    
    IBOutlet ACFloatingTextField *forgetPasswordEmailTextField;
    IBOutlet ACFloatingTextField *phoneNumberTextField;
}

@end
