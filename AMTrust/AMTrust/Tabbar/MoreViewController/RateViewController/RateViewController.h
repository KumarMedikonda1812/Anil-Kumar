//
//  RateViewController.h
//  AMTrust
//
//  Created by kishore kumar on 25/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface RateViewController : UIViewController
{
    NSInteger ratings;
}

@property (weak, nonatomic) IBOutlet UITextField *reviewTextField;
@property (weak, nonatomic) IBOutlet UIButton *btnOne;
@property (weak, nonatomic) IBOutlet UIButton *btnTwo;
@property (weak, nonatomic) IBOutlet UIButton *btnThree;
@property (weak, nonatomic) IBOutlet UIButton *btnFour;
@property (weak, nonatomic) IBOutlet UIButton *btnFive;
@property (weak, nonatomic) IBOutlet UIButton *btnRateUs;


- (IBAction)ActionSubmitReview:(id)sender;
- (IBAction)ActionBtnOne:(id)sender;
- (IBAction)ActionBtnTwo:(id)sender;
- (IBAction)ActionBtnThree:(id)sender;
- (IBAction)ActionBtnFour:(id)sender;
- (IBAction)ActionBtnFive:(id)sender;

@end
