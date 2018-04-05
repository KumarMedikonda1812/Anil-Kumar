//
//  LoginViewController.
//  AMTrust
//
//  Created by kishore kumar on 29/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize shouldShowTabBarOnSuccess;
@synthesize originScreen;
    
- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self setupKeyboardDone:emailTextField];
    
    plusConstraints.constant = 0;
    
    [self updateLanguage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [[Helper sharedInstance] trackingScreen:@"LOGIN_IOS"];
    
    [emailTextField becomeFirstResponder];
}

- (void)updateLanguage
{
    [segmentController setTitle:NSLocalizedStringFromTableInBundle(@"Email", nil, [[Helper sharedInstance] getLocalBundle], nil) forSegmentAtIndex:0];
    [segmentController setTitle:NSLocalizedStringFromTableInBundle(@"Mobile number", nil, [[Helper sharedInstance] getLocalBundle], nil) forSegmentAtIndex:1];
    
    lblLogin.text = NSLocalizedStringFromTableInBundle(@"Login", nil, [[Helper sharedInstance] getLocalBundle], nil);
    
    lblOr.text = NSLocalizedStringFromTableInBundle(@"OR", nil, [[Helper sharedInstance] getLocalBundle], nil);
    
    [btnLogin setTitle:NSLocalizedStringFromTableInBundle(@"Login", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
    [btnForgotPassword setTitle:NSLocalizedStringFromTableInBundle(@"Forgot password?", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
    
    emailTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Email", nil, [[Helper sharedInstance] getLocalBundle], nil);
    passwordTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Password", nil, [[Helper sharedInstance] getLocalBundle], nil);
    [btnFb setTitle:NSLocalizedStringFromTableInBundle(@"Login with facebook", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
}

- (void)setupKeyboardDone:(UITextField *)textField
{
    UIToolbar *ViewForDoneButtonOnKeyboard = [[UIToolbar alloc] init];
    [ViewForDoneButtonOnKeyboard sizeToFit];
    ViewForDoneButtonOnKeyboard.hidden = YES;
    UIBarButtonItem *btnDoneOnKeyboard = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                          style:UIBarButtonItemStylePlain target:self
                                                                         action:@selector(doneBtnFromKeyboardClicked:)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [ViewForDoneButtonOnKeyboard setItems:[NSArray arrayWithObjects:flexible,btnDoneOnKeyboard, nil]];

    textField.inputAccessoryView = ViewForDoneButtonOnKeyboard;
}

-(void)redirectToOTP
{
    NSString *mobileNumber = [NSString stringWithFormat:@"%@",emailTextField.text];
    
    OTPViewController *otpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OTPViewController"];
    otpViewController.mobileNumber = mobileNumber;
    otpViewController.isPresentedModally = YES;
    otpViewController.originScreen = @"Login";
    
    [self.navigationController pushViewController:otpViewController animated:YES];
}

- (IBAction)actionBack:(id)sender
{
    UIViewController *controller = [self.navigationController popViewControllerAnimated:YES];
    
    if(controller == nil)
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)forgotPasswordAction:(id)sender
{
    ForgotPasswordViewController *forgotPasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [self.navigationController pushViewController:forgotPasswordViewController animated:YES];
}

- (void)loginRequest:(NSInteger)index
{
  if(index==1)
  {
      if([emailTextField.text isEqualToString:@""]&&[passwordTextField.text isEqualToString:@""])
      {
          [Helper popUpMessage:NSLocalizedStringFromTableInBundle(@"Please provide your phonenumber and key-in password", nil, [[Helper sharedInstance] getLocalBundle], nil) titleForPopUp:@"" view:[UIView new]];
      }
      else if ([emailTextField.text isEqualToString:@""])
      {
          emailTextField.errorText = NSLocalizedStringFromTableInBundle(@"Please enter your phone number", nil, [[Helper sharedInstance] getLocalBundle], nil);
          
          [emailTextField showError];
      }
      else if ([passwordTextField.text isEqualToString:@""])
      {
          passwordTextField.errorText = NSLocalizedStringFromTableInBundle(@"Please enter your password", nil, [[Helper sharedInstance] getLocalBundle], nil);
          [passwordTextField showError];
      }
      else
      {
          NSString *username = [NSString stringWithFormat:@"+%@",emailTextField.text];
          
          [self loginAction:username parameterName:@"mobile" withPassword:passwordTextField.text];
      }

  }
    else
    {
        if([emailTextField.text isEqualToString:@""]&&[passwordTextField.text isEqualToString:@""])
        {
            [Helper popUpMessage:NSLocalizedStringFromTableInBundle(@"Please provide your email and key-in password" , nil, [[Helper sharedInstance] getLocalBundle], nil) titleForPopUp:@"" view:[UIView new]];
        }
        else if ([emailTextField.text isEqualToString:@""])
        {
            emailTextField.errorText = NSLocalizedStringFromTableInBundle(@"Please enter your email address" , nil, [[Helper sharedInstance] getLocalBundle], nil);
            [emailTextField showError];
        }
        else if (![Helper NSStringIsValidEmail:emailTextField.text])
        {
            emailTextField.errorText = NSLocalizedStringFromTableInBundle(@"Please enter valid email address" , nil, [[Helper sharedInstance] getLocalBundle], nil);
            [emailTextField showError];
        }
        else if ([passwordTextField.text isEqualToString:@""])
        {
            passwordTextField.errorText =  NSLocalizedStringFromTableInBundle(@"Please enter your password" , nil, [[Helper sharedInstance] getLocalBundle], nil);
;
            [passwordTextField showError];
        }
        else
        {
            [self loginAction:emailTextField.text parameterName:@"username" withPassword:passwordTextField.text];
        }
    }
}

- (void)loginAction:(NSString *)userName parameterName:(NSString *)parameter withPassword:(NSString *)password
{
    CommonRequest *request = [CommonRequest sharedInstance];
    request.delegate = self;

    [request loginRequest:userName withPassword:password withType:parameter];
}

- (IBAction)loginAction:(id)sender {
    [self loginRequest:segmentController.selectedSegmentIndex];
}

- (IBAction)doneBtnFromKeyboardClicked:(id)sender
{
    [passwordTextField becomeFirstResponder];
}

- (IBAction)facebookLoginAction:(id)sender {
    
    [FBSDKAccessToken setCurrentAccessToken:nil];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorBrowser;
    [login
     logInWithReadPermissions: @[@"public_profile",@"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             [SVProgressHUD showWithStatus:@"Loading..."];
             if ([FBSDKAccessToken currentAccessToken]) {
                 
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"email,first_name,last_name,picture.type(large)"}]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     
                      if (!error) {
                          
                          NSString *emailid = [NSString stringWithFormat:@"%@",[result objectForKey:@"email"]];
                          [self loginAction:emailid parameterName:@"username" withPassword:@"facebook"];
                      }
                      else
                      {
                          NSLog(@"this is localized string = %@",error.localizedDescription);
                      }
                  }];
             }
             [SVProgressHUD dismiss];
             
         }
     }];
}

- (void)createFbLogin:(NSDictionary *)fbDic
{
    [SVProgressHUD showWithStatus:@"Login.."];
    
    NSString *deviceName = @"IPHONE";

    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad){
        deviceName=@"IPAD";
    }

    STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    
    if(deviceToken.length == 0)
    {
        deviceToken = @"NO TOKEN";
    }
    
    NSString *assignedUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"result"] objectForKey:@"userId"];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    NSString *strCountry = [[NSUserDefaults standardUserDefaults] objectForKey:@"Country"];

    NSDictionary *elementDictionary =@{
                                       @"facebook_id":[fbDic objectForKey:@"fbId"],
                                       @"firstname":[fbDic objectForKey:@"fname"],
                                       @"lastname":[fbDic objectForKey:@"lname"],
                                       @"email":[fbDic objectForKey:@"email"],
                                       @"mobile":[NSString stringWithFormat:@"%@",@""],
                                       @"cf_1260":@"",
                                       @"mailingstreet":@"",
                                       @"cf_1277":deviceToken,//device token
                                       @"cf_1281":[[Helper sharedInstance] deviceModelName],//cf_1281 device version
                                       @"cf_1279":deviceName,
                                       @"imageurl":[fbDic objectForKey:@"img"],
                                       @"mailingpobox":@"",
                                       @"mailingstate":@"",
                                       @"mailingcountry":@"",
                                       @"cf_1372":@"IOS",
                                       @"mailingcity":@"",
                                       @"cf_1283":[NSString stringWithFormat:@"70x%@",strCountry],
                                       @"portal":@"1",
                                       @"assigned_user_id":assignedUserId
                                       };
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:elementDictionary // Here you can pass array or dictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //This is your JSON String
        //NSUTF8StringEncoding encodes special characters using an escaping scheme
    } else {
        NSLog(@"Got an error: %@", error);
        jsonString = @"";
    }
    NSLog(@"Your JSON String is %@", jsonString);
    response.POSTDictionary = @{@"operation":@"ams.facebook",
                                @"sessionName":sessionName,
                                @"element":jsonString,
                                @"elementType":@"Contacts"
                                };
    
    NSLog(@"PARAMETER = %@",response.POSTDictionary);
    
    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        @try {
            NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&error];
            
            json = [json replaceNullsWithObject:@"NA"];

            BOOL success = [[json objectForKey:@"success"] boolValue];
            NSString *failure = [[json objectForKey:@"result"] objectForKey:@"status"];
            
            NSLog(@"RESPONSE = %@",json);
            
            if(success)
            {
                [SVProgressHUD dismiss];
                
                if([failure isEqualToString:@"failure"])
                {
                    [Helper popUpMessage:[[json objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"" view:[UIView new]];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] setObject:[[json objectForKey:@"result"] objectForKey:@"data"] forKey:@"profile"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"FBLOGIN"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    if(shouldShowTabBarOnSuccess)
                    {
                        [self redirectToTabBar];
                    }
                    else
                    {
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            else
            {
                [SVProgressHUD dismiss];
                [Helper popUpMessage:[[json objectForKey:@"error"] objectForKey:@"message"] titleForPopUp:@"Error" view:[UIView new]];
            }

        }@catch (NSException *exception) {
            [Helper catchPopUp:body titleForPopUp:@""];
        }
    };
    response.errorBlock = ^(NSError *error) {

        [SVProgressHUD dismiss];
        [Helper popUpMessage:error.localizedDescription titleForPopUp:@"Error" view:[UIView new]];
    };
    
    [response startAsynchronous];
    
}

- (IBAction)segmentAction:(id)sender {
    
    segmentController = (UISegmentedControl *)sender;
    
    emailTextField.text = @"";
    passwordTextField.text = @"";
    
    if(segmentController.selectedSegmentIndex==1)
    {
        emailTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Mobile number", nil, [[Helper sharedInstance] getLocalBundle], nil);
        emailTextField.keyboardType = UIKeyboardTypeNumberPad;
        emailTextField.text = [Helper countryCode];
        plusConstraints.constant = 30;
    }
    else
    {
        emailTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Email", nil, [[Helper sharedInstance] getLocalBundle], nil);
        emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        plusConstraints.constant = 0;
    }
    
    [emailTextField resignFirstResponder];
    [emailTextField becomeFirstResponder];
}
    
- (void)redirectToTabBar{
    UITabBarController *homeTab = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomTabBarController"];
    [self.navigationController pushViewController:homeTab animated:YES];
}

- (IBAction)passwordAction:(id)sender {
    
    UIButton *btnSelected = (UIButton *)sender;
    
    if(btnSelected.selected)
    {
        btnSelected.selected = NO;
         passwordTextField.secureTextEntry = YES;
        [btnSelected setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateNormal];
    }
    else
    {
        btnSelected.selected = YES;
        passwordTextField.secureTextEntry = NO;
        [btnSelected setImage:[UIImage imageNamed:@"unhide"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Common Request Delegate

-(void)commonRequestGetResponse:(NSDictionary *)response withAPIName:(NSString *)name
{
    BOOL success = [[response objectForKey:@"success"] boolValue];
    
    NSString *status = [[response objectForKey:@"result"] objectForKey:@"status"];
    
    [SVProgressHUD dismiss];
    
    if(success)
    {
        if([status isEqualToString:@"success"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:[[response objectForKey:@"result"] objectForKey:@"data"] forKey:@"profile"];
            
            if([name isEqualToString:@"facebook"])
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"FBLOGIN"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"FBLOGIN"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            if([originScreen isEqualToString:@"welcome"])
            {
                [self redirectToTabBar];
            }else if([originScreen isEqualToString:@"more"])
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else
            {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }
        else
        {
            [Helper showAlert:[[response objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"" view:[UIView new] handler:^(bool OkbuttonPressed) {
                
                if (OkbuttonPressed) {
                    
                    if ([[[response objectForKey:@"result"] objectForKey:@"message"] isEqualToString:@"OTP Verification Pending"]) {
                        
                        [self redirectToOTP];
                    }
                    
                }
                
            }];
        
        }
    }
}

@end
