//
//  Helper.h
//  AMTrust
//
//  Created by kishore kumar on 24/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GAI.h"
#import "GAIFields.h"

@interface Helper : NSObject

+ (instancetype)sharedInstance;
+ (UIColor *)colorWithHexString:(NSString *)colorString;
+ (float) getHeightForText:(NSString*) text withFont:(UIFont*) font andWidth:(float) width;
+ (void)popUpMessage:(NSString *)message titleForPopUp:(NSString *)title view:(UIView *)viewSelf;
+ (void)popUpMessage:(NSString *)message titleForPopUp:(NSString *)title buttonTitle:(NSString*)strButton;
+(void)showAlert:(NSString *)message titleForPopUp:(NSString *)title view:(UIView *)viewSelf handler:(void (^)(_Bool OkbuttonPressed))completion;
+ (void)catchPopUp:(NSString *)message titleForPopUp:(NSString *)title;
+ (BOOL) NSStringIsValidEmail:(NSString *)checkString;
+ (void)showConnectionFailed;
+ (NSString *)countryCode;

- (void)trackingScreen:(NSString *)screenName;
- (BOOL)mobileNumberValidate:(NSString*)number;
- (void)getTokenString;
- (NSString *)deviceModelName;
- (BOOL)isLogin;
- (NSBundle *)getLocalBundle;
- (NSString *)getCurrencyFormatting:(NSString *)cost;
- (BOOL)checkForNull:(NSString *)processValue;
- (BOOL)shouldShowRenewButton:(NSArray *)categoryArray withCurrentDict:(NSDictionary *)dict;

@end
