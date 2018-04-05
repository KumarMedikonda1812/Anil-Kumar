//
//  PlanDetailViewController.m
//  TECPROTEC
//
//  Created by Sethu on 23/2/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import "PlanDetailViewController.h"

@interface PlanDetailViewController ()

@end

@implementation PlanDetailViewController
@synthesize categoryArray;
@synthesize policyID;
@synthesize deviceCategory;
@synthesize paymentSdk;
@synthesize myPlanArray;

- (void)viewDidLoad {
    [super viewDidLoad];

    commonRequest = [CommonRequest sharedInstance];
    commonRequest.delegate = self;

    orderArray = @[@"Subscriber",@"Plan",@"Category",@"Status",@"Gadget price",@"Purchased on",@"Expires on"];
    buttonArray = [[NSMutableArray alloc] init];

    planTableView.delegate = self;
    planTableView.dataSource = self;
    planTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [planTableView registerNib:[UINib nibWithNibName:@"PlanRequirementCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PlanRequirementCell"];
    [planTableView registerNib:[UINib nibWithNibName:@"PlanButtonTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PlanButtonTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupNavigation];
    
    [buttonArray removeAllObjects];
    
    [commonRequest getPlanDetails:policyID];
}

- (void)setupNavigation{
    self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"Protection details", nil, [[Helper sharedInstance] getLocalBundle], nil);

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackMore"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    backButton.tintColor = [Helper colorWithHexString:@"#FF304B"];
    self.navigationItem.leftBarButtonItem = backButton;
}

#pragma mark - CommonRequest Delegate

- (void)commonRequestGetResponse:(NSDictionary *)response withAPIName:(NSString *)name{
    
    if([name isEqualToString:@"getPlanDetails"])
    {
        BOOL success = [[response objectForKey:@"success"] boolValue];
        
        if(success == YES)
        {
            NSDictionary *resultDict = [response objectForKey:@"result"];
            NSString *status = [resultDict objectForKey:@"status"];
            
            if([status isEqualToString:@"success"])
            {
                NSDictionary *data = [resultDict objectForKey:@"data"];
                planModel = [[PlanModel alloc] init];
                [planModel updateModelWithDictionary:data];
                
                [commonRequest getPlanUploadStatus:policyID];
            }
        }
    }else if([name isEqualToString:@"getPlanUploadStatus"])
    {
        NSLog(@"response = %@",response);
        
        BOOL success = [[response objectForKey:@"success"] boolValue];
        
        if(success == YES)
        {
            NSArray *dataArray = [[response objectForKey:@"result"] objectForKey:@"data"];
            
            for (NSDictionary * name in dataArray ) {
                
                NSString *status = [name objectForKey:@"status"];
                NSString *title = [name objectForKey:@"title"];
                
                if([status isEqualToString:@"Open"])
                {
                    status =  NSLocalizedStringFromTableInBundle(@"Verification Pending", nil, [[Helper sharedInstance] getLocalBundle], nil);
                }
                
                if([title isEqualToString:@"SalesOrder"])
                {
                    planModel.receiptUploadStatus = status;
                }else if([title isEqualToString:@"Crack Screen"])
                {
                    planModel.crackScreenStatus = status;
                }
            }
            
            [planModel checkRenewPlan:myPlanArray];
            [planModel checkCancel];
            [planModel checkPayNow];
            [planModel checkSubmitClaim];

            [buttonArray removeAllObjects];
            
            BOOL policyLiveTemp = [self isPolicyLive];
            
            if(!planModel.showRenewButton && policyLiveTemp){
                [buttonArray addObject:@"Renew Policy"];
            }
            
            if(planModel.showPayNowButton){
                [buttonArray addObject:@"Pay Now"];
            }
            
            if(planModel.showClaimButton){
                [buttonArray addObject:@"Submit a claim"];
            }
            
            if(planModel.showCancelButton){
                [buttonArray addObject:@"Cancel"];
            }
            
            [planTableView reloadData];
        }
    }else if([name isEqualToString:@"cancelPolicy"])
    {
        BOOL success = [[response objectForKey:@"success"] boolValue];
        
        if(success == YES)
        {
            NSString *status = [[response objectForKey:@"result"] objectForKey:@"status"];
            
            if([status isEqualToString:@"failure"]||[status isEqualToString:@"failed"])
            {
                NSString *message = [[response objectForKey:@"result"] objectForKey:@"message"];
                [Helper popUpMessage:message titleForPopUp:@"Error" view:[UIView new]];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }else if([name isEqualToString:@"getDeviceCategories"])
    {
        BOOL success = [[response objectForKey:@"success"] boolValue];
        
        if(success == YES)
        {
            NSString *status = [[response objectForKey:@"result"] objectForKey:@"status"];
            
            if([status isEqualToString:@"failure"]||[status isEqualToString:@"failed"])
            {
                [Helper popUpMessage:[[response objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"Alert" view:[UIView new]];
            }else
            {
                deviceCategoryArray = [[response objectForKey:@"result"] objectForKey:@"result"];

                if(planModel.purchasedOn == nil)
                {
                    [Helper popUpMessage:@"Missing date of purchase. Please contact tecprotec support for renewing this policy." titleForPopUp:@"Missing Fields" view:self.view];
                }else
                {
                    NSDictionary *categoryDictionary = [self getDeviceCategoryDict:planModel.category];

                    if(categoryDictionary == nil)
                    {
                        [self showCategoryAlert:deviceCategoryArray];
                    }else
                    {
                        [self redirectToDetailsView:categoryDictionary];
                    }
                }
            }
        }
    }
}

- (void)showCategoryAlert:(NSArray *)deviceCategoryArray
{
    NSMutableArray *buttonArray = [[NSMutableArray alloc] init];

    for(NSDictionary *dict in deviceCategoryArray)
    {
        NSString *category = [dict objectForKey:@"device_category"];
        [buttonArray addObject:category];
    }
    
    NSString *titleStr = NSLocalizedStringFromTableInBundle(@"Choose your plan", nil, [[Helper sharedInstance] getLocalBundle], nil);
    
    LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:titleStr message:@"" style:LGAlertViewStyleAlert buttonTitles:buttonArray cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
        
        NSDictionary *categoryDictionary = [self getDeviceCategoryDict:title];
        [self redirectToDetailsView:categoryDictionary];
        
    } cancelHandler:^(LGAlertView * _Nonnull alertView) {
        
    } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
        
    }];
    alertView.oneRowOneButton = YES;
    alertView.tintColor = THEMECOLOR;
    [alertView show];
}

-(NSDictionary *)getDeviceCategoryDict:(NSString *)categoryName
{
    NSDictionary *categoryDictionary;
    
    for(NSDictionary *dict in deviceCategoryArray)
    {
        NSString *category = [dict objectForKey:@"device_category"];
        
        if([category isEqualToString:categoryName])
        {
            categoryDictionary = dict;
            break;
        }else if([category isEqualToString:@"Ponsel"] && [categoryName isEqualToString:@"Smartphone"])
        {
            categoryDictionary = dict;
            break;
        }
    }
    
    return categoryDictionary;
}

-(void)redirectToDetailsView:(NSDictionary *)dict
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DetailedHomeViewController *detailedHomeViewController = [storyboard instantiateViewControllerWithIdentifier:@"DetailedHomeViewController"];
    detailedHomeViewController.hidesBottomBarWhenPushed = YES;
    detailedHomeViewController.purchaseDate = YES;
    detailedHomeViewController.purchasePrice = planModel.gadgetPrice;
    detailedHomeViewController.renew = YES;
    
    NSString *category = [dict objectForKey:@"device_category"];
    
    if([category isEqualToString:@"Tablet"])
    {
        detailedHomeViewController.isTablet = YES;
    }else{
        detailedHomeViewController.isTablet = NO;
    }
    
    detailedHomeViewController.strDeviceId = [dict objectForKey:@"deviceid"];
    detailedHomeViewController.strCurrencyId = [dict objectForKey:@"currency_id"];
    detailedHomeViewController.devicePurchaseCost = planModel.gadgetPrice;
    detailedHomeViewController.devicePurchaseDate = planModel.gadgetPurchasedOn;
    
    [self.navigationController pushViewController:detailedHomeViewController animated:YES];
}

- (BOOL)isPolicyLive
{
    BOOL isPolicyLive = NO;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *remainingDays = [gregorianCalendar components:NSCalendarUnitDay
                                                           fromDate:[NSDate date]
                                                             toDate:planModel.purchasedOn
                                                            options:0];
    
    NSInteger remainDays = [remainingDays day];
    
    if(remainDays <= 0)
    {
        isPolicyLive = YES;
    }
    
    return isPolicyLive;
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0)
    {
        return orderArray.count;
    }else if(section == 1)
    {
        if([deviceCategory isEqualToString:@"Tablet"])
        {
            return 1;
        }else{
            return 2;
        }
    }else
    {
        return buttonArray.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MyIdentifier"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.textLabel.font = [UIFont systemFontOfSize:12.0f weight:UIFontWeightRegular];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f weight:UIFontWeightRegular];
        
        NSString *item = [orderArray objectAtIndex:indexPath.row];
        cell.textLabel.text = NSLocalizedStringFromTableInBundle(item, nil, [[Helper sharedInstance] getLocalBundle], nil);
        
        if([item isEqualToString:@"Subscriber"])
        {
            NSDictionary *profileDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];
            NSString *firstName = [profileDictionary objectForKey:@"firstname"];
            NSString *lastName = [profileDictionary objectForKey:@"lastname"];

            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",firstName,lastName];

        }else if([item isEqualToString:@"Category"])
        {
            cell.detailTextLabel.text = deviceCategory;
        }else if([item isEqualToString:@"Plan"])
        {
            cell.detailTextLabel.text = planModel.plan;
        }else if([item isEqualToString:@"Status"])
        {
            if(![self isPolicyLive] && [planModel.status isEqualToString:@"POLICY-Current"])
            {
                cell.detailTextLabel.text = @"POLICY-Renewal";
            }else
            {
                cell.detailTextLabel.text = planModel.status;
            }
            
        }else if([item isEqualToString:@"Gadget price"])
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Rp %@",planModel.gadgetPrice];
        }else if([item isEqualToString:@"Purchased on"])
        {
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
            [dateformatter setDateFormat:@"dd MMMM yyyy"];

            cell.detailTextLabel.text =[dateformatter stringFromDate:planModel.purchasedOn];
        }else if([item isEqualToString:@"Expires on"])
        {
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
            [dateformatter setDateFormat:@"dd MMMM yyyy"];

            cell.detailTextLabel.text = [dateformatter stringFromDate:planModel.expiresOn];
        }
        
        return cell;

    }else if(indexPath.section == 1)
    {
        PlanRequirementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanRequirementCell"];
        
        if(!cell)
        {
            cell = [[PlanRequirementCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlanRequirementCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if(indexPath.row == 0)
        {
            cell.leftLabel.text = NSLocalizedStringFromTableInBundle(@"Official Receipt", nil, [[Helper sharedInstance] getLocalBundle], nil);
            cell.statusLabel.text = planModel.receiptUploadStatus;
            
            if([planModel.receiptUploadStatus isEqualToString:@"Reject"] || [planModel.receiptUploadStatus isEqualToString:@"Retake"] || [planModel.receiptUploadStatus isEqualToString:@"Not Uploaded"] )
            {
                cell.uploadButton.hidden = NO;
            }else
            {
                cell.uploadButton.hidden = YES;
            }
            
            [cell.uploadButton addTarget:self action:@selector(fileUploadAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if(indexPath.row == 1)
        {
            cell.leftLabel.text = NSLocalizedStringFromTableInBundle(@"Cracked Screen", nil, [[Helper sharedInstance] getLocalBundle], nil);
            cell.statusLabel.text = planModel.crackScreenStatus;

            if([planModel.crackScreenStatus isEqualToString:@"Reject"] || [planModel.crackScreenStatus isEqualToString:@"Retake"] || [planModel.crackScreenStatus isEqualToString:@"Not Uploaded"])
            {
                cell.uploadButton.hidden = NO;
            }else
            {
                cell.uploadButton.hidden = YES;
            }
            
            [cell.uploadButton addTarget:self action:@selector(crackedScreenUploadAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cell;
    }else
    {
        PlanButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanButtonTableViewCell"];
        
        if(!cell)
        {
            cell = [[PlanButtonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlanButtonTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        NSString *buttonText = [buttonArray objectAtIndex:indexPath.row];
        
        if([buttonText isEqualToString:@"Cancel"])
        {
            [cell.actionButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        }else if([buttonText isEqualToString:@"Pay Now"])
        {
            [cell.actionButton addTarget:self action:@selector(payNowAction:) forControlEvents:UIControlEventTouchUpInside];
        }else if([buttonText isEqualToString:@"Submit a claim"])
        {
            [cell.actionButton addTarget:self action:@selector(claimAction:) forControlEvents:UIControlEventTouchUpInside];
        }else if([buttonText isEqualToString:@"Renew Policy"])
        {
            [cell.actionButton addTarget:self action:@selector(renewPlan:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [cell.actionButton setTitle:[buttonArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 30.0f;
    }
    
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40.0f)];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width, headerView.frame.size.height)];
    if(section == 0)
    {
        headerLabel.text = @"About Plan";
    }else if(section == 1)
    {
        headerLabel.text = @"Plan Requirements";
    }else if(section == 2)
    {
        headerLabel.text = @"Plan Action";
    }

    headerLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    
    [headerView addSubview:headerLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 2)
    {
        if([buttonArray count] == 0)
        {
            return 0.0f;
        }
    }
    
    return 40.0f;
}

#pragma mark - Button Actions

- (IBAction)cancelAction:(id)sender{
    NSString *strTitle = NSLocalizedStringFromTableInBundle(@"Do you want to cancel your plan?", nil, [[Helper sharedInstance] getLocalBundle], nil);
    NSString *btnOne = NSLocalizedStringFromTableInBundle(@"Yes cancel my plan", nil, [[Helper sharedInstance] getLocalBundle], nil);
    NSString *btnTwo = NSLocalizedStringFromTableInBundle(@"Don't cancel my plan", nil, [[Helper sharedInstance] getLocalBundle], nil);
    
    LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:strTitle message:@"" style:LGAlertViewStyleAlert buttonTitles:@[btnOne,btnTwo] cancelButtonTitle:nil destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
        
        if([title isEqualToString:@"Yes cancel my plan"]||[title isEqualToString:@"Ya. Batalkan proteksi saya."])
        {
            [commonRequest cancelPolicy:policyID];
        }
        
    } cancelHandler:^(LGAlertView * _Nonnull alertView) {
        
    } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
        
    }];
    
    alertView.tintColor = THEMECOLOR;
    
    [alertView show];
}

- (IBAction)payNowAction:(id)sender{
    NSDictionary *profileDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];
    
    NSString *firstName = [profileDictionary objectForKey:@"firstname"];
    NSString *email = [profileDictionary objectForKey:@"email"];
    NSString *mobile = [profileDictionary objectForKey:@"mobile"];

    double price = [planModel.subTotal doubleValue];
    NSNumber *myDoubleNumber = [NSNumber numberWithDouble:price];
    NSString *priceFloat = [myDoubleNumber stringValue];
    NSString *priceFloatWithZero = [NSString stringWithFormat:@"%@.00",priceFloat];
   
    NSString *prodDesc = [NSString stringWithFormat:@"Policy ID %@",policyID];
    
    paymentSdk = [[Ipay alloc] init];
    paymentSdk.delegate = self;
    IpayPayment *payment = [[IpayPayment alloc] init];
    [payment setPaymentId:@"1"];
    [payment setMerchantKey:@"EEUHfRqVtF"];//rxun22nL6A
    [payment setMerchantCode:@"ID00564"];//ID00401
    [payment setRefNo:policyID];
    [payment setAmount:priceFloatWithZero];
    [payment setCurrency:@"IDR"];
    [payment setProdDesc:prodDesc];
    [payment setUserName:firstName];
    [payment setUserEmail:email];
    [payment setUserContact:mobile];
    [payment setRemark:@"Policy purchase"];
    [payment setLang:@"ISO-8859-1"];
    [payment setCountry:@"ID"];
    
    [payment setBackendPostURL:[NSString stringWithFormat:@"%@/policypayment.php",BASEIMAGEURL]];
    _paymentView = [paymentSdk checkout:payment];
    [self.view addSubview:_paymentView];
}

- (IBAction)claimAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    NSDictionary *profileDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];

    WebViewController *webViewController = [storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webViewController.strImei = planModel.imei;
    webViewController.strPhonenumber = [profileDictionary objectForKey:@"mobile"];
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (IBAction)renewPlan:(id)sender
{
    [commonRequest getDeviceCategories];
}
    
-(IBAction)crackedScreenUploadAction:(id)sender
{
    invoiceReceipt = NO;

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    [imagePicker setDelegate:self];
    imagePicker.allowsEditing = NO;
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)fileUploadAction:(id)sender {
    
    NSString *strText = NSLocalizedStringFromTableInBundle(@"Take photo", nil, [[Helper sharedInstance] getLocalBundle], nil);
    
    NSString *strTitle = NSLocalizedStringFromTableInBundle(@"Upload Invoice Receipt", nil, [[Helper sharedInstance] getLocalBundle], nil);
    
    NSString *photoString = NSLocalizedStringFromTableInBundle(@"Choose from photo library", nil, [[Helper sharedInstance] getLocalBundle], nil);
    
    LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:@"" message:strTitle style:LGAlertViewStyleAlert buttonTitles:@[strText,photoString] cancelButtonTitle:@"Upload later" destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
        
        if([title isEqualToString:@"Choose from photo library"] || [title isEqualToString:@"Pilih dari galeri foto"])
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imagePicker setDelegate:self];
            [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
        }else{
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            [imagePicker setDelegate:self];
            imagePicker.allowsEditing = NO;
            [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
        }
        invoiceReceipt = YES;
    
    } cancelHandler:^(LGAlertView * _Nonnull alertView) {
        
    } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
        
    }];
    
    alertView.tintColor = THEMECOLOR;
    
    [alertView show];
}

#pragma mark - Cracked Screen Upload
    
-(void)createCrackedScreenServiceRequest
{
    [SVProgressHUD showWithStatus:@"uploading.."];
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    
    NSString *assignedUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"result"] objectForKey:@"userId"];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"profile"]);
    NSString *customerID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"profile"] objectForKey:@"customerid"];
    
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
                                       @"policyid":policyID
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
                [self crackedScreenDocumentRequest:[[json objectForKey:@"result"] objectForKey:@"serviceid"]];
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

-(void)crackedScreenDocumentRequest:(NSString *)serviceid
    {
        
        [SVProgressHUD showWithStatus:@"60% Completed"];
        NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
        NSString *assignedUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"result"] objectForKey:@"userId"];
        
        NSDictionary *elementDictionary =@{@"notes_title":@"Note documents",
                                           @"record_id":serviceid,
                                           @"notecontent":@"note content",
                                           @"policy_id":policyID,
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
        
        NSData *crackScreen = UIImageJPEGRepresentation(imgScreen, 1);
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
                                      [commonRequest getPlanUploadStatus:policyID];
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

#pragma mark - Receipt Upload

-(void)createReceiptUploadServiceRequest
{
    [SVProgressHUD showWithStatus:@"uploading.."];
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    
    NSString *assignedUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"result"] objectForKey:@"userId"];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"profile"]);
    NSString *customerID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"profile"] objectForKey:@"customerid"];
    
    NSDictionary *elementDictionary =@{@"title":@"SalesOrder",
                                       @"contact_id":customerID,
                                       @"parent_id":@"0",
                                       @"priority":@"Low",
                                       @"product_id":@"0",
                                       @"severity":@"Low",
                                       @"status":@"Open",
                                       @"category":@"category",
                                       @"hours":@"21.05",
                                       @"days":@"2",
                                       @"description":@"Receipt Upload",
                                       @"solution":@"solution of ticket",
                                       @"policyid":policyID
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
    [SVProgressHUD showWithStatus:@"creating document.."];
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    NSString *assignedUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"result"] objectForKey:@"userId"];
    
    NSDictionary *elementDictionary =@{@"notes_title":@"Invoice upload",
                                       @"record_id":serviceid,
                                       @"notecontent":@"note content",
                                       @"policy_id":policyID,
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
    
    NSData *crackScreen = UIImageJPEGRepresentation(imgScreen, 1);
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    if(crackScreen)
    {
        request=[serializer multipartFormRequestWithMethod:@"POST" URLString:BASEURL parameters:paramDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                 {
                     if(crackScreen)
                     {
                         [formData appendPartWithFileData:crackScreen
                                                     name:@"document"
                                                 fileName:@"invoice_retake_image.jpg"
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
                          [SVProgressHUD dismiss];

                          NSLog(@"%@", response);
                         
                          BOOL success=[[response objectForKey:@"success"] boolValue];
                          
                          if(success)
                          {
                              NSString *status=[[response objectForKey:@"result"] objectForKey:@"status"];
                              
                              if([status isEqualToString:@"success"])
                              {
                                  [commonRequest getPlanUploadStatus:policyID];
                              }
                              else
                              {
                                  [Helper popUpMessage:[[response objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"Alert" view:[UIView new]];
                              }
                          }
                      }
                  }];
    
    [uploadTask resume];
}

#pragma mark - Image Picker View

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    imgScreen = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if(invoiceReceipt)
    {
        [self createReceiptUploadServiceRequest];
    }else
    {
        [self createCrackedScreenServiceRequest];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - iPay88 Delegate

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
    successViewControllerLost.successMessage = [NSString stringWithFormat:@"%@:%@, %@",strText,policyID,strSecond];
    successViewControllerLost.policyId = policyID;
    successViewControllerLost.success = YES;
    [self presentViewController:successViewControllerLost animated:YES completion:nil];
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
    NSString*strTesxt = @"Your payment was unsuccessful. Kindly try again or contact us at 0804-1401-078 for assistance";
    successViewControllerLost.successMessage = strTesxt;
    successViewControllerLost.policyId = policyID;
    successViewControllerLost.success = NO;
    [self presentViewController:successViewControllerLost animated:YES completion:nil];    
}

- (void)paymentCancelled:(NSString *)refNo withTransId:(NSString *)transId withAmount:(NSString *)amount withRemark:(NSString *)remark withErrDesc:(NSString *)errDesc
{
    NSLog(@"paymentCancelled remark = %@",remark);
    NSLog(@"paymentCancelled amount = %@",amount);
    NSLog(@"paymentCancelled transId = %@",transId);
    NSLog(@"paymentCancelled refno = %@",refNo);
    NSLog(@"paymentFailed errDesc = %@",errDesc);

    [_paymentView removeFromSuperview];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
