//
//  SignUpViewController.h
//  AMTrust
//
//  Created by kishore kumar on 01/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "ACFloatingTextField.h"
#import "OTPViewController.h"
#import "LoginViewController.h"

@interface SignUpViewController : UIViewController<CommonRequestDelegate>
{    
    IBOutlet UIButton *eyeButton;
    IBOutlet ACFloatingTextField *firstNameTxtField;
    IBOutlet ACFloatingTextField *mobileTxtField;
    IBOutlet ACFloatingTextField *emailTextField;
    IBOutlet ACFloatingTextField *imeiTextField;
    IBOutlet ACFloatingTextField *addressTextField;
    IBOutlet ACFloatingTextField *passwordTextField;
    IBOutlet ACFloatingTextField *lastNameTxtField;
    IBOutlet TPKeyboardAvoidingScrollView *signUpScrollView;
    IBOutlet ACFloatingTextField *postalTextField;
    IBOutlet ACFloatingTextField *addressLineTwo;
    
    IBOutlet UIButton *btnDone;
    IBOutlet UIView *contentView;
    IBOutlet UILabel *lblCreateAccount;
    
    CommonRequest *commonRequest;
}

@property  BOOL fbVariation;
@property (strong, nonatomic) NSDictionary *fbDic;
@property (strong, nonatomic)  NSString *originScreen;
@property  BOOL isPresentedModally;

@end
