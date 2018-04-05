//
//  TermsViewController.h
//  AMTrust
//
//  Created by kishore kumar on 25/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface TermsViewController : UIViewController<WKNavigationDelegate,WKUIDelegate>
{
    WKWebView *webView;
}
@property (weak, nonatomic) IBOutlet UILabel *textEdit;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewWidth;
    
@property BOOL terms;
@property (strong) NSString *strTitle;
@end
