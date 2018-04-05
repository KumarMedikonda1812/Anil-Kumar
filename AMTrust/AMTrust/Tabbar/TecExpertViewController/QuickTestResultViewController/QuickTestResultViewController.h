//
//  QuickTestResultViewController.h
//  Tecprotec
//
//  Created by kishore kumar on 16/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickCheckResultTableViewCell.h"
#import "TestDataCollectionViewController.h"
#import "SuccessViewController.h"
#import "AFNetworking.h"

@interface QuickTestResultViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,LGAlertViewDelegate>
{
}
@property (weak, nonatomic) IBOutlet UILabel *lblDeviceSummary;
@property (weak, nonatomic) IBOutlet UITableView *deviceSummaryTableView;
@property  BOOL volumeBool,muteBool,frontCamBool,rearCamBool,screenTestBool,screenShotBool,wifiBool,dataConnectionBool,batteryBool,gyroBool,bluetoothBool,gpsBool;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

- (IBAction)ActionBack:(id)sender;
- (IBAction)ActionContinue:(id)sender;
@end
