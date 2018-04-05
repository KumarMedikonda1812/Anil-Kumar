//
//  SuccessViewControllerLost.h
//  TecProtec
//
//  Created by kishore kumar on 09/09/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface SuccessViewControllerLost : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImage *imgScreen;
}
@property BOOL success;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imgSuccess;
@property (strong, nonatomic) NSString *successMessage,*policyId;
- (IBAction)ActionSuccess:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn;
- (IBAction)btnCancel:(id)sender;
@end
