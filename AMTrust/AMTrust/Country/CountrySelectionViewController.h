//
//  CountrySelectionViewController.h
//  TecProtec
//
//  Created by kishore kumar on 17/08/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalkthroughViewController.h"

@interface CountrySelectionViewController : UIViewController
{
    IBOutlet UIButton *countryButton;
    IBOutlet UIButton *languageButton;
    IBOutlet UIButton *submitButton;
}

@property BOOL isFromMoreController;

@end
