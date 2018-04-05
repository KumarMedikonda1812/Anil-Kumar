//
//  WelcomeViewController.h
//  TECPROTEC
//
//  Created by Sethu on 31/1/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TermsViewController.h"
#import "OnboardingViewController.h"

@interface WelcomeViewController : UIViewController<UIGestureRecognizerDelegate>
{
    IBOutlet UIButton *protectedButton;
    IBOutlet UIButton *protectButton;
    IBOutlet UILabel *loginTitle;
    IBOutlet UIButton *termsButton;
}

@end

