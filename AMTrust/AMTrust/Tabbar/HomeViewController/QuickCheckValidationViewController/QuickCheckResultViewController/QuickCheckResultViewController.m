//
//  QuickCheckResultViewController.m
//  Tecprotec
//
//  Created by kishore kumar on 09/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "QuickCheckResultViewController.h"

@interface QuickCheckResultViewController ()

@end

@implementation QuickCheckResultViewController
@synthesize quickCheckResultTableView;
@synthesize wifiBool,dataConnectionBool,batteryBool,gyroBool,bluetoothBool,gpsBool,bluetoothManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    [quickCheckResultTableView registerNib:[UINib nibWithNibName:@"QuickCheckResultTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QuickCheckResultTableViewCell"];
    
    bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    
    [self startLocationManager];
   time = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                   target:self
                                                 selector:@selector(timer)
                                                 userInfo:nil
                                                  repeats:YES];

}
-(void)timer
{
    wifiBool = [self isWifiOn];
    
    dataConnectionBool = [self isDataConnectorOn];
    
    batteryBool = [self isBatteryWorking];
    
    gyroBool = [self isGyroOn];
    
    [quickCheckResultTableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_btnContinue setTitle:NSLocalizedStringFromTableInBundle(@"Continue", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
    
    [_btnCancel setTitle:NSLocalizedStringFromTableInBundle(@"Cancel", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
    
    _lblholdOn.text = NSLocalizedStringFromTableInBundle(@"Hold on we are doing a few more checks", nil, [[Helper sharedInstance] getLocalBundle], nil);
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [time invalidate];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuickCheckResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuickCheckResultTableViewCell"];
    if(!cell)
    {
        cell = [[QuickCheckResultTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.btnDisclosure.tag = indexPath.row;
    [cell.btnDisclosure addTarget:self action:@selector(actionBtnDisclosure:) forControlEvents:UIControlEventTouchUpInside];
    if(indexPath.row==0)
    {
        cell.imgActivityLogo.image = [UIImage imageNamed:@"wifi"];
        cell.lblLeft.text = NSLocalizedStringFromTableInBundle(@"Wifi", nil, [[Helper sharedInstance] getLocalBundle], nil);
        if(wifiBool)
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"working"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor greenColor];
        }
        else
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"notworking"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor redColor];
        }
    }
    else if(indexPath.row==1)
    {
        cell.imgActivityLogo.image = [UIImage imageNamed:@"data"];
        cell.lblLeft.text = NSLocalizedStringFromTableInBundle(@"Data Connection", nil, [[Helper sharedInstance] getLocalBundle], nil);

        if(dataConnectionBool)
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"working"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor greenColor];
        }
        else
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"notworking"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor redColor];
        }

    }
    else if (indexPath.row==2)
    {
        cell.imgActivityLogo.image = [UIImage imageNamed:@"bluetooth"];
        cell.lblLeft.text = NSLocalizedStringFromTableInBundle(@"Bluetooth", nil, [[Helper sharedInstance] getLocalBundle], nil);
        if(bluetoothBool)
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"working"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor greenColor];
        }
        else
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"notworking"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor redColor];
        }
    }
    else if (indexPath.row==3)
    {
        cell.imgActivityLogo.image = [UIImage imageNamed:@"gps"];
        cell.lblLeft.text = NSLocalizedStringFromTableInBundle(@"GPS", nil, [[Helper sharedInstance] getLocalBundle], nil);
        if(gpsBool)
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"working"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor greenColor];
        }
        else
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"notworking"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor redColor];
        }
    }
    else if (indexPath.row==4)
    {
        cell.imgActivityLogo.image = [UIImage imageNamed:@"battery"];
        cell.lblLeft.text = NSLocalizedStringFromTableInBundle(@"Battery", nil, [[Helper sharedInstance] getLocalBundle], nil);
        if(batteryBool)
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"working"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor greenColor];
        }
        else
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"notworking"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor redColor];
        }
    }
    else if (indexPath.row==5)
    {
        cell.imgActivityLogo.image = [UIImage imageNamed:@"gyro"];
        cell.lblLeft.text = NSLocalizedStringFromTableInBundle(@"Gyroscope", nil, [[Helper sharedInstance] getLocalBundle], nil);
        if(gyroBool)
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"working"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor greenColor];
        }
        else
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"notworking"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor redColor];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(gyroBool) forKey:@"gyro"];
    [[NSUserDefaults standardUserDefaults] setObject:@(batteryBool) forKey:@"battery"];
    [[NSUserDefaults standardUserDefaults] setObject:@(gpsBool) forKey:@"gps"];
    [[NSUserDefaults standardUserDefaults] setObject:@(bluetoothBool) forKey:@"bluetooth"];
    [[NSUserDefaults standardUserDefaults] setObject:@(dataConnectionBool) forKey:@"dataConnection"];
    [[NSUserDefaults standardUserDefaults] setObject:@(wifiBool) forKey:@"wifi"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    return cell;
}

-(IBAction)actionBtnDisclosure:(UIButton *)btnDisclosure
{
    NSString *sendName;
    if(btnDisclosure.tag ==0)
    {
        if(!wifiBool)
        {
            sendName = NSLocalizedStringFromTableInBundle(@"Your WiFi connection has not been detected. Please check if your WiFi is turned on and connected to a working WiFi. You can see this in your device settings", nil, [[Helper sharedInstance] getLocalBundle], nil);

        }
    }
    else if (btnDisclosure.tag ==1)
    {
        if(!dataConnectionBool)
        {
            sendName =NSLocalizedStringFromTableInBundle(@"Your data connection has not been detected. Please check if your mobile data is turned on. You can find this in your device settings.", nil, [[Helper sharedInstance] getLocalBundle], nil);
        }

    }
    else if (btnDisclosure.tag ==2)
    {
        if(!bluetoothBool)
        {
            sendName = NSLocalizedStringFromTableInBundle(@"Your Bluetooth capability has not been detected. Please check if your Bluetooth is turned on. You can find this in your device settings.", nil, [[Helper sharedInstance] getLocalBundle], nil);
        }
    }
    else if (btnDisclosure.tag ==3)
    {
        if(!gpsBool)
        {
            sendName = [[NSBundle mainBundle] localizedStringForKey:@"" value:@"" table:nil];
        }
    }
    else if (btnDisclosure.tag ==4)
    {
        if(!batteryBool)
        {
            sendName =NSLocalizedStringFromTableInBundle(@"Your battery doesn’t seem to be in working condition.", nil, [[Helper sharedInstance] getLocalBundle], nil);
        }
    }
    else if (btnDisclosure.tag ==5)
    {
        if(!gyroBool)
        {
            sendName =NSLocalizedStringFromTableInBundle(@"Your device gyroscope doesn’t seem to be working.", nil, [[Helper sharedInstance] getLocalBundle], nil);
        }
    }
    
    if(sendName.length>0)
    {
        LGAlertView *actionSheet = [LGAlertView alertViewWithTitle:@""
                                                           message:sendName
                                                             style:LGAlertViewStyleActionSheet
                                                      buttonTitles:@[]
                                                 cancelButtonTitle:nil
                                            destructiveButtonTitle:@"ok"
                                                          delegate:self];
        [actionSheet showAnimated];

    }
    
}
- (IBAction)ActionClose:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)ActionContinue:(id)sender {
    
    QuickCheckValidationViewController *quickDiagonasisTestViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QuickCheckValidationViewController"];
    [self.navigationController pushViewController:quickDiagonasisTestViewController animated:YES];
}

#pragma mark verification

-(BOOL)isWifiOn
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if (status == ReachableViaWiFi)
    {
        return YES;
    }
    return NO;
}
-(BOOL)isDataConnectorOn
{
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    bool found = false;
    if (getifaddrs(&addrs) == 0) {
        cursor = addrs;
        while (cursor != NULL) {
            NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
            if ([name isEqualToString:@"pdp_ip0"]) {
                found = true;
                break;
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    
    if(found)
    {
        //[[Helper sharedManager] updateDiagnosisToUserDefaults:@"Data Connection" withValue:@"Working"];
        
    }else
    {
        //[[Helper sharedManager] updateDiagnosisToUserDefaults:@"Data Connection" withValue:@"Not Working"];
    }
    return found;
}
-(BOOL)isBatteryWorking
{
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    
    int state = [myDevice batteryState];
    NSLog(@"battery status: %d",state); // 0 unknown, 1 unplegged, 2 charging, 3 full
    
    if(state == 0)
    {
        return false;
    }else
    {
        return true;
    }
}

-(BOOL)isGyroOn
{
    CMMotionManager *motionManager = [[CMMotionManager alloc] init];
    
    if (motionManager.gyroAvailable) {
        return true;
    }else
    {
        
        return false;
    }
}

// method called whenever you have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
}

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the information there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSLog(@"Start scan");
    
    if(central.state == CBCentralManagerStatePoweredOn){
        NSLog(@"Scanning for BTLE device");
        
        
        bluetoothBool = YES;
    }
    else
    {
        bluetoothBool = NO;
    }
    [quickCheckResultTableView reloadData];
}

-(void)startLocationManager
{
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
   // [[Helper sharedManager] updateDiagnosisToUserDefaults:@"GPS" withValue:@"Working"];
    
    gpsBool = YES;
    [manager stopUpdatingLocation];
    [quickCheckResultTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
