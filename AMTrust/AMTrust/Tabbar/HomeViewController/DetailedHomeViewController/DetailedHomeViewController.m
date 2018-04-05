//
//  DetailedHomeViewController.m
//  TECPROTEC
//
//  Created by kishore kumar on 06/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "DetailedHomeViewController.h"

#define COLOR_CODE  [NSArray arrayWithObjects: @"#006ddc",@"#ff7024",@"#01ab86",nil]

@interface DetailedHomeViewController ()

@end

@implementation DetailedHomeViewController
@synthesize strDeviceId;
@synthesize strCurrencyId;
@synthesize isTablet;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Setting default value when loading the page
    
    isPurchaseDateEditable = YES;
    isGadgetPriceEditable = YES;
    selectedPlan = -1;
    
    arrPlanList = [[NSMutableArray alloc]init];
    arrColorList = [[NSMutableArray alloc] init];

    [self setupTableView];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackMore"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    backButton.tintColor = [Helper colorWithHexString:@"#FF304B"];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self colorCodeApi];
    
    if(_renew)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"RENEW"];

        if(_purchasePrice)
        {
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSString *removeComma = [_devicePurchaseCost stringByReplacingOccurrencesOfString:@"," withString:@""];
            NSNumber *myNumber = [formatter numberFromString:removeComma];
            costPrice = [myNumber intValue];
            NSString *formatted = [formatter stringFromNumber:myNumber];
            _devicePurchaseCost = formatted;
            phoneCost = formatted;
        }

        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy"];
        NSString *purchaseDate = [dateFormat stringFromDate:_devicePurchaseDate];
        phoneMonth = purchaseDate;
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"RENEW"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[Helper sharedInstance] trackingScreen:@"ProductList_IOS"];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [self updateLanguage];
    
    //Setting up the editablility of the gadget price and gadget purchase date
    
    if(_devicePurchaseDate == nil)
    {
        isPurchaseDateEditable = NO;
    }
    
    if(_devicePurchaseCost == nil || [_devicePurchaseCost isEqualToString:@""] || [_devicePurchaseCost isEqualToString:@"0"] || [_devicePurchaseCost isEqualToString:@"NA"]){
        isGadgetPriceEditable = YES;
    }else
    {
        isGadgetPriceEditable = NO;
    }
}

-(void)setupTableView
{
    [detailedTableView registerNib:[UINib nibWithNibName:@"DetailedTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DetailedTableViewCell"];
    [detailedTableView registerNib:[UINib nibWithNibName:@"BuyOptionTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BuyOptionTableViewCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (@available(iOS 11.0, *)) {
        detailedTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    detailedTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    detailedTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectZero];
}

-(void)updateLanguage
{
    [continueButton setTitle:NSLocalizedStringFromTableInBundle(@"Continue", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
    
    self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"Choose your plan", nil, [[Helper sharedInstance] getLocalBundle], nil);
}

-(void)colorCodeApi
{
    [SVProgressHUD showWithStatus:@"Loading.."];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://admin.tecprotec.co/api/plans" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *response = responseObject;
        NSLog(@"%@ %@", response, responseObject);
        [SVProgressHUD dismiss];
        
        arrColorList = [response objectForKey:@"plans"];
        [self productList:@"annual"];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        
        [Helper popUpMessage:error.localizedDescription titleForPopUp:@"Error" view:[UIView new]];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1)
    {
        return arrPlanList.count;
    }
   
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        BuyOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuyOptionTableViewCell"];
        if(!cell)
        {
            cell = [[BuyOptionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BuyOptionTableViewCell"];
        }
        
        cell.isTablet = isTablet;
        cell.costTextField.delegate = self;
        cell.dateTextField.delegate = self;
        
        [cell.costTextField addTarget:self
                              action:@selector(textFieldDidChange:)
                    forControlEvents:UIControlEventEditingChanged];
        cell.dateTextField.text = phoneMonth;
        
        UIDatePicker *datePicker = [[UIDatePicker alloc]init];
        [datePicker setDate:[NSDate date]];
        datePicker.datePickerMode = UIDatePickerModeDate;
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        
        if(isTablet){
            [comps setMonth:-12];
        }else{
            [comps setMonth:-17];
        }
        
        NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        datePicker.minimumDate = minDate;
        datePicker.maximumDate = [NSDate date];
        [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
        
        UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        [toolBar setTintColor:[UIColor grayColor]];
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(ShowSelectedDate:)];
        UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
        [cell.dateTextField setInputView:datePicker];
        [cell.dateTextField setInputAccessoryView:toolBar];
        [toolBar setTintColor:[UIColor grayColor]];
        
        UIToolbar *toolBarTwo=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        
        UIBarButtonItem *doneNext=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(ActionNext:)];
        [toolBarTwo setItems:[NSArray arrayWithObjects:space,doneNext, nil]];
        [cell.costTextField setInputAccessoryView:toolBarTwo];
        [toolBarTwo setTintColor:[UIColor grayColor]];

        cell.dateTextField.text = phoneMonth;
        cell.costTextField.text = phoneCost;
        
        cell.costTextField.userInteractionEnabled = isGadgetPriceEditable;
        cell.dateTextField.userInteractionEnabled = isGadgetPriceEditable;
        
        [cell updateContent];
        
        return cell;
    }
    else
    {
        DetailedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailedTableViewCell"];
        
        if(!cell)
        {
            cell = [[DetailedTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailedTableViewCell"];
        }
       
        [cell.checkBox setOn:NO];

        if(selectedPlan == indexPath.row)
        {
            [cell.checkBox setOn:YES];
        }
        
        NSDictionary *planDict = [arrPlanList objectAtIndex:indexPath.row];
        NSString *planName = [planDict objectForKey:@"productname"];

        [cell updateContent:planDict withTablet:isTablet withColorCode:[self getColorCode:planName] forIndexPath:indexPath];
        
        return cell;
    }
}

-(NSString *)getColorCode:(NSString *)planName
{
    NSString *colorCode;
    
    for (int i=0; i<arrColorList.count; i++) {
        
        NSDictionary *colorDict = [arrColorList objectAtIndex:i];
        NSString *colorPlanName = [colorDict objectForKey:@"name"];
        
        if([colorPlanName isEqualToString:planName])
        {
            colorCode = [colorDict objectForKey:@"colorCode"];
        }
    }
    
    return colorCode;
}

-(void)dateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)sender;
    [picker setMaximumDate:[NSDate date]];
    picker.datePickerMode = UIDatePickerModeDate;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    
    phoneMonth = dateString;
    _devicePurchaseDate = dateString;
}

-(IBAction)ActionNext:(id)sender
{
    [detailedTableView reloadData];
}

-(void)ShowSelectedDate:(id)sender
{
    if(phoneMonth.length==0)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy"];
        
        NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
        phoneMonth = dateString;
        _devicePurchaseDate = dateString;
    }
    [detailedTableView reloadData];
}

-(void) textFieldDidChange:(UITextField *)textField {
    
    NSString *value = textField.text;
    value = [value stringByReplacingOccurrencesOfString:@"," withString:@""];
    value = [value stringByReplacingOccurrencesOfString:@"." withString:@""];

    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *myNumber = [formatter numberFromString:value];
    NSString *formatted = [formatter stringFromNumber:myNumber];
    textField.text = formatted;
    
    phoneCost = textField.text;
    
    NSString *setValue = textField.text;
    setValue = [setValue stringByReplacingOccurrencesOfString:@"," withString:@""];
    setValue = [setValue stringByReplacingOccurrencesOfString:@"." withString:@""];

    costPrice = [setValue integerValue];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1)
    {
        selectedPlan = indexPath.row;
    }
    
    [tableView reloadData];
}

-(void)productList:(NSString *)type
{
    [SVProgressHUD showWithStatus:@"Loading.."];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableURLRequest *request;
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    NSString *apiLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"ApiCurrentLanguage"];
    
    NSDictionary *paramDictionary = @{@"operation":@"ams.product_list",
                                      @"sessionName":sessionName,
                                      @"deviceid":strDeviceId,
                                      @"rangeinput":@"1000000",
                                      @"language":apiLanguage,
                                      @"currency_id":strCurrencyId,
                                      @"type":type
                                      };
    
    request = [serializer requestWithMethod:@"POST" URLString:BASEURL parameters:paramDictionary error:nil];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    jsonResponseSerializer.acceptableContentTypes = nil;
    manager.responseSerializer = jsonResponseSerializer;
    
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
                          
                          NSLog(@"error = %@ reason = %@",error.localizedDescription,error.localizedFailureReason);
                          
                          
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
                                  arrPlanList = [[response objectForKey:@"result"] objectForKey:@"data"];
                                  if ([arrPlanList isKindOfClass:[NSArray class]] == YES)
                                  {
                                      if(arrPlanList.count!=0)
                                      {
                                          [detailedTableView reloadData];
                                      }
                                  }
                                  else
                                  {
                                      [Helper popUpMessage:[NSString stringWithFormat:@"%@",response] titleForPopUp:@"Array we received as string" view:[UIView new]];
                                      continueButton.hidden = YES;
                                  }
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

- (IBAction)continueAction:(id)sender {
    
    if([phoneCost isEqualToString:@""] || phoneCost.length==00)
    {
        [Helper popUpMessage:NSLocalizedStringFromTableInBundle(@"Please enter your gadget cost", nil, [[Helper sharedInstance] getLocalBundle], nil) titleForPopUp:@"" view:self.view];
    }
    else if (costPrice < 1000000)
    {
        [Helper popUpMessage:NSLocalizedStringFromTableInBundle(@"Minimum gadget cost should be Rp 1,000,000", nil, [[Helper sharedInstance] getLocalBundle], nil) titleForPopUp:@"" view:self.view];
    }
    else if (costPrice > 20000000)
    {
        [Helper popUpMessage:NSLocalizedStringFromTableInBundle(@"Maximum gadget cost should be Rp 20,000,000", nil, [[Helper sharedInstance] getLocalBundle], nil) titleForPopUp:@"" view:self.view];
    }
    
    else if (selectedPlan == -1)
    {
        [Helper popUpMessage:NSLocalizedStringFromTableInBundle(@"Please select your plan", nil, [[Helper sharedInstance] getLocalBundle], nil) titleForPopUp:@"" view:self.view];
    }
    else if ([phoneMonth isEqualToString:@""]||phoneMonth.length==0)
    {
        [Helper popUpMessage:NSLocalizedStringFromTableInBundle(@"Please enter date of gadget purchase", nil, [[Helper sharedInstance] getLocalBundle], nil) titleForPopUp:@"" view:self.view];
    }
    else
    {
        PolicyDetailViewController *policyDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PolicyDetailViewController"];
        
        NSDictionary *dict = [arrPlanList objectAtIndex:selectedPlan];
        
        policyDetailViewController.dicProductDetails = dict;
        policyDetailViewController.rangeInput = phoneCost;
        NSString *listprice = [dict objectForKey:@"price_inc_vat"];
        
        policyDetailViewController.productId = [dict objectForKey:@"productid"];//selectedNumber
        NSString *productName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"productname"]];
        
        NSString *colorCode;
        
        for (int i=0; i<arrColorList.count; i++) {
            
            NSString *productNameMobello = [NSString stringWithFormat:@"%@",[[arrColorList objectAtIndex:i] objectForKey:@"name"]];
            
            if([productNameMobello isEqualToString:productName])
            {
                colorCode = [[arrColorList objectAtIndex:i] objectForKey:@"colorCode"];
            }
        }
        
        policyDetailViewController.backgroundColor = colorCode;
        policyDetailViewController.isTablet = isTablet;
        
        if(!isTablet)
        {
            if ([productName isEqualToString:@"proCLASSIC"])
            {
                policyDetailViewController.img = [UIImage imageNamed:@"popular_plan"];
            }else if ([productName isEqualToString:@"proVALUE"])
            {
                policyDetailViewController.img = [UIImage imageNamed:@"basic_plan"];
            }else
            {
                policyDetailViewController.img = [UIImage imageNamed:@"Device"];
            }
        }else
        {
            if ([productName isEqualToString:@"proCLASSIC"])
            {
                policyDetailViewController.img = [UIImage imageNamed:@"broken2"];
            }else if ([productName isEqualToString:@"proVALUE"])
            {
                policyDetailViewController.img = [UIImage imageNamed:@"water2"];
            }else
            {
                policyDetailViewController.img = [UIImage imageNamed:@"ProPremiumTab"];
            }
            
        }
        policyDetailViewController.currencyCode = [NSString stringWithFormat:@"%@",[[arrPlanList objectAtIndex:selectedPlan] objectForKey:@"currency_symbol"]];
        
        [self.navigationController pushViewController:policyDetailViewController animated:YES];
        
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"productid"] forKey:@"productid"];
        [[NSUserDefaults standardUserDefaults] setObject:listprice forKey:@"listPrice"];
        [[NSUserDefaults standardUserDefaults] setObject:phoneCost forKey:@"userDeviceCost"];
        [[NSUserDefaults standardUserDefaults] setObject:phoneMonth forKey:@"month"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

-(NSString *)formatPrice:(NSString *)actualValue
{
    return @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
