//
//  SummaryViewController.h
//  TecProtec
//
//  Created by kishore kumar on 08/09/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SummaryScreenTableViewCell.h"
#import "PolicyPriceTableViewCell.h"
#import "Ipay.h"
#import "IpayPayment.h"
#import "TermsAndConditionTableViewCell.h"
#import "PolicyDetailViewController.h"
#import "WebViewController.h"
#import "SuccessViewControllerLost.h"
#import "TermsViewController.h"
#import "PolicyModel.h"

@interface SummaryViewController : UIViewController<PaymentResultDelegate,UITableViewDelegate,UITableViewDataSource>
{
    PolicyModel *policyModel;
    NSDictionary *elementDictionaryPolicy;
    NSArray *arrTitle;
    BOOL selected,two,three;
    NSString *prodtnc;
    NSString *productId;
    NSString *policyId;
}
@property  BOOL volumeBool,muteBool,frontCamBool,rearCamBool,screenTestBool,screenShotBool,wifiBool,dataConnectionBool,batteryBool,gyroBool,bluetoothBool,gpsBool;
@property UIView *paymentView;
@property Ipay *paymentSdk;
@property (nonatomic , strong) NSString *strIMEI;
@property (nonatomic , strong) NSString *strMake;
@property (weak, nonatomic) IBOutlet UITableView *summaryTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnProceedtoPay;
@property BOOL isTablet;

@end
