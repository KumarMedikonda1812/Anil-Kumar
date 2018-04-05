//
//  QuickCheckResultViewController.h
//  Tecprotec
//
//  Created by kishore kumar on 09/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickCheckResultTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "QuickDiagonasisTestViewController.h"
#import "QuickCheckValidationViewController.h"
#import "Reachability.h"
#import <ifaddrs.h>
#import <CoreMotion/CoreMotion.h>

@import CoreBluetooth;

@interface QuickCheckResultViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,CBCentralManagerDelegate,LGAlertViewDelegate>
{
    CLLocationManager *locationManager;
    NSTimer *time;
}
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (strong, retain) CBCentralManager *bluetoothManager;
@property (weak, nonatomic) IBOutlet UITableView *quickCheckResultTableView;
@property (weak, nonatomic) IBOutlet UILabel *lblholdOn;
@property  BOOL wifiBool,dataConnectionBool,batteryBool,gyroBool,bluetoothBool,gpsBool;

@end
