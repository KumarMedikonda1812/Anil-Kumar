//
//  EditProfileViewController.h
//  AMTrust
//
//  Created by kishore kumar on 26/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldTableViewCell.h"
#import "ImageTableViewCell.h"
#import "AFNetworking.h"
#import "ChangePasswordViewController.h"
#import "ButtonTableViewCell.h"
#import "ChangePasswordViewController.h"

@interface EditProfileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    IBOutlet UITableView *editProfileTableView;
    
    UIImage *profileChoosedImage;
    
    BOOL password;
    BOOL confirmPassword;
    BOOL oldPassword;
    BOOL fbLoginCheck;

    NSDictionary *profileDetails;
    NSString *passwordOne;
    NSString *passwordTwo;
    NSString *oldPasswordString;
    
    NSString *firstName;
    NSString *lastName;
    NSString *mobileNumber;
    NSString *addressStr;
    NSString *cityStr;
    NSString *stateStr;
    NSString *countryStr;
    NSString *postalCodeStr;

    NSURL *urlString;
}
-(void)sendImageValues:(NSString*)fbImage;


@end
