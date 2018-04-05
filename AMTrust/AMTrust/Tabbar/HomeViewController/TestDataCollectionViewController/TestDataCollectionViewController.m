//
//  TestDataCollectionViewController.m
//  Tecprotec
//
//  Created by kishore kumar on 18/07/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "TestDataCollectionViewController.h"

@interface TestDataCollectionViewController ()

@end

@implementation TestDataCollectionViewController
@synthesize isTablet;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    monthPickerView = [[UIPickerView alloc] init];
    
    arrMonth = [[NSArray alloc]init];
    arrYear = [[NSMutableArray alloc] init];
    
    [self updateContent];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[Helper sharedInstance] trackingScreen:@"UserInfo_screen_IOS"];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)updateContent
{
    if(!isTablet)
    {
        makeTextField.text = @"Apple";
        [makeTextField setUserInteractionEnabled:NO];
    }else
    {
        [makeTextField setUserInteractionEnabled:YES];
    }
    
    NSDictionary *profileDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];
    
    if(profileDictionary.count!=0)
    {
        lblTitle.text = NSLocalizedStringFromTableInBundle(@"User info", nil, [[Helper sharedInstance] getLocalBundle], nil);

        [self profileDetails:[profileDictionary objectForKey:@"email"]];
        
        firstNameTextField.placeholder = NSLocalizedStringFromTableInBundle(@"First name", nil, [[Helper sharedInstance] getLocalBundle], nil);
        lastNameTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Last name", nil, [[Helper sharedInstance] getLocalBundle], nil);
        mobileTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Mobile number", nil, [[Helper sharedInstance] getLocalBundle], nil);
        emailTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Email", nil, [[Helper sharedInstance] getLocalBundle], nil);
        
        passwordTextField.hidden = YES;
        heightConstraints.constant = 0;
        topSpaceConstraints.constant = 0;
        btnPassword.hidden = YES;
    }
    else
    {
        lblTitle.text = NSLocalizedStringFromTableInBundle(@"Create Account with Mobile Number", nil, [[Helper sharedInstance] getLocalBundle], nil);
        
        mobileTextField.text = [Helper countryCode];
        addressTextField.hidden = NO;
        passwordTextField.hidden = NO;
        heightConstraints.constant = 40;
        topSpaceConstraints.constant = 20;
        firstNameTextField.placeholder = NSLocalizedStringFromTableInBundle(@"First name (required)", nil, [[Helper sharedInstance] getLocalBundle], nil);
        lastNameTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Last name (required)", nil, [[Helper sharedInstance] getLocalBundle], nil);
        mobileTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Mobile number (required)", nil, [[Helper sharedInstance] getLocalBundle], nil);
        emailTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Email (required)", nil, [[Helper sharedInstance] getLocalBundle], nil);
    }
    
    imeiTextField.placeholder = NSLocalizedStringFromTableInBundle(@"IMEI (required)", nil, [[Helper sharedInstance] getLocalBundle], nil);
    makeTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Make (required)", nil, [[Helper sharedInstance] getLocalBundle], nil);
    passwordTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Password (required)", nil, [[Helper sharedInstance] getLocalBundle], nil);
    addressLineTwoTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Address line 2", nil, [[Helper sharedInstance] getLocalBundle], nil);
    addressTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Address line 1", nil, [[Helper sharedInstance] getLocalBundle], nil);
    postalCodeAddress.placeholder = NSLocalizedStringFromTableInBundle(@"Postal code", nil, [[Helper sharedInstance] getLocalBundle], nil);
    
    [btnProceedtoSummary setTitle:NSLocalizedStringFromTableInBundle(@"Proceed to summary", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
    
    if(isTablet)
    {
        imeiTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Serial number (required)", nil, [[Helper sharedInstance] getLocalBundle], nil);
    }
    else
    {
        imeiTextField.placeholder = NSLocalizedStringFromTableInBundle(@"IMEI number (required)", nil, [[Helper sharedInstance] getLocalBundle], nil);
    }
}

#pragma mark - API

- (void)customerExist
{
    [SVProgressHUD showWithStatus:@"Customer verification.."];
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    NSString *mobilenumber;
    if ([mobileTextField.text rangeOfString:@"+"].location == NSNotFound) {
        mobilenumber = [NSString stringWithFormat:@"%@%@",@"+",mobileTextField.text];
    } else {
        mobilenumber = [NSString stringWithFormat:@"%@",mobileTextField.text];
    }
    NSString *imei = imeiTextField.text;
    imei = [imei stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSDictionary *elementDictionary =@{
                                       @"email":emailTextField.text,
                                       @"mobile":mobilenumber,
                                       @"imei":imei
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
    
    response.POSTDictionary = @{@"operation":@"ams.userexist",
                                @"sessionName":sessionName,
                                @"element":jsonString,
                                @"elementType":@"Contacts"
                                };
    
    NSLog(@"PARAMETER = %@",response.POSTDictionary);
    
    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        json = [json replaceNullsWithObject:@"NA"];

        NSLog(@"RESPONSE = %@",json);

        @try {
            BOOL success = [[json objectForKey:@"success"] boolValue];
            bool is_portal_user = [[[json objectForKey:@"result"]objectForKey:@"is_portal_user"] boolValue];
            bool is_exist_policy = [[[json objectForKey:@"result"] objectForKey:@"is_exist_user"] boolValue];
            
            //is_exist_policy
            if(!is_portal_user && is_exist_policy)
            {
                NSArray *userData = [[json objectForKey:@"result"] objectForKey:@"userdata"];
                
                if(userData.count==0)
                {
                    [Helper popUpMessage:@"Please verify the phone number and IMEI is correct with your previous policy" titleForPopUp:@"Data mismatch" view:[UIView new]];
                }
                else
                {
                    NSString *strCustomerId = [[[json objectForKey:@"result"] objectForKey:@"userdata"] objectForKey:@"user_id"];
                    NSArray *arrID = [strCustomerId componentsSeparatedByString:@"x"];
                    [self updateCustomer:arrID[1] is_portal:[[json objectForKey:@"result"]objectForKey:@"is_portal_user"]];
                }
            }
            else
            {
                NSString *failure = [[json objectForKey:@"result"] objectForKey:@"status"];
                NSString *failureMessage = [NSString stringWithFormat:@"%@",[[json objectForKey:@"result"] objectForKey:@"message"]];
                
                if([failureMessage isEqualToString:@"Already registered. Please try logging in with the registered email and password."]||[failureMessage  isEqualToString:@"Multiple Customer with same email id, mobile & Imei !!"])
                {
                    failureMessage = NSLocalizedStringFromTableInBundle(@"Email ID, mobile number and/or IMEI already exists. Please proceed to login.", nil, [[Helper sharedInstance] getLocalBundle], nil);
                }
                
                NSLog(@"RESPONSE = %@",json);

                if(success)
                {
                    [SVProgressHUD dismiss];
                    
                    if([failure isEqualToString:@"failure"]||[failure isEqualToString:@"failed"])
                    {
                        LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:@"" message:failureMessage style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"Login" destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
                        } cancelHandler:^(LGAlertView * _Nonnull alertView) {
                            
                            LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                            loginViewController.shouldShowTabBarOnSuccess = YES;
                            NSString *imei = imeiTextField.text;
                            imei = [imei stringByReplacingOccurrencesOfString:@" " withString:@""];
                            loginViewController.strimei = imei;
                            loginViewController.strMake = makeTextField.text;
                            [self.navigationController pushViewController:loginViewController animated:YES];
                        } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
                            
                        }];
                        alertView.tintColor = THEMECOLOR;
                        [alertView show];
                        
                    }
                    else
                    {
                        [self createCustomer];
                    }
                }
                else
                {
                    [SVProgressHUD dismiss];
                    [Helper popUpMessage:[[json objectForKey:@"error"] objectForKey:@"message"] titleForPopUp:@"Error" view:[UIView new]];
                }
            
        }
        } @catch (NSException *exception) {
            [Helper popUpMessage:@"We are upgrading our server...." titleForPopUp:@"Error" view:[UIView new]];
        }
    };
    response.errorBlock = ^(NSError *error) {
        // ...
        [SVProgressHUD dismiss];
        [Helper popUpMessage:error.localizedDescription titleForPopUp:@"Error" view:[UIView new]];
    };
    
    [response startAsynchronous];
    
    
}

- (void)updateCustomer:(NSString *)customerID is_portal:(NSString *)strPortalUser
{
    [SVProgressHUD showWithStatus:@"Loading.."];
    
    
    NSString *deviceName;
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
    {
        deviceName=@"IPAD";
    }
    else
    {
        deviceName=@"IPHONE";
    }
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    
    if(deviceToken.length == 0)
    {
        deviceToken = @"NO TOKEN";
    }
    
    NSString *assignedUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"result"] objectForKey:@"userId"];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    
    NSString *address = [NSString stringWithFormat:@"%@",addressTextField.text];
    NSString *addressTwo = [NSString stringWithFormat:@"%@",addressLineTwoTextField.text];
    NSString *pincode = [NSString stringWithFormat:@"%@",postalCodeAddress.text];
    if(address.length==0)
    {
        address = @"";
    }
    if(addressTwo.length==0)
    {
        addressTwo = @"";
    }
    if(pincode.length==0)
    {
        pincode = @"";
    }
    NSString *strCountry = [[NSUserDefaults standardUserDefaults] objectForKey:@"Country"];
    NSString *countryName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CountryName"];
    NSString *imei = imeiTextField.text;
    imei = [imei stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary *elementDictionary =@{
                                       @"firstname":firstNameTextField.text,
                                       @"lastname":lastNameTextField.text,
                                       @"email":emailTextField.text,
                                       @"mobile":mobileTextField.text,
                                       @"mailingstreet":address,
                                       @"cf_1277":deviceToken,//device token
                                       @"cf_1281":[[Helper sharedInstance] deviceModelName],//cf_1281 device version
                                       @"cf_1372":@"IOS",
                                       @"cf_1279":deviceName,//device model
                                       @"cf_1260":imei,
                                       @"assigned_user_id":assignedUserId,
                                       @"mailingpobox":@"",
                                       @"mailingstate":@"",
                                       @"mailingcountry":countryName,
                                       @"mailingcity":addressTwo,
                                       @"cf_1283":[NSString stringWithFormat:@"70x%@",strCountry],
                                       @"password":passwordTextField.text,
                                       @"is_portal_user":strPortalUser,
                                       @"id":customerID
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
    
    
    NSDictionary *paramDictionary=[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"ams.update_profile", @"operation",
                                   sessionName,@"sessionName",
                                   jsonData,@"element",
                                   nil];
    
    // 1. Create `AFHTTPRequestSerializer` which will create your request.
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    // 2. Create an `NSMutableURLRequest`.
    
    NSMutableURLRequest *request;
    
    
    request=[serializer multipartFormRequestWithMethod:@"POST" URLString:BASEURL parameters:paramDictionary constructingBodyWithBlock:nil error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress)
                  {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      
                  }
                  completionHandler:^(NSURLResponse * _Nonnull responseObject, id  _Nullable response, NSError * _Nullable error) {
                      if (error) {
                          
                      } else
                      {
                          NSLog(@"%@ %@", response, responseObject);
                          
                          
                          BOOL success=[[response objectForKey:@"success"] boolValue];
                          
                          if(success)
                          {
                              NSString *status=[NSString stringWithFormat:@"%@",[[response objectForKey:@"result"] objectForKey:@"status"]];
                             
                              if([status isEqualToString:@"failure"])
                              {
                                  [Helper popUpMessage:[[response objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"Alert" view:[UIView new]];
                              }
                              else
                              {
                                  
                                  NSDictionary *dicPersonal = [[response objectForKey:@"result"] objectForKey:@"result"];
                                  NSString *firstName = [dicPersonal objectForKey:@"firstname"];
                                  NSString *lastName = [dicPersonal objectForKey:@"lastname"];
                                  NSString *address = [dicPersonal objectForKey:@"mailingstreet"];
                                  NSString *country = [dicPersonal objectForKey:@"mailingcountry"];
                                  NSString *city = [dicPersonal objectForKey:@"mailingcity"];
                                  NSString *state = [dicPersonal objectForKey:@"mailingstate"];
                                  NSString *customerId = [dicPersonal objectForKey:@"id"];
                                  
                                  
                                  NSDictionary * profileDetails = @{@"customerid":customerId,
                                                                    @"firstname":firstName,
                                                                    @"lastname":lastName,
                                                                    @"email":[dicPersonal objectForKey:@"email"],
                                                                    @"mobile":[dicPersonal objectForKey:@"mobile"],
                                                                    @"mailingstreet":address,
                                                                    @"mailingcity":city,
                                                                    @"mailingcountry":country,
                                                                    @"mailingstate":state,
                                                                    @"imagename":@""
                                                                    
                                                                    };
                                  
                                  [[NSUserDefaults standardUserDefaults] setObject:profileDetails forKey:@"profile"];
                                  [[NSUserDefaults standardUserDefaults] synchronize];
                                  
                                  SummaryViewController *summaryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SummaryViewController"];
                                  NSString *imei = imeiTextField.text;
                                  imei = [imei stringByReplacingOccurrencesOfString:@" " withString:@""];
                                  summaryViewController.strIMEI = imei;
                                  summaryViewController.isTablet = isTablet;
                                  summaryViewController.strMake = makeTextField.text;
                                  [self.navigationController pushViewController:summaryViewController animated:YES];

                              }
                          }
                          else
                          {
                              
                          }
                      }
                      [SVProgressHUD dismiss];
                  }];
    
    [uploadTask resume];
}

- (void)createCustomer
{
    [SVProgressHUD showWithStatus:@"Loading.."];
    
    NSString *deviceName;
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
    {
        deviceName=@"IPAD";
    }
    else
    {
        deviceName=@"IPHONE";
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
    NSString *address = [NSString stringWithFormat:@"%@",addressTextField.text];
    NSString *addressTwo = [NSString stringWithFormat:@"%@",addressLineTwoTextField.text];
    NSString *pincode = [NSString stringWithFormat:@"%@",postalCodeAddress.text];
    
    if(address.length == 0)
    {
        address = @"";
    }
    if(addressTwo.length==0)
    {
        addressTwo = @"";
    }
    
    if(pincode.length==0)
    {
        pincode = @"";
    }
    
    NSString *mobilenumber;
    if ([mobileTextField.text rangeOfString:@"+"].location == NSNotFound) {
        mobilenumber = [NSString stringWithFormat:@"%@%@",@"+",mobileTextField.text];
    } else {
        mobilenumber = [NSString stringWithFormat:@"%@",mobileTextField.text];
    }
    NSString*imei = imeiTextField.text;
    imei = [imei stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSDictionary *elementDictionary =@{
                                       @"firstname":firstNameTextField.text,
                                       @"lastname":lastNameTextField.text,
                                       @"password":passwordTextField.text,
                                       @"email":emailTextField.text,
                                       @"mobile":[NSString stringWithFormat:@"%@",mobilenumber],
                                       @"cf_1260":imei,
                                       @"mailingstreet":address,
                                       @"cf_1277":deviceToken,//device token
                                       @"cf_1281":[[Helper sharedInstance] deviceModelName],//cf_1281 device version
                                       @"cf_1279":deviceName,//device model
                                       @"assigned_user_id":assignedUserId,
                                       @"mailingpobox":pincode,
                                       @"mailingstate":@"",
                                       @"mailingcountry":@"",
                                       @"mailingcity":addressTwo,
                                       @"cf_1283":[NSString stringWithFormat:@"70x%@",strCountry],
                                       @"portal":@"1"
                                       };
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:elementDictionary // Here you can pass array or dictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        NSLog(@"Got an error: %@", error);
        jsonString = @"";
    }
    NSLog(@"Your JSON String is %@", jsonString);
    
    response.POSTDictionary = @{@"operation":@"create",
                                @"sessionName":sessionName,
                                @"element":jsonString,
                                @"elementType":@"Contacts"
                                };
    
    NSLog(@"PARAMETER = %@",response.POSTDictionary);
    
    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        @try {
            NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&error];
            
            json = [json replaceNullsWithObject:@"NA"];

            BOOL success = [[json objectForKey:@"success"] boolValue];
            
            NSString *failure = [[json objectForKey:@"result"] objectForKey:@"status"];
            
            NSLog(@"RESPONSE = %@",json);
            //
            if(success)
            {
                [SVProgressHUD dismiss];
                
                if([failure isEqualToString:@"failure"])
                {
                    NSString *failureMessage = [NSString stringWithFormat:@"%@",[[json objectForKey:@"result"] objectForKey:@"message"]];
                    
                    if([failureMessage isEqualToString:@"Already registered. Please try logging in with the registered email and password."]||[failureMessage isEqualToString:@"Multiple Customer with same email id, mobile & Imei !!"])
                    {
                        failure = @"Email ID, mobile number and/or IMEI already exists. Please proceed to login.";
                    }

                    [Helper popUpMessage:failureMessage titleForPopUp:@"Alert" view:[UIView new]];
                }
                else
                {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"FBLOGIN"];
                    
                    OTPViewController *otpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OTPViewController"];
                    otpViewController.mobileNumber = [NSString stringWithFormat:@"%@%@",@"",mobileTextField.text];
                    otpViewController.isPresentedModally = YES;
                    otpViewController.originScreen = @"quickCheck";
                    NSString *imei = imeiTextField.text;
                    imei = [imei stringByReplacingOccurrencesOfString:@" " withString:@""];
                    otpViewController.strimei = imei;
                    otpViewController.strMake = makeTextField.text;
                    otpViewController.isTablet = isTablet;
                    [self.navigationController pushViewController:otpViewController animated:YES];
                }
            }
            else
            {
                [SVProgressHUD dismiss];
                [Helper popUpMessage:[[json objectForKey:@"error"] objectForKey:@"message"] titleForPopUp:@"Error" view:[UIView new]];
            }
            
        }  @catch (NSException *exception) {
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

-(void)profileDetails:(NSString *)emailAddress
{
    [SVProgressHUD showWithStatus:@"Profile info.."];
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    
    response.POSTDictionary =@{@"operation":@"ams.profile_detail",
                               @"sessionName":sessionName,
                               @"email_id":emailAddress
                               };
    
    
    NSLog(@"this is profile data= %@",response.POSTDictionary);
    
    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        [SVProgressHUD dismiss];

        @try {
            NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&error];
            json = [json replaceNullsWithObject:@"NA"];

            NSLog(@"json = %@",json);
            [SVProgressHUD dismiss];

            if(json == nil)
            {
                [Helper popUpMessage:@"Could not retrieve your information at the moment. Please proceed to fill up the details" titleForPopUp:@"" view:[UIView new]];
            }else
            {
                BOOL success = [[json objectForKey:@"success"] boolValue];
                NSString *status = [[json objectForKey:@"result"] objectForKey:@"status"];
                
                if(success)
                {
                    if([status isEqualToString:@"success"])
                    {
                        NSDictionary *profileData = [[json objectForKey:@"result"] objectForKey:@"result"];
                        
                        self->firstNameTextField.text = [profileData objectForKey:@"firstname"];
                        self->lastNameTextField.text = [profileData objectForKey:@"lastname"];
                        
                        NSString* phone = [profileData objectForKey:@"mobile"];
                        phone = [phone stringByReplacingOccurrencesOfString:@"+" withString:@""];
                        
                        self->mobileTextField.text = phone;
                        
                        NSString* emailAddress = [profileData objectForKey:@"email"];
                        
                        if([emailAddress isEqualToString:@""])
                        {
                            self->emailTextField.userInteractionEnabled = YES;

                        }else
                        {
                            self->emailTextField.text = [profileData objectForKey:@"email"];
                            self->emailTextField.userInteractionEnabled = NO;
                        }
                        
                        self->addressTextField.text = [profileData objectForKey:@"address"];
                        self->addressLineTwoTextField.text = [profileData objectForKey:@"city"];
                        self->postalCodeAddress.text = [profileData objectForKey:@"postal_code"];
                        
                        if(!isTablet)
                        {
                            self->imeiTextField.text = [profileData objectForKey:@"imei"];
                        }
                    }
                    else
                    {
                        [Helper popUpMessage:[[json objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"Alert" view:[UIView new]];
                    }
                }
            }
            
           
        } @catch (NSException *exception) {
            [Helper catchPopUp:body titleForPopUp:@""];
            
        }
    };
    response.errorBlock = ^(NSError *error) {
        [SVProgressHUD dismiss];
        [Helper popUpMessage:error.localizedDescription titleForPopUp:@"Error" view:[UIView new]];
    };
    
    [response startAsynchronous];
    
}

#pragma mark - textfield Delegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (IBAction)textFieldTypes:(UITextField *)textField
{
    if(textField == firstNameTextField)
    {
        [self updatePlaceholder:textField withRequiredText:@"First name (required)" withNormal:@"First name"];
    }
    else if (textField == lastNameTextField)
    {
        [self updatePlaceholder:textField withRequiredText:@"Last name (required)" withNormal:@"Last name"];
    }
    else if (textField == mobileTextField)
    {
        [self updatePlaceholder:textField withRequiredText:@"Mobile number (required)" withNormal:@"Mobile number"];
    }
    else if (textField == emailTextField)
    {
        [self updatePlaceholder:textField withRequiredText:@"Email (required)" withNormal:@"Email"];
    }
    else if (textField == imeiTextField)
    {
        if(isTablet)
        {
            [self updatePlaceholder:textField withRequiredText:@"Serial number (required)" withNormal:@"Serial number"];
        }else
        {
            [self updatePlaceholder:textField withRequiredText:@"IMEI (required)" withNormal:@"IMEI"];
        }
    }
    else if (textField == makeTextField)
    {
        [self updatePlaceholder:textField withRequiredText:@"Make (required)" withNormal:@"Make"];
    }
    else if (textField == passwordTextField)
    {
        [self updatePlaceholder:textField withRequiredText:@"Password (required)" withNormal:@"Password"];
    }
    else if (textField == addressTextField)
    {
        [self updatePlaceholder:textField withRequiredText:@"Address line 1" withNormal:@"Address line 1"];
    }
    else if (textField == addressLineTwoTextField)
    {
        [self updatePlaceholder:textField withRequiredText:@"Address line 2" withNormal:@"Address line 2"];
    }
    else if (textField == postalCodeAddress)
    {
        [self updatePlaceholder:textField withRequiredText:@"Postal code" withNormal:@"Postal code"];
    }
}

-(void)updatePlaceholder:(UITextField *)textField withRequiredText:(NSString *)requiredStr withNormal:(NSString *)normalStr
{
    if(textField.text.length != 0){
        textField.placeholder = NSLocalizedStringFromTableInBundle(normalStr, nil, [[Helper sharedInstance] getLocalBundle], nil);
    }else{
        textField.placeholder = NSLocalizedStringFromTableInBundle(requiredStr, nil, [[Helper sharedInstance] getLocalBundle], nil);
    }
}

#pragma mark - Button Action

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

- (IBAction)doneAction:(id)sender {
    
    if ([firstNameTextField.text isEqualToString:@""])
    {
        [Helper popUpMessage:NSLocalizedStringFromTableInBundle(@"Please enter your first name", nil, [[Helper sharedInstance] getLocalBundle], nil) titleForPopUp:@"First name field is empty" view:[UIView new]];
    }
    else if ([lastNameTextField.text isEqualToString:@""])
    {
        [Helper popUpMessage:NSLocalizedStringFromTableInBundle(@"Please enter your last name", nil, [[Helper sharedInstance] getLocalBundle], nil) titleForPopUp:@"Last name field is empty" view:[UIView new]];
    }
    else if ([emailTextField.text isEqualToString:@""])
    {
        [Helper popUpMessage:NSLocalizedStringFromTableInBundle(@"Please enter your email address", nil, [[Helper sharedInstance] getLocalBundle], nil) titleForPopUp:@"Email address is missing" view:[UIView new]];
    }
    else if ([imeiTextField.text isEqualToString:@""])
    {
        if(!isTablet)
        {
            [Helper popUpMessage:NSLocalizedStringFromTableInBundle(@"Please enter your imei number", nil, [[Helper sharedInstance] getLocalBundle], nil) titleForPopUp:@"IMEI field is empty" view:[UIView new]];
        }else{
            [Helper popUpMessage:NSLocalizedStringFromTableInBundle(@"Please enter your serial number", nil, [[Helper sharedInstance] getLocalBundle], nil) titleForPopUp:@"Serial number field is empty" view:[UIView new]];
        }
    }
    else if ([mobileTextField.text isEqualToString:@""])
    {
        [Helper popUpMessage:NSLocalizedStringFromTableInBundle(@"Please enter your mobile number", nil, [[Helper sharedInstance] getLocalBundle], nil) titleForPopUp:@"Mobile number field is empty" view:[UIView new]];
    }
    else if ([makeTextField.text isEqualToString:@""])
    {
        [Helper popUpMessage:NSLocalizedStringFromTableInBundle(@"Please enter your make name", nil, [[Helper sharedInstance] getLocalBundle], nil) titleForPopUp:@"Make field is empty" view:[UIView new]];
    }
    else
    {
        if([[Helper sharedInstance] isLogin])
        {
            SummaryViewController *summaryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SummaryViewController"];
            NSString *imei = imeiTextField.text;
            imei = [imei stringByReplacingOccurrencesOfString:@" " withString:@""];
            summaryViewController.strIMEI = imei;
            summaryViewController.strMake = makeTextField.text;
            summaryViewController.isTablet = isTablet;
            [self.navigationController pushViewController:summaryViewController animated:YES];
        }
        else
        {
            [self customerExist];
        }
    }
}

- (IBAction)questionAction:(id)sender {
    
    if(isTablet)
    {
        LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:@"" message:NSLocalizedStringFromTableInBundle(@"Get your serial number in Settings or on the exterior of your tablet.", nil, [[Helper sharedInstance] getLocalBundle], nil)  style:LGAlertViewStyleAlert buttonTitles:@[] cancelButtonTitle:@"OK" destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
            
        } cancelHandler:^(LGAlertView * _Nonnull alertView) {
            
        } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
            
        }];
        [alertView show];
    }
    else
    {
        LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:@"" message:NSLocalizedStringFromTableInBundle(@"Get your IMEI in Settings, select General and About. Or dial *#06#", nil, [[Helper sharedInstance] getLocalBundle], nil) style:LGAlertViewStyleAlert buttonTitles:@[@"Setting",@"Cancel"] cancelButtonTitle:nil destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
            if([title isEqualToString:@"Setting"])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root"]];
            }
        } cancelHandler:^(LGAlertView * _Nonnull alertView) {
            
        } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
            
        }];
        [alertView show];
    }
}

- (IBAction)backAction:(id)sender {
    
    NSString *strText = NSLocalizedStringFromTableInBundle(@"Do you want to cancel the purchase?", nil, [[Helper sharedInstance] getLocalBundle], nil);
    NSString *yes = NSLocalizedStringFromTableInBundle(@"Yes", nil, [[Helper sharedInstance] getLocalBundle], nil);
    NSString *cancel = NSLocalizedStringFromTableInBundle(@"No", nil, [[Helper sharedInstance] getLocalBundle], nil);
    
    LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:@"" message:strText style:LGAlertViewStyleAlert buttonTitles:@[yes,cancel] cancelButtonTitle:nil destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
        if([title isEqualToString:@"Yes"]||[title isEqualToString:@"Ya"])
        {
            for (UIViewController *controller in self.navigationController.viewControllers)
            {
                if ([controller isKindOfClass:[PolicyDetailViewController class]])
                {
                    [self.navigationController popToViewController:controller
                                                          animated:YES];
                    break;
                }
            }
        }
        
    } cancelHandler:^(LGAlertView * _Nonnull alertView) {
        
    } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
        
    }];
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
