//
//  SuccessViewController.h
//  Tecprotec
//
//  Created by kishore kumar on 18/07/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestDataCollectionViewController.h"

@interface SuccessViewController : UIViewController
{
}
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblSecond;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;


@property BOOL successTest;
- (IBAction)ActionContinue:(id)sender;

@end
