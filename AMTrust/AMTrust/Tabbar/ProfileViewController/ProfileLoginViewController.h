//
//  ProfileLoginViewController.h
//  TECPROTEC
//
//  Created by Sethu on 31/1/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "FacebookViewController.h"

@interface ProfileLoginViewController : UIViewController
    
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@end
