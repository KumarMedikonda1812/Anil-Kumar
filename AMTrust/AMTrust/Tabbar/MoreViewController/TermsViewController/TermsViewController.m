//
//  TermsViewController.m
//  AMTrust
//
//  Created by kishore kumar on 25/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "TermsViewController.h"

@interface TermsViewController ()

@end

@implementation TermsViewController

    @synthesize terms;

    - (void)viewDidLoad {
        [super viewDidLoad];
        
        [self setupNavigation];
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];

        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];

        webView = [[WKWebView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, self.view.frame.size.height) configuration:configuration] ;
        webView.UIDelegate = self;
        webView.navigationDelegate = self;
        [webView.scrollView setShowsVerticalScrollIndicator:NO];

        [self.view addSubview:webView];
        
        if([_strTitle isEqualToString:@"Disclaimer"])
        {
            self.title = NSLocalizedStringFromTableInBundle(@"Disclaimer", nil, [[Helper sharedInstance] getLocalBundle], nil);
            [self setupDisclaimer];
        }
        else if([_strTitle isEqualToString:@"Privacy policy"])
        {
            self.title = NSLocalizedStringFromTableInBundle(@"Privacy policy", nil, [[Helper sharedInstance] getLocalBundle], nil);
            [self getData:@"ams.privacypolicy"];
        }
        else
        {
            self.title = NSLocalizedStringFromTableInBundle(@"About us", nil, [[Helper sharedInstance] getLocalBundle], nil);
            [self getData:@"ams.aboutus"];
        }
        
    }
    
    -(void)viewWillAppear:(BOOL)animated
    {
        [super viewWillAppear:animated];
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationController.navigationBar.backgroundColor = TABBARCOLOR;
        self.navigationController.navigationBar.translucent = NO;
        
        [[Helper sharedInstance] trackingScreen:_strTitle];

    }
    
    -(void)setupDisclaimer
    {
        NSString *apiLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"ApiCurrentLanguage"];
        NSString *englishPath = [[NSBundle mainBundle] pathForResource: @"Disclaimer" ofType: @"html"];
        NSString *bahasaPath = [[NSBundle mainBundle] pathForResource: @"DisclaimerBahasa" ofType: @"html"];

        if([apiLanguage isEqualToString:@"english"])
        {
            NSString *res = [NSString stringWithContentsOfFile: englishPath encoding:NSUTF8StringEncoding error: nil];
            [self loadHTMLString:res];
        }else
        {
            NSString *res = [NSString stringWithContentsOfFile: bahasaPath encoding:NSUTF8StringEncoding error: nil];
            [self loadHTMLString:res];
        }
    }
    
    -(void)setupNavigation
    {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackMore"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
        backButton.tintColor = [Helper colorWithHexString:@"FF304B"];
        
        self.navigationItem.leftBarButtonItem = backButton;
    }

    -(void)getData:(NSString *)operation
    {
        [SVProgressHUD showWithStatus:@"Loading.."];
        
        STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
        
        NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
        NSString *apiLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"ApiCurrentLanguage"];
        response.POSTDictionary =@{@"operation":operation,
                                   @"sessionName":sessionName,
                                   @"language":apiLanguage,
                                   @"currency_id":@"138"
                                   };
        
        
        NSLog(@"this is tips data= %@",response.POSTDictionary);
        
        response.completionBlock = ^(NSDictionary *headers, NSString *body) {
            NSError* error;
            
            @try{
                NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:kNilOptions
                                                                              error:&error];
                
                json = [json replaceNullsWithObject:@"NA"];
                
                BOOL success = [[json objectForKey:@"success"] boolValue];
                
                NSLog(@"category details value = %@",json);
                
                NSString *failure = [[json objectForKey:@"result"] objectForKey:@"status"];

                if(success)
                {
                    [SVProgressHUD dismiss];
                    
                    if([failure isEqualToString:@"failed"])
                    {
                        [Helper popUpMessage:[[json objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"Alert" view:[UIView new]];
                    }
                    else
                    {
                        NSString *text = [[[json objectForKey:@"result"] objectForKey:@"data"] objectForKey:@"page_content"];
                        NSString *strArticleData = [NSString stringWithFormat:@"%@",text];
                        NSString *worstCode = [strArticleData stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
                        NSString *bulletString = [worstCode stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
                        NSString *finalStr = [NSString stringWithFormat:@"%@ <br><br><br><br><br>",bulletString];
                        
                        [self loadHTMLString:finalStr];
                    }
                }
                else
                {
                    [SVProgressHUD dismiss];
                    [Helper popUpMessage:[[json objectForKey:@"error"] objectForKey:@"message"] titleForPopUp:@"Error" view:[UIView new]];
                }
                
            }@catch(NSException *exception)
            {
                [Helper catchPopUp:body titleForPopUp:@""];
            }
        };
        response.errorBlock = ^(NSError *error) {
            // ...
            [SVProgressHUD dismiss];
            [Helper popUpMessage:error.localizedDescription titleForPopUp:@"Error" view:[UIView new]];
        };
        
        [response startAsynchronous];
        
    }
    
    -(void)loadHTMLString:(NSString *)htmlString
    {
        NSString *strCssHead = [NSString stringWithFormat:@"<head>"
                                "<link rel=\"stylesheet\" type=\"text/css\" href=\"terms.css\">"
                                "</head>"];
        
        NSString *strBody = [NSString stringWithFormat:@"<body><p>%@</p></body>",htmlString];
        
        [webView loadHTMLString:[NSString stringWithFormat:@"%@%@",strCssHead,strBody]
                        baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"terms" ofType:@"css"]]];
    }
    
    - (IBAction)backBarButton:(id)sender {
        [webView goBack];
    }

    - (IBAction)reloadBarButton:(id)sender {
        [webView reload];
    }

    - (IBAction)forwardBarButton:(id)sender {
        [webView goForward];
    }
    
    - (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
    }

@end
