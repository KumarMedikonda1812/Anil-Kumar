//
//  SignUpViewController.m
//  AMTrust
//
//  Created by kishore kumar on 01/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController
@synthesize fbVariation;
@synthesize fbDic;
@synthesize isPresentedModally;
@synthesize originScreen;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    commonRequest = [CommonRequest sharedInstance];
    commonRequest.delegate = self;
    
    signUpScrollView.delaysContentTouches = NO;
    [self setupNumberKeyboardWithDone];
    
    if(fbVariation)
    {
        firstNameTxtField.text = [NSString stringWithFormat:@"%@",[fbDic objectForKey:@"fname"]];
        lastNameTxtField.text = [NSString stringWithFormat:@"%@",[fbDic objectForKey:@"lname"]];
        emailTextField.text = [NSString stringWithFormat:@"%@",[fbDic objectForKey:@"email"]];
        emailTextField.userInteractionEnabled = NO;
        passwordTextField.hidden = YES;
        eyeButton.hidden = YES;
    }
    
    if(isPresentedModally)
    {
        NSString *firstName = [NSString stringWithFormat:@"%@",[fbDic objectForKey:@"fname"]];
        NSString *lastName = [NSString stringWithFormat:@"%@",[fbDic objectForKey:@"lname"]];
        NSString *email = [NSString stringWithFormat:@"%@",[fbDic objectForKey:@"email"]];
        NSString *mobile = [NSString stringWithFormat:@"%@",[fbDic objectForKey:@"moblie"]];
        
        if(![[Helper sharedInstance] checkForNull:firstName])
        {
            firstNameTxtField.text = firstName;
        }
        
        if(![[Helper sharedInstance] checkForNull:lastName])
        {
            lastNameTxtField.text = lastName;
        }
        
        if(![[Helper sharedInstance] checkForNull:email])
        {
            emailTextField.text = email;
        }
        
        if(![[Helper sharedInstance] checkForNull:mobile])
        {
            mobileTxtField.text = mobile;
        }
        
        emailTextField.userInteractionEnabled = YES;
        
    }
    
    mobileTxtField.text = [Helper countryCode];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[Helper sharedInstance] trackingScreen:@"SignUP_IOS"];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self updateLanguage];
}

-(void)updateLanguage
{
    [btnDone setTitle:NSLocalizedStringFromTableInBundle(@"Done", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
    
    if(fbVariation)
    {
        lblCreateAccount.text = NSLocalizedStringFromTableInBundle(@"Create account with Facebook", nil, [[Helper sharedInstance] getLocalBundle], nil);
    }else
    {
        lblCreateAccount.text = NSLocalizedStringFromTableInBundle(@"Create account with mobile number", nil, [[Helper sharedInstance] getLocalBundle], nil);
        
    }
    
    firstNameTxtField.placeholder = NSLocalizedStringFromTableInBundle(@"First name (required)", nil, [[Helper sharedInstance] getLocalBundle], nil);
    lastNameTxtField.placeholder = NSLocalizedStringFromTableInBundle(@"Last name (required)", nil, [[Helper sharedInstance] getLocalBundle], nil);
    mobileTxtField.placeholder = NSLocalizedStringFromTableInBundle(@"Mobile number (required)", nil, [[Helper sharedInstance] getLocalBundle], nil);
    emailTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Email (required)", nil, [[Helper sharedInstance] getLocalBundle], nil);
    imeiTextField.placeholder = NSLocalizedStringFromTableInBundle(@"IMEI (required)", nil, [[Helper sharedInstance] getLocalBundle], nil);
    addressTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Address line 1", nil, [[Helper sharedInstance] getLocalBundle], nil);
    postalTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Postal code", nil, [[Helper sharedInstance] getLocalBundle], nil);
    addressLineTwo.placeholder = NSLocalizedStringFromTableInBundle(@"Address line 2", nil, [[Helper sharedInstance] getLocalBundle], nil);
    passwordTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Password (required)", nil, [[Helper sharedInstance] getLocalBundle], nil);
}

-(void)setupNumberKeyboardWithDone
{
    UIToolbar *ViewForDoneButtonOnKeyboard = [[UIToolbar alloc] init];
    [ViewForDoneButtonOnKeyboard sizeToFit];
    UIBarButtonItem *btnDoneOnKeyboard = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                          style:UIBarButtonItemStylePlain target:self
                                                                         action:@selector(doneClicked:)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [ViewForDoneButtonOnKeyboard setItems:[NSArray arrayWithObjects:flexible,btnDoneOnKeyboard, nil]];
    
    mobileTxtField.inputAccessoryView = ViewForDoneButtonOnKeyboard;
    imeiTextField.inputAccessoryView = ViewForDoneButtonOnKeyboard;
}

-(IBAction)doneAction:(id)sender
{
    if([self checkInputValidation])
    {
        [self customerExist];
    }
}

-(IBAction)doneClicked:(id)sender
{
    [mobileTxtField resignFirstResponder];
    [imeiTextField resignFirstResponder];
}

-(BOOL)checkInputValidation
{
    if([firstNameTxtField.text isEqualToString:@""] && [lastNameTxtField.text isEqualToString:@""] && [mobileTxtField.text isEqualToString:@""] && [emailTextField.text isEqualToString:@""]&&[imeiTextField.text isEqualToString:@""] && [addressTextField.text isEqualToString:@""] && [passwordTextField.text isEqualToString:@""])
    {
        [Helper popUpMessage: NSLocalizedStringFromTableInBundle(@"Please enter all fields", nil, [[Helper sharedInstance] getLocalBundle], nil) titleForPopUp:@"    " view:[UIView new]];
        
        return false;
    }else if ([firstNameTxtField.text isEqualToString:@""])
    {
        firstNameTxtField.errorText = NSLocalizedStringFromTableInBundle(@"Please enter your first name", nil, [[Helper sharedInstance] getLocalBundle], nil);
        [firstNameTxtField showError];
        
        return false;
        
    }else if ([lastNameTxtField.text isEqualToString:@""])
    {
        lastNameTxtField.errorText = NSLocalizedStringFromTableInBundle(@"Please enter your last name", nil, [[Helper sharedInstance] getLocalBundle], nil);
        [lastNameTxtField showError];
        
        return false;
    }else if (mobileTxtField.text.length < 8)
    {
        mobileTxtField.errorText = NSLocalizedStringFromTableInBundle(@"Please enter your mobile number", nil, [[Helper sharedInstance] getLocalBundle], nil);
        [mobileTxtField showError];
        
        return false;
    }else if ([emailTextField.text isEqualToString:@""])
    {
        emailTextField.errorText =  NSLocalizedStringFromTableInBundle(@"Please enter your email address", nil, [[Helper sharedInstance] getLocalBundle], nil);
        [emailTextField showError];
        
        return false;
    }else if ([imeiTextField.text isEqualToString:@""])
    {
        imeiTextField.errorText = NSLocalizedStringFromTableInBundle(@"Please enter your imei number", nil, [[Helper sharedInstance] getLocalBundle], nil);
        [imeiTextField showError];
        
        return false;
    }
    
    if(!fbVariation)
    {
        if ([passwordTextField.text isEqualToString:@""])
        {
            passwordTextField.errorText = NSLocalizedStringFromTableInBundle(@"please enter your password", nil, [[Helper sharedInstance] getLocalBundle], nil);
            [passwordTextField showError];
            
            return false;
        }
    }
    
    return true;
    
}

-(IBAction)textFieldTypes:(UITextField *)textField
{
    NSString *strText = textField.text;
    
    if(textField == firstNameTxtField)
    {
        if(strText.length!=0)
        {
            firstNameTxtField.placeholder = NSLocalizedStringFromTableInBundle(@"First name", nil, [[Helper sharedInstance] getLocalBundle], nil);
        }
    }
    else if (textField == lastNameTxtField)
    {
        if(strText.length!=0)
        {
            lastNameTxtField.placeholder = NSLocalizedStringFromTableInBundle(@"Last name", nil, [[Helper sharedInstance] getLocalBundle], nil);
        }
        
    }
    else if (textField == mobileTxtField)
    {
        if(strText.length!=0)
        {
            mobileTxtField.placeholder = NSLocalizedStringFromTableInBundle(@"Mobile number", nil, [[Helper sharedInstance] getLocalBundle], nil);
        }
        
    }
    else if (textField == emailTextField)
    {
        if(strText.length!=0)
        {
            emailTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Email", nil, [[Helper sharedInstance] getLocalBundle], nil);
        }
        
    }
    else if (textField == imeiTextField)
    {
        if(strText.length!=0)
        {
            imeiTextField.placeholder = NSLocalizedStringFromTableInBundle(@"IMEI", nil, [[Helper sharedInstance] getLocalBundle], nil);
        }
        
    }
    else if (textField == postalTextField)
    {
        if(strText.length!=0)
        {
            postalTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Postal code", nil, [[Helper sharedInstance] getLocalBundle], nil);
        }
        
    }
    else if (textField == addressTextField)
    {
        if(strText.length!=0)
        {
            addressTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Address line 1", nil, [[Helper sharedInstance] getLocalBundle], nil);
        }
    }
    else if (textField == addressLineTwo)
    {
        if(strText.length!=0)
        {
            addressLineTwo.placeholder = NSLocalizedStringFromTableInBundle(@"Address line 2", nil, [[Helper sharedInstance] getLocalBundle], nil);
        }
    }
    else if (textField == passwordTextField)
    {
        if(strText.length!=0)
        {
            passwordTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Password", nil, [[Helper sharedInstance] getLocalBundle], nil);
        }
    }
}

#pragma mark - API Calls
//Customer Exist API Call
-(void)customerExist
{
    NSDictionary *elementDictionary =@{@"email":emailTextField.text,
                                       @"mobile":[NSString stringWithFormat:@"+%@",mobileTxtField.text],
                                       @"imei":imeiTextField.text};
    
    [commonRequest customerExist:elementDictionary];
}

-(NSDictionary *)getElementDictionary:(NSString *)customerID is_portal:(NSString *)strPortalUser
{
    NSString *deviceName = @"IPHONE";
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        deviceName = @"IPAD";
    }
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    
    if(deviceToken.length == 0)
    {
        deviceToken = @"NO TOKEN";
    }
    
    NSString *assignedUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"result"] objectForKey:@"userId"];
    
    NSString *address = [NSString stringWithFormat:@"%@",addressTextField.text];
    NSString *address2 = [NSString stringWithFormat:@"%@",addressLineTwo.text];
    //    NSString *pincode = [NSString stringWithFormat:@"%@",postalTextField.text];
    
    address = [NSString stringWithFormat:@"%@, %@",address,address2];
    
    NSString *strCountry = [[NSUserDefaults standardUserDefaults] objectForKey:@"Country"];
    NSString *countryName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CountryName"];
    
    NSDictionary *elementDictionary =@{
                                       @"firstname":firstNameTxtField.text,
                                       @"lastname":lastNameTxtField.text,
                                       @"email":emailTextField.text,
                                       @"mobile":mobileTxtField.text,
                                       @"mailingstreet":address,
                                       @"cf_1277":deviceToken,//device token
                                       @"cf_1281":[[Helper sharedInstance] deviceModelName],//cf_1281 device version
                                       @"cf_1372":@"IOS",
                                       @"cf_1279":deviceName,//device model
                                       @"cf_1260":imeiTextField.text,
                                       @"assigned_user_id":assignedUserId,
                                       @"mailingpobox":@"",
                                       @"mailingstate":@"",
                                       @"mailingcountry":countryName,
                                       @"mailingcity":@"",
                                       @"cf_1283":[NSString stringWithFormat:@"70x%@",strCountry],
                                       @"password":passwordTextField.text,
                                       @"is_portal_user":strPortalUser,
                                       @"id":customerID
                                       };
    
    return elementDictionary;
}

//Update Profile API Call
-(void)updateCustomer:(NSString *)customerID is_portal:(NSString *)strPortalUser
{
    [SVProgressHUD showWithStatus:@"Loading.."];
    
    NSDictionary *elementDictionary = [self getElementDictionary:customerID is_portal:strPortalUser];
    
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
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    NSDictionary *paramDictionary=[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"ams.update_profile", @"operation",
                                   sessionName,@"sessionName",
                                   jsonData,@"element",
                                   nil];
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableURLRequest *request;
    
    request=[serializer multipartFormRequestWithMethod:@"POST" URLString:BASEURL parameters:paramDictionary constructingBodyWithBlock:nil error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress)
                  {
                  }
                  completionHandler:^(NSURLResponse * _Nonnull responseObject, id  _Nullable response, NSError * _Nullable error) {
                      if (error) {
                          
                      } else
                      {
                          NSLog(@"RESPONSE FOR UPDATE PROFILE API %@", response);
                          
                          BOOL success=[[response objectForKey:@"success"] boolValue];
                          
                          if(success)
                          {
                              NSString *status=[NSString stringWithFormat:@"%@",[[response objectForKey:@"result"] objectForKey:@"status"]];
                              
                              if([status isEqualToString:@"success"])
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
                                  
                                  [self redirectionAfterSuccess];
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

//Facebook API Call
-(void)createFbLogin
{
    [SVProgressHUD showWithStatus:@"Loading.."];
    
    NSString *deviceName = @"IPHONE";
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
    {
        deviceName=@"IPAD";
    }
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    
    if(deviceToken.length == 0)
    {
        deviceToken = @"NO TOKEN";
    }
    
    NSString *assignedUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"result"] objectForKey:@"userId"];
    NSString *address = [NSString stringWithFormat:@"%@",addressTextField.text];
    NSString *address2 = [NSString stringWithFormat:@"%@",addressLineTwo.text];
    NSString *pincode = [NSString stringWithFormat:@"%@",postalTextField.text];
    
    address = [NSString stringWithFormat:@"%@, %@",address,address2];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    NSString *strCountry = [[NSUserDefaults standardUserDefaults] objectForKey:@"Country"];
    NSString *countryName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CountryName"];
    
    NSDictionary *elementDictionary =@{
                                       @"facebook_id":[fbDic objectForKey:@"fbId"],
                                       @"firstname":firstNameTxtField.text,
                                       @"lastname":lastNameTxtField.text,
                                       @"email":emailTextField.text,
                                       @"mobile":[NSString stringWithFormat:@"%@%@",@"+",mobileTxtField.text],
                                       @"cf_1260":imeiTextField.text,
                                       @"mailingstreet":address,
                                       @"cf_1277":deviceToken,//device token
                                       @"cf_1281":[[Helper sharedInstance] deviceModelName],//cf_1281 device version
                                       @"cf_1279":deviceName,
                                       @"imageurl":[fbDic objectForKey:@"img"],
                                       @"cf_1372":@"IOS",
                                       @"mailingpobox":pincode,
                                       @"mailingstate":@"",
                                       @"mailingcountry":countryName,
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
    } else {
        NSLog(@"Got an error: %@", error);
        jsonString = @"";
    }
    
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
                    [Helper popUpMessage:[[json objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"Alert" view:[UIView new]];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] setObject:[[json objectForKey:@"result"] objectForKey:@"data"] forKey:@"profile"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"FBLOGIN"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self redirectionAfterSuccess];
                }
            }
            else
            {
                [SVProgressHUD dismiss];
                [Helper popUpMessage:[[json objectForKey:@"error"] objectForKey:@"message"] titleForPopUp:@"Error" view:[UIView new]];
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

//Create Account API Call
-(void)createCustomer
{
    [SVProgressHUD showWithStatus:@"Loading.."];
    
    if([self checkInputValidation])
    {
        NSString *deviceName = @"IPHONE";
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
        {
            deviceName=@"IPAD";
        }
        
        STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
        
        NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
        
        if(deviceToken.length == 0)
        {
            deviceToken = @"simulator";
        }
        
        NSString *assignedUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"result"] objectForKey:@"userId"];
        NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
        NSString *strCountry = [[NSUserDefaults standardUserDefaults] objectForKey:@"Country"];
        NSString *address = [NSString stringWithFormat:@"%@",addressTextField.text];
        NSString *address2 = [NSString stringWithFormat:@"%@",addressLineTwo.text];
        NSString *pincode = [NSString stringWithFormat:@"%@",postalTextField.text];
        
        NSString *imei = [imeiTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *countryName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CountryName"];
        
        NSString *password = passwordTextField.text;
        
        if(fbVariation)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"FBLOGIN"];
            password = @"facebook";
        }else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"FBLOGIN"];
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSDictionary *elementDictionary =@{@"firstname":firstNameTxtField.text,
                                           @"lastname":lastNameTxtField.text,
                                           @"password":password,
                                           @"email":emailTextField.text,
                                           @"mobile":[NSString stringWithFormat:@"%@%@",@"+",mobileTxtField.text],
                                           @"cf_1260":imei,
                                           @"mailingstreet":address,
                                           @"cf_1277":deviceToken,//device token
                                           @"cf_1281":[[Helper sharedInstance] deviceModelName],//cf_1281 device version
                                           @"cf_1279":deviceName,//device model
                                           @"cf_1372":@"IOS",
                                           @"assigned_user_id":assignedUserId,
                                           @"mailingpobox":pincode,
                                           @"mailingstate":@"",
                                           @"mailingcountry":countryName,
                                           @"mailingcity":address2,
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
        
        response.POSTDictionary = @{@"operation":@"create",
                                    @"sessionName":sessionName,
                                    @"element":jsonString,
                                    @"elementType":@"Contacts"
                                    };
        
        
        response.completionBlock = ^(NSDictionary *headers, NSString *body) {
            NSError* error;
            
            @try {
                NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:kNilOptions
                                                                              error:&error];
                json = [json replaceNullsWithObject:@"NA"];
                
                BOOL success = [[json objectForKey:@"success"] boolValue];
                
                NSString *status = [[json objectForKey:@"result"] objectForKey:@"status"];
                NSLog(@"RESULT OF CREATE API = %@",json);
                
                if(success)
                {
                    if([status isEqualToString:@"success"])
                    {
                        [self redirectToOTP];
                    }
                    else
                    {
                        [Helper popUpMessage:[[json objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"Alert" view:[UIView new]];
                    }
                }
                else
                {
                    [Helper popUpMessage:[[json objectForKey:@"error"] objectForKey:@"message"] titleForPopUp:@"Error" view:[UIView new]];
                }
                
                [SVProgressHUD dismiss];
                
                
            }@catch (NSException *exception) {
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
}

#pragma mark - Actions

- (IBAction)questionAction:(id)sender {
    
    NSString *messageStr = NSLocalizedStringFromTableInBundle(@"Get your IMEI in Settings, select General and About. Or dial *#06#", nil, [[Helper sharedInstance] getLocalBundle], nil);
    
    LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:@"" message:messageStr style:LGAlertViewStyleAlert buttonTitles:@[@"Setting",@"Cancel"] cancelButtonTitle:nil destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
        
        if([title isEqualToString:@"Setting"])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=GENERAL"]];
        }
        
    } cancelHandler:^(LGAlertView * _Nonnull alertView) {
        
    } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
        
    }];
    
    alertView.tintColor = THEMECOLOR;
    
    [alertView show];
}

-(IBAction)backAction:(id)sender
{
    if(isPresentedModally)
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
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

-(void)redirectionAfterSuccess
{
    if([originScreen isEqualToString:@"welcome"])
    {
        UITabBarController *homeTab = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomTabBarController"];
        [self.navigationController pushViewController:homeTab animated:YES];
    }else if([originScreen isEqualToString:@"more"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)redirectToOTP
{
    NSString *mobileNumber = [NSString stringWithFormat:@"%@",mobileTxtField.text];
    
    OTPViewController *otpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OTPViewController"];
    otpViewController.mobileNumber = mobileNumber;
    otpViewController.isPresentedModally = isPresentedModally;
    otpViewController.originScreen = originScreen;
    
    [self.navigationController pushViewController:otpViewController animated:YES];
}

#pragma mark - Common Request Delegate

- (void)commonRequestGetResponse:(NSDictionary *)response withAPIName:(NSString *)name
{
    @try {
        
        NSDictionary *resultDict = [response objectForKey:@"result"];
        
        BOOL success = [[response objectForKey:@"success"] boolValue];
        bool is_portal_user = [[resultDict objectForKey:@"is_portal_user"] boolValue];
        bool is_exist_policy = [[resultDict objectForKey:@"is_exist_user"] boolValue];
        
        //is_exist_policy = 1 and is_portal_user == 0 - This is done specifically for old customers who are coming into the app for the first time. In this case we have to call update profile
        if(!is_portal_user && is_exist_policy)
        {
            NSArray *userData = [resultDict objectForKey:@"userdata"];
            
            if(userData.count==0)
            {
                [Helper popUpMessage:@"Please proceed to login with your registered email and password" titleForPopUp:@"Already registered!" view:[UIView new]];
                [SVProgressHUD dismiss];
            }
            else
            {
                NSString *strCustomerId = [[resultDict objectForKey:@"userdata"] objectForKey:@"user_id"];
                NSArray *arrID = [strCustomerId componentsSeparatedByString:@"x"];
                [self updateCustomer:arrID[1] is_portal:[[response objectForKey:@"result"]objectForKey:@"is_portal_user"]];
            }
        }
        else
        {
            NSString *failure = [resultDict objectForKey:@"status"];
            NSString *failureMessage = [NSString stringWithFormat:@"%@",[[response objectForKey:@"result"] objectForKey:@"message"]];
            
            if([failureMessage isEqualToString:@"Already registered. Please try logging in with the registered email and password."]||[failureMessage  isEqualToString:@"Multiple Customer with same email id, mobile & Imei !!"])
            {
                failureMessage = NSLocalizedStringFromTableInBundle(@"Email ID, mobile number and/or IMEI already exists. Please proceed to login.", nil, [[Helper sharedInstance] getLocalBundle], nil);
            }
            
            if(success)
            {
                [SVProgressHUD dismiss];
                
                if([failure isEqualToString:@"failure"]||[failure isEqualToString:@"failed"])
                {
                    LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:@"" message:failureMessage style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"Login" destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
                    } cancelHandler:^(LGAlertView * _Nonnull alertView) {
                        
                        LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
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
                [Helper popUpMessage:[[response objectForKey:@"error"] objectForKey:@"message"] titleForPopUp:@"Error" view:[UIView new]];
            }
        }
    } @catch (NSException *exception) {
        [Helper popUpMessage:@"We are upgrading our server...." titleForPopUp:@"Error" view:[UIView new]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

