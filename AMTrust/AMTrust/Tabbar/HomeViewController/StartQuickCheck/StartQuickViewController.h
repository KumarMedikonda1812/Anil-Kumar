//
//  StartQuickViewController.h
//  Tecprotec
//
//  Created by kishore kumar on 12/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickDiagonasisTestViewController.h"

@interface StartQuickViewController : UIViewController
{
}
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDetails;
@property (weak, nonatomic) IBOutlet UIButton *btnStartNow;
- (IBAction)ActionHealthCheck:(id)sender;

@end
