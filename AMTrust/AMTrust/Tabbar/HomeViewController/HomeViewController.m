//
//  HomeViewController.m
//  AMTrust
//
//  Created by kishore kumar on 23/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"TECPROTEC";
    
    homeTableView.delegate = self;
    homeTableView.dataSource = self;
    homeTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    deviceCategoryArray = [[NSMutableArray alloc] init];
    arrPlans = [[NSMutableArray alloc] init];
    
    [self setupNIB];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[Helper sharedInstance] trackingScreen:@"Home_screen_IOS"];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    checkForScroll = NO;
    
    CommonRequest *commonRequest = [CommonRequest sharedInstance];
    commonRequest.delegate = self;

    [commonRequest getDeviceCategories];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    checkForScroll = YES;
}

-(void)setupNIB
{
    [homeTableView registerNib:[UINib nibWithNibName:@"ScrollTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ScrollTableViewCell"];
    
    [homeTableView registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MenuTableViewCell"];
    
    [homeTableView registerNib:[UINib nibWithNibName:@"MenuSecondTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MenuSecondTableViewCell"];
    
    [homeTableView registerNib:[UINib nibWithNibName:@"PlansTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PlansTableViewCell"];
    
    [homeTableView registerNib:[UINib nibWithNibName:@"TipsForYouTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TipsForYouTableViewCell"];
}

- (IBAction)renewAction:(id)sender
{
    UIButton *renewButton = (UIButton *)sender;
    NSInteger tag = renewButton.tag;
    
    NSDictionary *dict = [arrPlans objectAtIndex:tag];
    
    NSString *deviceCategory = [dict objectForKey:@"device_category"];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *purchasedOn = [dateFormatter dateFromString:[dict objectForKey:@"cf_2493"]];

    if(purchasedOn == nil)
    {
        [Helper popUpMessage:@"Missing date of purchase. Please contact tecprotec support for renewing this policy." titleForPopUp:@"Missing Fields" view:self.view];
    }else
    {
        NSDictionary *categoryDictionary = [self getDeviceCategoryDict:deviceCategory];
        
        if(categoryDictionary == nil)
        {
            [self showCategoryAlert:deviceCategoryArray withMyPlan:dict];
        }else
        {
            [self redirectToDetailsView:categoryDictionary withMyPlan:dict];
        }
    }
}

-(void)returnTipsDetail:(NSUInteger)number
{
    TipsDetailsViewController *tipsDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TipsDetailsViewController"];
    tipsDetailsViewController.strId = [[arrTipsData objectAtIndex:number] objectForKey:@"id"];
    tipsDetailsViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tipsDetailsViewController animated:YES];
}

#pragma mark - UITableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return 1;
    }else if(section==1){
        if(arrPlans.count > 2)
            return 2;
        
        return arrPlans.count;
    }else if(section==2){
        if(arrTipsData.count == 0)
            return CGFLOAT_MIN;
        
        return 1;
    }else{
        NSMutableArray *categoryArray = [self processDeviceCategoryForSmartphone];
        return categoryArray.count;
    }
}

-(BOOL)checkForSmartphonePolicy
{
    if(arrPlans.count > 0)
    {
        for(int i=0;i<[arrPlans count];i++)
        {
            NSDictionary *dict = [arrPlans objectAtIndex:i];
            
            NSString *policyStatus = [dict objectForKey:@"cf_1965"];
            
            if([policyStatus isEqualToString:@"POLICY-Current"])
            {
                return YES;
            }
        }
    }
    
    return NO;
}

-(NSMutableArray *)processDeviceCategoryForSmartphone{
    
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    
    if([self checkForSmartphonePolicy])
    {
        for (int i=0;i<[deviceCategoryArray count];i++)
        {
            NSDictionary *dict = [deviceCategoryArray objectAtIndex:i];
            
            NSString *categoryName = [dict objectForKey:@"device_category"];
            
            if([categoryName isEqualToString:@"Smartphone"] || [categoryName isEqualToString:@"Ponsel"])
            {
                continue;
            }else
            {
                [categoryArray addObject:dict];
            }
        }
    }else
    {
        [categoryArray addObjectsFromArray:deviceCategoryArray];
    }
    
    return categoryArray;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        ScrollTableViewCell *scrollTableView = [tableView dequeueReusableCellWithIdentifier:@"ScrollTableViewCell"];
        
        if(!scrollTableView)
        {
            scrollTableView = [[ScrollTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ScrollTableViewCell"];
        }
        [scrollTableView createImageScroll];
        
        return scrollTableView;
    }
    else if (indexPath.section==1)
    {
        PlansTableViewCell *plansTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"PlansTableViewCell"];
        if(!plansTableViewCell)
        {
            plansTableViewCell = [[PlansTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlansTableViewCell"];
        }
        
        NSDictionary *dict = [arrPlans objectAtIndex:indexPath.row];
        
        [plansTableViewCell updateContent:dict withContentArray:arrPlans];
        
        plansTableViewCell.renewButton.tag = indexPath.row;
        [plansTableViewCell.renewButton addTarget:self action:@selector(renewAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return plansTableViewCell;
    }
    else if (indexPath.section==2)
    {
        TipsForYouTableViewCell * tipsForYouTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"TipsForYouTableViewCell"];
        if(!tipsForYouTableViewCell)
        {
            tipsForYouTableViewCell = [[TipsForYouTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TipsForYouTableViewCell"];
        }

        tipsForYouTableViewCell.arrTips = arrTipsData;

        tipsForYouTableViewCell.delegate = self;
        return tipsForYouTableViewCell;
    }
    else
    {
        NSMutableArray *categoryArray = [self processDeviceCategoryForSmartphone];

        NSDictionary *dict = [categoryArray objectAtIndex:indexPath.row];
        
        NSString *categoryName = [dict objectForKey:@"device_category"];
        
        if([categoryName isEqualToString:@"Smartphone"]||[categoryName isEqualToString:@"Ponsel"])
        {
            MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCell"];
            
            if(!cell)
            {
                cell = [[MenuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuTableViewCell"];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell updateContent:dict];
            
            return cell;
        }
        else
        {
            MenuSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuSecondTableViewCell"];
            
            if(!cell)
            {
                cell = [[MenuSecondTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuSecondTableViewCell"];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell updateContent:dict];
            
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 3)
    {
        NSMutableArray *categoryArray = [self processDeviceCategoryForSmartphone];

        NSDictionary *deviceCategoryDict = [categoryArray objectAtIndex:indexPath.row];
        
        NSString *deviceCategory = [deviceCategoryDict objectForKey:@"device_category"];
        
        DetailedHomeViewController *detailedHomeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailedHomeViewController"];
        detailedHomeViewController.hidesBottomBarWhenPushed = YES;
        detailedHomeViewController.strDeviceId = [deviceCategoryDict objectForKey:@"deviceid"];
        detailedHomeViewController.strCurrencyId = [deviceCategoryDict objectForKey:@"currency_id"];
        
        if([deviceCategory isEqualToString:@"Tablet"])
        {
            detailedHomeViewController.isTablet = YES;
        }else
        {
            detailedHomeViewController.isTablet = NO;
        }
        
        [self.navigationController pushViewController:detailedHomeViewController animated:YES];
    }
    else if (indexPath.section == 1)
    {
        NSDictionary *dict = [arrPlans objectAtIndex:indexPath.row];
        
        PlanDetailViewController *detailViewController = [[PlanDetailViewController alloc] initWithNibName:@"PlanDetailViewController" bundle:nil];
        detailViewController.deviceCategory = [dict objectForKey:@"device_category"];
        detailViewController.policyID = [dict objectForKey:@"policyid"];
        detailViewController.myPlanArray = arrPlans;
        
        detailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.clipsToBounds = YES;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.clipsToBounds = YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight = screenRect.size.height;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
            if (screenSize.height == 812.0f)
                NSLog(@"iPhone X");
            screenHeight = screenRect.size.height*0.3;
        }
        else
        {
            screenHeight = screenRect.size.height*0.37;
        }
        
        return screenHeight;
    }
    else if (indexPath.section==1)
    {
        return 140;
    }
    else if (indexPath.section==2)
    {
        return 200;
    }
    else
    {
        return 150;
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==1)
    {
        if(arrPlans.count==0)
            return CGFLOAT_MIN;
        else
            return 45;
    }
    else if (section==0)
    {
        return CGFLOAT_MIN;
    }
    else if (section==2)
    {
        if(arrTipsData.count==0)
            return CGFLOAT_MIN;
        else
            return 45;
        
    }
    else if (section==3)
        return 45;
    else
        return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.tableHeaderView.frame.size.height)];
    view.backgroundColor = [UIColor whiteColor];
    /* Create custom view to display section header... */
    if(section!=0)
    {
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(20,40, tableView.frame.size.width-40, 0.5)];
        viewLine.backgroundColor = [UIColor grayColor];
        [view addSubview:viewLine];
    }
    
    NSString *headerText = @"";
    
    if (section == 1)
    {
        if(arrPlans.count!=0)
        {
            headerText = NSLocalizedStringFromTableInBundle(@"Your Plans", nil, [[Helper sharedInstance] getLocalBundle], nil);
        }
    }
    else if (section == 2)
    {
        if(arrTipsData.count!=0)
        {
            UIButton *btnTips = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width-100,0,100, 35)];
            
            headerText = NSLocalizedStringFromTableInBundle(@"Tips for you", nil, [[Helper sharedInstance] getLocalBundle], nil);
            [btnTips setTitle:NSLocalizedStringFromTableInBundle(@"See all", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
            [btnTips setTitleColor:[Helper colorWithHexString:@"FF304B"] forState:UIControlStateNormal];
            [btnTips addTarget:self action:@selector(redirectToTecExpert) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:btnTips];
        }
    }
    else if(section == 3)
    {
        headerText = NSLocalizedStringFromTableInBundle(@"Protect your gadgets today!", nil, [[Helper sharedInstance] getLocalBundle], nil);
    }
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,15, tableView.frame.size.width - 100, 20)];
    [headerLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:18]];
    headerLabel.text = headerText;
    
    [view addSubview:headerLabel];
    
    return view;
}

-(void)redirectToTecExpert
{
    [self.tabBarController setSelectedIndex:1];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollPos = homeTableView.contentOffset.y ;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (screenSize.height == 812.0f)
        {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
        else
        {
            if(!checkForScroll)
            {
                if(scrollPos <= 200 && scrollPos != 0){
                    //Fully hide your toolbar
                    [UIView animateWithDuration:1 animations:^{
                        [self.navigationController setNavigationBarHidden:YES animated:YES];
                        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                    }];
                } else if(scrollPos > 200){
                    //Slide it up incrementally, etc.
                    [self.navigationController setNavigationBarHidden:NO animated:YES];
                    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
                }
            }
        }
    }
}

#pragma mark - CommonRequest Delegate

- (void)commonRequestGetResponse:(NSDictionary *)response withAPIName:(NSString *)name{
    
    if([name isEqualToString:@"tipsDetails"])
    {
        @try{
            BOOL success = [[response objectForKey:@"success"] boolValue];
            
            NSLog(@"tips value = %@",response);
            
            NSString *failure = [[response objectForKey:@"result"] objectForKey:@"status"];
            
            if(success)
            {
                [SVProgressHUD dismiss];
                
                if([failure isEqualToString:@"failed"])
                {
                    [Helper popUpMessage:[[response objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"Alert" view:[UIView new]];
                }
                else
                {
                    arrTipsData = [[response objectForKey:@"result"] objectForKey:@"data"];
                    [homeTableView reloadData];
                }
            }
            else
            {
                [SVProgressHUD dismiss];
            }
        }
        @catch(NSException *exception)
        {
            [Helper catchPopUp:@"Exception in top tip api" titleForPopUp:@""];
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
                
                NSDictionary *profileDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];
                
                if(profileDict.count != 0)
                {
                    CommonRequest *commonRequest = [CommonRequest sharedInstance];
                    commonRequest.delegate = self;

                    [commonRequest getMyPlans];
                }else{
                    [homeTableView reloadData];
                }
            }
        }
    }else if([name isEqualToString:@"getMyPlans"])
    {
        BOOL success = [[response objectForKey:@"success"] boolValue];
        NSString *status = [[response objectForKey:@"result"] objectForKey:@"status"];
        
        if(success)
        {
            [SVProgressHUD dismiss];
            
            if([status isEqualToString:@"success"])
            {
                arrPlans = [[response objectForKey:@"result"] objectForKey:@"data"];
                arrPlans = [[[arrPlans reverseObjectEnumerator] allObjects] mutableCopy];
            }else
            {
                [arrPlans removeAllObjects];
            }
            
            CommonRequest *commonRequest = [CommonRequest sharedInstance];
            commonRequest.delegate = self;
            
            [commonRequest requestForTopTips:[[[NSUserDefaults standardUserDefaults] objectForKey:@"profile"] objectForKey:@"customerid"]];
        }
    }
}

- (void)showCategoryAlert:(NSArray *)deviceCategoryArray withMyPlan:(NSDictionary *)dict
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
        [self redirectToDetailsView:categoryDictionary withMyPlan:dict];
        
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

- (void)redirectToDetailsView:(NSDictionary *)dict withMyPlan:(NSDictionary *)myPlanDict
{
    NSString *gadgetPrice = [myPlanDict objectForKey:@"cf_1333"];
    NSInteger price = [gadgetPrice integerValue];
    NSString *finalPrice = [NSString stringWithFormat: @"%ld", (long)price];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *purchasedOn = [dateFormatter dateFromString:[myPlanDict objectForKey:@"cf_2493"]];
    NSDate *endDate = [dateFormatter dateFromString:[myPlanDict objectForKey:@"duedate"]];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DetailedHomeViewController *detailedHomeViewController = [storyboard instantiateViewControllerWithIdentifier:@"DetailedHomeViewController"];
    detailedHomeViewController.hidesBottomBarWhenPushed = YES;
    detailedHomeViewController.purchaseDate = YES;
    detailedHomeViewController.purchasePrice = @"";
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
    detailedHomeViewController.devicePurchaseCost = finalPrice;
    detailedHomeViewController.devicePurchaseDate = purchasedOn;
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSString *endDateStr = [f stringFromDate:endDate];
    
    [[NSUserDefaults standardUserDefaults]  setObject:endDateStr forKey:@"endDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self.navigationController pushViewController:detailedHomeViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
