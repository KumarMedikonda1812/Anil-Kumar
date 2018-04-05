//
//  TestDataCollectionViewController.h
//  Tecprotec
//
//  Created by kishore kumar on 18/07/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACFloatingTextField.h"
#import "PolicyDetailViewController.h"
#import "AFNetworking.h"
#import "SummaryViewController.h"
#import "LoginViewController.h"

@interface TestDataCollectionViewController : UIViewController<UITextFieldDelegate>
{
    UIPickerView *monthPickerView;
    NSArray *arrMonth;
    NSMutableArray *arrYear;
    BOOL textFieldBool;
    
    IBOutlet ACFloatingTextField *firstNameTextField;
    IBOutlet ACFloatingTextField *lastNameTextField;
    IBOutlet ACFloatingTextField *mobileTextField;
    IBOutlet ACFloatingTextField *emailTextField;
    IBOutlet ACFloatingTextField *imeiTextField;
    IBOutlet ACFloatingTextField *makeTextField;
    IBOutlet ACFloatingTextField *addressTextField;
    IBOutlet ACFloatingTextField *passwordTextField;
    IBOutlet ACFloatingTextField *addressLineTwoTextField;
    IBOutlet ACFloatingTextField *postalCodeAddress;

    IBOutlet UIButton *btnPassword;
    IBOutlet UILabel *lblTitle;
    IBOutlet UIButton *btnProceedtoSummary;
    
    IBOutlet NSLayoutConstraint *topSpaceConstraints;
    IBOutlet NSLayoutConstraint *heightConstraints;
}

@property BOOL isTablet;

@end
