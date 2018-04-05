//
//  WebViewController.h
//  TECPROTEC
//
//  Created by Sethu on 4/2/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webViewLoading;
@property BOOL check;
@property (strong, nonatomic) NSString *strURL;
@property (strong, nonatomic) NSString *strImei;
@property (strong, nonatomic) NSString *strPhonenumber;

@end
