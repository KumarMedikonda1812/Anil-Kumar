//
//  OTPViewController.h
//  AMTrust
//
//  Created by kishore kumar on 30/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACFloatingTextField.h"
#import "SummaryViewController.h"

@interface OTPViewController : UIViewController
{
    IBOutlet ACFloatingTextField *firstTextField;
    IBOutlet ACFloatingTextField *secondTextField;
    IBOutlet ACFloatingTextField *thirdTextField;
    IBOutlet ACFloatingTextField *fifthTextField;
    
    IBOutlet UILabel *resendLbl;
    IBOutlet UILabel *lblVerify;
    IBOutlet UILabel *lblSecond;
    IBOutlet UILabel *lblReceived;
    IBOutlet UIButton *btnLogin;
}

@property (strong, nonatomic) NSString *mobileNumber;
@property (strong, nonatomic) NSString *strimei;
@property (strong, nonatomic) NSString *strMake;
@property (strong, nonatomic) NSString *originScreen;

@property  BOOL isPresentedModally;
@property  BOOL isTablet;
@property BOOL isFromLogin;

@end
