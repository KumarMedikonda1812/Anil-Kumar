//
//  SummaryViewController.m
//  TecProtec
//
//  Created by kishore kumar on 08/09/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "SummaryViewController.h"

@interface SummaryViewController ()

@end

@implementation SummaryViewController
@synthesize paymentSdk,summaryTableView;
@synthesize isTablet;
@synthesize volumeBool,muteBool,frontCamBool,rearCamBool,screenTestBool,wifiBool,dataConnectionBool,batteryBool,gyroBool,bluetoothBool,gpsBool,screenShotBool;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"Summary", nil, [[Helper sharedInstance] getLocalBundle], nil);
    
    [self setupNIB];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackMore"] style:UIBarButtonItemStylePlain target:self action:@selector(backActionTop:)];
    backButton.tintColor = [Helper colorWithHexString:@"#FF304B"];
    self.navigationItem.leftBarButtonItem = backButton;
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"summary"];
    NSDictionary *retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    policyModel = [[PolicyModel alloc] init];
    [policyModel updateModelWithDictionary: retrievedDictionary];
    
    NSDictionary *dicProductDetails = [[NSDictionary alloc] initWithDictionary:retrievedDictionary];
    
    NSString *apiLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"ApiCurrentLanguage"];
    
    if([apiLanguage isEqualToString:@"english"])
    {
        prodtnc = [NSString stringWithFormat:@"%@",[dicProductDetails objectForKey:@"prodtnc"]];
    }else
    {
        prodtnc = [NSString stringWithFormat:@"%@",[dicProductDetails objectForKey:@"cf_2443"]];
    }
    
    arrTitle = @[@"Header",@"Price",@"Terms & Conditions"];
    
    summaryTableView.tableFooterView = [UIView new];
    
    selected = YES;
    two = YES;
    three = YES;
    
    [summaryTableView reloadData];
    
    [[Helper sharedInstance] trackingScreen:@"Summary_screen_ios"];
    
    [_btnProceedtoPay setTitle:NSLocalizedStringFromTableInBundle(@"Proceed to pay", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
}

-(void)setupNIB
{
    [summaryTableView registerNib:[UINib nibWithNibName:@"SummaryScreenTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SummaryScreenTableViewCell"];
    [summaryTableView registerNib:[UINib nibWithNibName:@"PolicyPriceTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PolicyPriceTableViewCell"];
    [summaryTableView registerNib:[UINib nibWithNibName:@"TermsAndConditionTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TermsAndConditionTableViewCell"];
}

#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        SummaryScreenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SummaryScreenTableViewCell"];
        if(!cell)
        {
            cell = [[SummaryScreenTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SummaryScreenTableViewCell"];
        }
        NSString *colorHexaCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProductColor"];
        cell.hearderBackground.backgroundColor = [Helper colorWithHexString:colorHexaCode];
        //NSString *imgUrl = [NSString stringWithFormat:@"%@",[dicProductDetails objectForKey:@"imagename"]];
        //[cell.imgFeatures sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"premium_plan"]];
        [cell.btnBack addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.lblHeader.text = policyModel.planName;
        cell.clipsToBounds = YES;
        
        cell.lblDescription.text = policyModel.planDescriptions;
        
        return cell;
        
    }
    else if(indexPath.section==1)
    {
        PolicyPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PolicyPriceTableViewCell"];
        if(!cell)
        {
            cell = [[PolicyPriceTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PolicyPriceTableViewCell"];
        }
        
        cell.priceLabel.text = policyModel.planPrice;
        
        return cell;
    }
    else
    {
        TermsAndConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TermsAndConditionTableViewCell"];
        if(!cell)
        {
            cell = [[TermsAndConditionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TermsAndConditionTableViewCell"];
        }
        [cell.bemCheckBox addTarget:self action:@selector(ActionCheckbox:) forControlEvents:UIControlEventValueChanged];
        [cell.bemCheckBoxTwo addTarget:self action:@selector(ActionCheckboxTwo:) forControlEvents:UIControlEventValueChanged];
        [cell.bemCheckBoxThree addTarget:self action:@selector(ActionCheckboxThree:) forControlEvents:UIControlEventValueChanged];
        
        NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguage"];
        
        if([language isEqualToString:@"id"])
        {
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@"Saya mengerti dan setuju dengan syarat ketentuannya."];
            [string addAttribute:NSForegroundColorAttributeName value:[Helper colorWithHexString:@"FD334F"] range:NSMakeRange(31,20)];
            
            cell.lblTermsAndCondition.attributedText = string;
        }else
        {
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@"I understand and agree to the terms and conditions."];
            [string addAttribute:NSForegroundColorAttributeName value:[Helper colorWithHexString:@"FD334F"] range:NSMakeRange(30,20)];
            
            cell.lblTermsAndCondition.attributedText = string;
        }
        
        cell.lblPrivacyPolicy.text = NSLocalizedStringFromTableInBundle(@"I understand that device purchase receipt is required upon submitting a claim.", nil, [[Helper sharedInstance] getLocalBundle], nil);
        //Saya mengerti bahwa, bukti pembelian asli dibutuhkan saat melakukan klaim
        cell.lblMobileTermsandCondition.text = NSLocalizedStringFromTableInBundle(@"I certify that all details I provide are true and correct.", nil, [[Helper sharedInstance] getLocalBundle], nil);
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [cell.lblTermsAndCondition addGestureRecognizer:tapGestureRecognizer];
        cell.lblTermsAndCondition.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGestureRecognizerTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTappedTwo)];
        tapGestureRecognizerTwo.numberOfTapsRequired = 1;
        [cell.lblPrivacyPolicy addGestureRecognizer:tapGestureRecognizerTwo];
        cell.lblPrivacyPolicy.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGestureRecognizerThree = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTappedThree)];
        tapGestureRecognizerThree.numberOfTapsRequired = 1;
        [cell.lblMobileTermsandCondition addGestureRecognizer:tapGestureRecognizerThree];
        cell.lblMobileTermsandCondition.userInteractionEnabled = YES;
        
        
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        return 200;
    }
    else if (indexPath.section==1)
    {
        return 60;
    }
    else
    {
        return 180;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==1||section==2)
    {
        return 50;
    }
    else
    {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.tableHeaderView.frame.size.height)];
    view.backgroundColor = [UIColor whiteColor];
    
    if(section!=0)
    {
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(20,10, tableView.frame.size.width-40, 0.5)];
        viewLine.backgroundColor = [UIColor grayColor];
        [view addSubview:viewLine];
        
    }
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,30, tableView.frame.size.width, 20)];
    [label setFont:[UIFont fontWithName:@"Roboto-Medium" size:20]];
    label.textColor = [UIColor blackColor];
    if(section==1||section==2)
    {
        NSString *title = [NSString stringWithFormat:@"%@",arrTitle[section]];
        label.text = NSLocalizedStringFromTableInBundle(title, nil, [[Helper sharedInstance] getLocalBundle], nil);
        [view addSubview:label];
    }
    
    return view;
}

-(IBAction)backActionTop:(id)sender
{
    LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:@"" message:@"Do you want to cancel the purchase ?" style:LGAlertViewStyleAlert buttonTitles:@[@"Yes",@"Cancel"] cancelButtonTitle:nil destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
        if([title isEqualToString:@"Yes"])
        {
            for (UIViewController *controller in self.navigationController.viewControllers)
            {
                if ([controller isKindOfClass:[PolicyDetailViewController class]])
                {
                    //Do not forget to import AnOldViewController.h
                    
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

-(void)labelTapped
{
    WebViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webViewController.check = YES;
    webViewController.strURL = prodtnc;
    [self.navigationController pushViewController:webViewController animated:YES];
}

-(void)labelTappedTwo
{
    TermsViewController *termsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
    termsViewController.strTitle = @"Privacy policy";
    termsViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:termsViewController animated:YES];
    
}

-(void)labelTappedThree
{
    TermsViewController *termsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
    termsViewController.strTitle = @"Terms of Use";//Terms of Use
    termsViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:termsViewController animated:YES];
    
}

-(void)purchasePolicy
{
    if(isTablet)
    {
        [SVProgressHUD showWithStatus:@"Loading..."];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"20% Completed"];
    }
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    NSString *productIds = [[NSUserDefaults standardUserDefaults] objectForKey:@"productid"];
    NSString *userDeviceCost = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDeviceCost"];
    
    NSString *listPrice = [[NSUserDefaults standardUserDefaults] objectForKey:@"listPrice"];
    
    NSNumberFormatter *myformatter = [NSNumberFormatter new];
    [myformatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *tempPrice = [myformatter numberFromString:listPrice];
    NSString *finalPrice = [tempPrice stringValue];
    
    NSNumber *tempGadgetPrice = [myformatter numberFromString:userDeviceCost];
    NSString *finalUserDeviceCost = [tempGadgetPrice stringValue];
    
    NSString *month = [[NSUserDefaults standardUserDefaults] objectForKey:@"month"];
    month = [month stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    //price_inc_vat
    
    
    bool renew = [[[NSUserDefaults standardUserDefaults] objectForKey:@"RENEW"] boolValue];
    
    if(renew)
    {
        [formatter setDateFormat:@"yyyy-MM-dd"];
        dateStr =  [[NSUserDefaults standardUserDefaults] objectForKey:@"endDate"];
        NSDate * formatChangingDate = [formatter dateFromString:dateStr];
        int daysToAdd = 1;
        NSDate *newDate = [formatChangingDate dateByAddingTimeInterval:60*60*24*daysToAdd];
        [formatter setDateFormat:@"MM-dd-yyyy"];
        dateStr = [formatter stringFromDate:newDate];
    }
    else
    {
        dateStr = [formatter stringFromDate:[NSDate date]];
    }
    
    NSDictionary *profile = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];
    _strIMEI = [_strIMEI stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary *elementDictionary =@{
                                       @"contactid":[profile objectForKey:@"customerid"],
                                       @"subject":_strIMEI,//imei number
                                       @"cf_1297":dateStr,//today date
                                       @"cf_1925":dateStr,
                                       @"cf_1333":finalUserDeviceCost,//user device price
                                       @"purchase_date":[NSString stringWithFormat:@"%@",month],//device purchase date
                                       @"productid":productIds,//product id
                                       @"listprice":finalPrice,//policy price
                                       @"cf_2026":_strMake//make textfield
                                       };
    elementDictionaryPolicy = elementDictionary;
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
    
    response.POSTDictionary = @{@"operation":@"ams.add_policy",
                                @"sessionName":sessionName,
                                @"element":jsonString,
                                @"userId":@"19x11"
                                };
    
    NSLog(@"PARAMETER = %@",response.POSTDictionary);
    
    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:kNilOptions
                                                                      error:&error];
        
        json = [json replaceNullsWithObject:@"NA"];
        
        @try {
            BOOL success = [[json objectForKey:@"success"] boolValue];
            NSString *failure = [[json objectForKey:@"result"] objectForKey:@"status"];
            
            NSLog(@"RESPONSE = %@",json);
            
            if(success)
            {
                [SVProgressHUD dismiss];
                
                if([failure isEqualToString:@"failure"]||[failure isEqualToString:@"failed"])
                {
                    NSString *message = [[json objectForKey:@"result"] objectForKey:@"message"];
                    NSString *btnTitle;
                    if ([message isEqualToString:@"This mobile number already has an existing plan for your smartphone. Kindly log in with your existing account and view plans under Profile."])
                    {
                        //Anda telah memiliki proteksi pada Akun ini; Anda hanya diperbolehkan memiliki 1 proteksi untuk 1 buah Ponsel. Mohon periksa kembali proteksi Anda atau hubungi 0804-1401-078 untuk bantuan.
                        
                        message = NSLocalizedStringFromTableInBundle(@"Your account has an existing plan; you can only have 1 plan for every smartphone. Kindly view your existing plan or call 0804-1401-078 for assistance.", nil, [[Helper sharedInstance] getLocalBundle], nil);
                        btnTitle = @"View Plans";
                        
                    }
                    else
                    {
                        btnTitle = @"Ok";
                    }
                    
                    LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:message message:@"" style:LGAlertViewStyleAlert buttonTitles:@[btnTitle] cancelButtonTitle:nil destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
                        
                        if([title isEqualToString:@"View Plans"])
                        {
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }
                    } cancelHandler:^(LGAlertView * _Nonnull alertView) {
                        
                    } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
                        
                    }];
                    alertView.tintColor = THEMECOLOR;
                    [alertView show];
                }
                else
                {
                    policyId = [[json objectForKey:@"result"] objectForKey:@"policyid"];
                    
                    if(isTablet)
                    {
                        [self ipayMethodTotal:elementDictionaryPolicy referenceNumber:policyId];
                    }
                    else
                    {
                        [self crackScreenServiceRequest];
                    }
                }
            }
            else
            {
                [SVProgressHUD dismiss];
                [Helper popUpMessage:[[json objectForKey:@"error"] objectForKey:@"message"] titleForPopUp:@"Error" view:[UIView new]];
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

-(void)crackScreenServiceRequest
{
    [SVProgressHUD showWithStatus:@"40% Completed"];
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    
    NSString *assignedUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"result"] objectForKey:@"userId"];
    //contactid
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"profile"]);
    NSString *customerID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"profile"] objectForKey:@"customerid"];
    //{
    
    NSDictionary *elementDictionary =@{@"title":@"Crack Screen",
                                       @"contact_id":customerID,
                                       @"parent_id":@"0",
                                       @"priority":@"Low",
                                       @"product_id":@"0",
                                       @"severity":@"Low",
                                       @"status":@"Open",
                                       @"category":@"category",
                                       @"hours":@"21.05",
                                       @"days":@"2",
                                       @"description":@"crack screen ios",
                                       @"solution":@"solution of ticket",
                                       @"policyid":policyId
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
    
    response.POSTDictionary = @{@"operation":@"ams.createservicerequest",
                                @"sessionName":sessionName,
                                @"userId":assignedUserId,
                                @"element":jsonString
                                };
    
    
    
    NSLog(@"PARAMETER = %@",response.POSTDictionary);
    
    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:kNilOptions
                                                                      error:&error];
        
        json = [json replaceNullsWithObject:@"NA"];
        
        BOOL success = [[json objectForKey:@"success"] boolValue];
        NSString *failure = [[json objectForKey:@"result"] objectForKey:@"status"];
        
        NSLog(@"RESPONSE = %@",json);
        
        if(success)
        {
            [SVProgressHUD dismiss];
            
            if([failure isEqualToString:@"failure"]||[failure isEqualToString:@"failed"])
            {
                [Helper popUpMessage:[[json objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"Alert" view:[UIView new]];
            }
            else
            {
                [self documentRequest:[[json objectForKey:@"result"] objectForKey:@"serviceid"]];
            }
        }
        else
        {
            [SVProgressHUD dismiss];
            [Helper popUpMessage:[[json objectForKey:@"error"] objectForKey:@"message"] titleForPopUp:@"Error" view:[UIView new]];
        }
    };
    response.errorBlock = ^(NSError *error) {
        // ...
        [SVProgressHUD dismiss];
        [Helper popUpMessage:error.localizedDescription titleForPopUp:@"Error" view:[UIView new]];
    };
    
    [response startAsynchronous];
    
    
}

-(void)documentRequest:(NSString *)serviceid
{
    
    [SVProgressHUD showWithStatus:@"60% Completed"];
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    NSString *assignedUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"result"] objectForKey:@"userId"];
    
    NSDictionary *elementDictionary =@{@"notes_title":@"Note documents",
                                       @"record_id":serviceid,
                                       @"notecontent":@"note content",
                                       @"policy_id":policyId,
                                       @"type":@"HelpDesk"
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
    
    NSDictionary *paramDictionary = @{@"operation":@"ams.createdocument",
                                      @"sessionName":sessionName,
                                      @"userId":assignedUserId,
                                      @"element":jsonString
                                      };
    NSMutableURLRequest *request;
    
    NSLog(@"Your JSON String is %@", paramDictionary);
    
    NSData *crackScreen = [[NSUserDefaults standardUserDefaults] objectForKey:@"crackScreenImage"];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    if(crackScreen)
    {
        request=[serializer multipartFormRequestWithMethod:@"POST" URLString:BASEURL parameters:paramDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                 {
                     if(crackScreen)
                     {
                         [formData appendPartWithFileData:crackScreen
                                                     name:@"document"
                                                 fileName:[NSString stringWithFormat:@"%@.jpg",sessionName]
                                                 mimeType:@"image/jpg"];
                         
                     }
                 } error:nil];
        
    }
    else
    {
        request=[serializer multipartFormRequestWithMethod:@"POST" URLString:BASEURL parameters:paramDictionary constructingBodyWithBlock:nil error:nil];
    }
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    jsonResponseSerializer.acceptableContentTypes = nil;
    manager.responseSerializer = jsonResponseSerializer;
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress)
                  {
                      dispatch_async(dispatch_get_main_queue(),
                                     ^{
                                         
                                     });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull responseObject, id  _Nullable response, NSError * _Nullable error) {
                      if (error) {
                          [SVProgressHUD dismiss];
                      } else
                      {
                          NSLog(@"%@ %@", response, responseObject);
                          BOOL success=[[response objectForKey:@"success"] boolValue];
                          if(success)
                          {
                              NSString *status=[[response objectForKey:@"result"] objectForKey:@"status"];
                              
                              if([status isEqualToString:@"success"])
                              {
                                  [self healthCheckApi];
                              }
                              else
                              {
                                  [Helper popUpMessage:[[response objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"Alert" view:[UIView new]];
                                  [SVProgressHUD dismiss];
                              }
                          }
                          else
                          {
                              [SVProgressHUD dismiss];
                          }
                          
                          
                      }
                  }];
    
    [uploadTask resume];
}

-(uint64_t)getFreeDiskspace {
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    
    return totalFreeSpace;
}

-(void)healthCheckApi
{
    [SVProgressHUD showWithStatus:@"80% Completed"];
    
    gyroBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"gyro"] boolValue];
    batteryBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"battery"] boolValue];
    gpsBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"gps"] boolValue];
    bluetoothBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bluetooth"] boolValue];
    dataConnectionBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"dataConnection"] boolValue];
    wifiBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"wifi"] boolValue];
    frontCamBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"frontCamera"] boolValue];
    rearCamBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"backCamera"] boolValue];
    screenTestBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"screenTest"] boolValue];
    screenShotBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"screenShot"] boolValue];
    volumeBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"volume"] boolValue];
    muteBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"mute"] boolValue];
    //contactid
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"profile"]);
    NSString *customerID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"profile"] objectForKey:@"customerid"];
    //{
    NSDictionary *profileDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];
    
    NSString *deviceCost = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDeviceCost"];
    NSString *countryName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CountryName"];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    NSString *mobileNumber = [NSString stringWithFormat:@"%@",[profileDictionary objectForKey:@"mobile"]];
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    UIDevice *myDevice = [UIDevice currentDevice];
    
    [myDevice setBatteryMonitoringEnabled:YES];
    double batLeft = (float)[myDevice batteryLevel] * 100;
    NSLog(@"%.f",batLeft);
    NSString *month = [[NSUserDefaults standardUserDefaults] objectForKey:@"month"];
    NSString *year = [[NSUserDefaults standardUserDefaults] objectForKey:@"year"];
    
    if(mobileNumber.length==0)
    {
        mobileNumber = @"N/A";
    }
    NSDictionary *profileDetails = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];
    NSLog(@"profile details = %@",profileDetails);
    
    CGFloat deviceVersion = [[[UIDevice currentDevice] systemVersion] floatValue] ;
    NSDictionary *elementDictionary =@{@"country":countryName,
                                       @"user_id":customerID,
                                       @"firstname":[profileDetails objectForKey:@"firstname"],
                                       @"lastname":[profileDetails objectForKey:@"lastname"],
                                       @"mobile":mobileNumber,
                                       @"email":[profileDictionary objectForKey:@"email"],
                                       @"device_token":deviceToken,
                                       @"device_os":@(deviceVersion),
                                       @"volume_increase":@(volumeBool),
                                       @"screenshot":@(screenShotBool),
                                       @"front_camera":@(frontCamBool),
                                       @"back_camera":@(rearCamBool),
                                       @"touch_test":@(screenTestBool),
                                       @"crack_screen":@(1),
                                       @"wifi":@(wifiBool),
                                       @"data_connection":@(dataConnectionBool),
                                       @"bluetooth":@(bluetoothBool),
                                       @"gps":@(gpsBool),
                                       @"battery":@(batteryBool),
                                       @"gyroscope":@(gyroBool),
                                       @"device_storage_capacity":@([self getFreeDiskspace]),
                                       @"device_current_battery":@(batLeft),
                                       @"phone_cost":deviceCost,
                                       @"month_year_of_purchase":[NSString stringWithFormat:@"%@/%@",month,year],
                                       @"device":@" ios",
                                       @"mute":@(muteBool),
                                       @"volume_decrease":@(volumeBool),
                                       @"imei":_strIMEI
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
    NSMutableURLRequest *request;
    
    NSData *backCamera = [[NSUserDefaults standardUserDefaults] objectForKey:@"backCameraImage"];
    NSData *crackScreen = [[NSUserDefaults standardUserDefaults] objectForKey:@"crackScreenImage"];
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    
    request=[serializer multipartFormRequestWithMethod:@"POST" URLString:@"https://admin.tecprotec.co/api/health_check" parameters:elementDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
             {
                 [formData appendPartWithFileData:backCamera
                                             name:@"back_camera_image"
                                         fileName:[NSString stringWithFormat:@"%@.jpg",@"back_camera_image"]
                                         mimeType:@"image/jpg"];
                 [formData appendPartWithFileData:crackScreen
                                             name:@"cracked_screen_image"
                                         fileName:[NSString stringWithFormat:@"%@.jpg",@"cracked_screen_image"]
                                         mimeType:@"image/jpg"];
                 
             } error:nil];
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress)
                  {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(),
                                     ^{
                                         //Update the progress view
                                         
                                     });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull responseObject, id  _Nullable response, NSError * _Nullable error) {
                      if (error) {
                          
                      } else
                      {
                          NSLog(@"%@ %@", response, responseObject);
                          NSString *status = [response objectForKey:@"status"];
                          if([status isEqualToString:@"success"])
                          {
                              [self ipayMethodTotal:elementDictionaryPolicy referenceNumber:policyId];
                          }
                          else
                          {
                              
                          }
                      }
                      [SVProgressHUD dismiss];
                  }];
    
    [uploadTask resume];
    
    
    
}

#pragma mark - iPay88 Delegates

-(void)ipayMethodTotal:(NSDictionary *)dicData referenceNumber:(NSString *)referenecNumber
{
    productId = referenecNumber;
    NSDictionary *dicProfile = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];
    
    //    NSString *strPrice = [dicData objectForKey:@"listprice"];
    //    NSString *priceFloat = [strPrice stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSString *priceFloat = @"10000";
    
    paymentSdk = [[Ipay alloc] init];
    paymentSdk.delegate = self;
    IpayPayment *payment = [[IpayPayment alloc] init];
    [payment setPaymentId:@"1"];
    [payment setMerchantKey:@"EEUHfRqVtF"];//rxun22nL6A
    [payment setMerchantCode:@"ID00564"];//ID00401
    [payment setRefNo:referenecNumber];
    [payment setAmount:priceFloat];
    [payment setCurrency:@"IDR"];
    [payment setProdDesc:[NSString stringWithFormat:@"This is policy id = %@",referenecNumber]];
    [payment setUserName:[dicProfile objectForKey:@"firstname"]];
    [payment setUserEmail:[dicProfile objectForKey:@"email"]];
    [payment setUserContact:[dicProfile objectForKey:@"mobile"]];
    [payment setRemark:@"Policy purchase"];
    [payment setLang:@"ISO-8859-1"];
    [payment setCountry:@"ID"];
    [payment setBackendPostURL:[NSString stringWithFormat:@"%@policypayment.php",BASEIMAGEURL]];
    _paymentView = [paymentSdk checkout:payment];
    [self.view addSubview:_paymentView];
}

- (void)paymentSuccess:(NSString *)refNo withTransId:(NSString *)transId withAmount:(NSString *)amount withRemark:(NSString *)remark withAuthCode:(NSString *)authCode
{
    NSLog(@"paymentSuccess remark = %@",remark);
    NSLog(@"paymentSuccess amount = %@",amount);
    NSLog(@"paymentSuccess transId = %@",transId);
    NSLog(@"paymentSuccess refno = %@",refNo);
    NSLog(@"paymentSuccess authenticationCode = %@",authCode);
    
    SuccessViewControllerLost *successViewControllerLost = [self.storyboard instantiateViewControllerWithIdentifier:@"SuccessViewControllerLost"];
    NSString *strText = NSLocalizedStringFromTableInBundle(@"Your payment is successfully completed reference number is", nil, [[Helper sharedInstance] getLocalBundle], nil);
    NSString *strSecond = NSLocalizedStringFromTableInBundle(@"Kindly upload your gadget proof of purchase for faster processing of claims in the future.", nil, [[Helper sharedInstance] getLocalBundle], nil);
    successViewControllerLost.successMessage = [NSString stringWithFormat:@"%@:%@, %@",strText,policyId,strSecond];
    successViewControllerLost.policyId = policyId;
    successViewControllerLost.success = YES;
    [self.navigationController pushViewController:successViewControllerLost animated:YES];
}

- (void)paymentFailed:(NSString *)refNo withTransId:(NSString *)transId withAmount:(NSString *)amount withRemark:(NSString *)remark withErrDesc:(NSString *)errDesc
{
    NSLog(@"paymentFailed remark = %@",remark);
    NSLog(@"paymentFailed amount = %@",amount);
    NSLog(@"paymentFailed transId = %@",transId);
    NSLog(@"paymentFailed refno = %@",refNo);
    NSLog(@"paymentFailed errDesc = %@",errDesc);
    [Helper popUpMessage:errDesc titleForPopUp:@"Error" view:[UIView new]];
    SuccessViewControllerLost *successViewControllerLost = [self.storyboard instantiateViewControllerWithIdentifier:@"SuccessViewControllerLost"];
    
    NSString *strText = NSLocalizedStringFromTableInBundle(@"Your payment was unsuccessful. Kindly try again or contact us at 0804-1401-078 for assistance", nil, [[Helper sharedInstance] getLocalBundle], nil);
    
    successViewControllerLost.successMessage = strText;
    successViewControllerLost.policyId = policyId;
    successViewControllerLost.success = NO;
    [self.navigationController pushViewController:successViewControllerLost animated:YES];
}

- (void)paymentCancelled:(NSString *)refNo withTransId:(NSString *)transId withAmount:(NSString *)amount withRemark:(NSString *)remark withErrDesc:(NSString *)errDesc
{
    NSLog(@"paymentCancelled remark = %@",remark);
    NSLog(@"paymentCancelled amount = %@",amount);
    NSLog(@"paymentCancelled transId = %@",transId);
    NSLog(@"paymentCancelled transId = %@",refNo);
    NSLog(@"paymentFailed errDesc = %@",errDesc);
    SuccessViewControllerLost *successViewControllerLost = [self.storyboard instantiateViewControllerWithIdentifier:@"SuccessViewControllerLost"];
    NSString *strText = NSLocalizedStringFromTableInBundle(@"Your payment was unsuccessful. Kindly try again or contact us at 0804-1401-078 for assistance", nil, [[Helper sharedInstance] getLocalBundle], nil);
    
    successViewControllerLost.successMessage = strText;
    successViewControllerLost.policyId = policyId;
    successViewControllerLost.success = NO;
    
    [self.navigationController pushViewController:successViewControllerLost animated:YES];
}

- (void)requerySuccess:(NSString *)refNo withMerchantCode:(NSString *)merchantCode withAmount:(NSString *)amount withResult:(NSString *)result
{
    NSLog(@"requerySuccess refNo = %@",refNo);
    NSLog(@"requerySuccess merchantCode = %@",merchantCode);
    NSLog(@"requerySuccess amount = %@",amount);
    NSLog(@"requerySuccess result = %@",result);
}

- (void)requeryFailed:(NSString *)refNo withMerchantCode:(NSString *)merchantCode withAmount:(NSString *)amount withErrDesc:(NSString *)errDesc
{
    NSLog(@"requeryFailed refNo = %@",refNo);
    NSLog(@"requeryFailed merchantCode = %@",merchantCode);
    NSLog(@"requeryFailed amount = %@",amount);
    NSLog(@"requeryFailed errDesc = %@",errDesc);
}

-(IBAction)ActionBtnDone:(id)sender
{
    if(selected&&two&&three)
    {
        [self purchasePolicy];
    }
    else
    {
        [Helper popUpMessage:NSLocalizedStringFromTableInBundle(@"Please agree to our conditions", nil, [[Helper sharedInstance] getLocalBundle], nil) titleForPopUp:@"" view:self.view];
    }
}

-(void)backAction:(id)sender
{
    NSString *strText = NSLocalizedStringFromTableInBundle(@"Do you want to cancel the purchase?", nil, [[Helper sharedInstance] getLocalBundle], nil);
    
    LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:@"" message:strText style:LGAlertViewStyleAlert buttonTitles:@[@"Yes",@"Cancel"] cancelButtonTitle:nil destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
        if([title isEqualToString:@"Yes"])
        {
            for (UIViewController *controller in self.navigationController.viewControllers)
            {
                if ([controller isKindOfClass:[PolicyDetailViewController class]])
                {
                    //Do not forget to import AnOldViewController.h
                    
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

-(void)ActionCheckbox:(id)sender
{
    BEMCheckBox *bemCheckBox = (BEMCheckBox *)sender;
    if(bemCheckBox.on)
    {
        selected = YES;
    }
    else
    {
        selected = NO;
    }
}

-(void)ActionCheckboxTwo:(id)sender
{
    BEMCheckBox *bemCheckBox = (BEMCheckBox *)sender;
    if(bemCheckBox.on)
    {
        two = YES;
    }
    else
    {
        two = NO;
    }
}

-(void)ActionCheckboxThree:(id)sender
{
    BEMCheckBox *bemCheckBox = (BEMCheckBox *)sender;
    if(bemCheckBox.on)
    {
        three = YES;
    }
    else
    {
        three = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

