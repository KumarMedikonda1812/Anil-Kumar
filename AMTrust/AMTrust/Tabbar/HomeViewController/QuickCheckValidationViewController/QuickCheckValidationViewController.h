//
//  QuickCheckValidationViewController.h
//  Tecprotec
//
//  Created by kishore kumar on 08/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLProgressBar.h"
#import "QuickCheckResultViewController.h"
#import "QuickTestResultViewController.h"

@interface QuickCheckValidationViewController : UIViewController
{
    BOOL wifiBool,dataConnectionBool,batteryBool,gyroBool,bluetoothBool,gpsBool;
    
    NSTimer *twoMinTimer;
    
    NSInteger tenSeconds;
    
    CGFloat tenCount;
}
@property (weak, nonatomic) IBOutlet UILabel *lblGiveUsaMoment;
@property (weak, nonatomic) IBOutlet YLProgressBar *progressBarLength;
@end
