//
//  WebViewController.m
//  TECPROTEC
//
//  Created by Sethu on 4/2/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize webViewLoading,check;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"Loading.."];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackMore"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    backButton.tintColor = [Helper colorWithHexString:@"#FF304B"];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if(!check)
    {
        NSString *urlLoad = [NSString stringWithFormat:@"http://cl.amtrustmobilesolutions.asia/portal/login_submit_new.php?imei=%@&mobile=%@&country=indo",_strImei,_strPhonenumber];
        
        [webViewLoading loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlLoad]]];
        NSLog(@"this is url load = %@",urlLoad);
        
        NSString *jsCommand = [NSString stringWithFormat:@"document.body.style.zoom = 1.5;"];
        [webViewLoading stringByEvaluatingJavaScriptFromString:jsCommand];
        webViewLoading.scalesPageToFit = YES;
        self.navigationItem.title = @"Claim";
        self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"Claim", nil, [[Helper sharedInstance] getLocalBundle], nil);
    }
    else
    {
        [webViewLoading loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_strURL]]]];
        NSString *jsCommand = [NSString stringWithFormat:@"document.body.style.zoom = 1.5;"];
        self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"Terms & Conditions", nil, [[Helper sharedInstance] getLocalBundle], nil);
        [webViewLoading stringByEvaluatingJavaScriptFromString:jsCommand];
        webViewLoading.scalesPageToFit = YES;
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

