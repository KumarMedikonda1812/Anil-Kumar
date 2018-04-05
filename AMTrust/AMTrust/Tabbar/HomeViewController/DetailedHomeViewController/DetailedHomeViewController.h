//
//  DetailedHomeViewController.h
//  TECPROTEC
//
//  Created by kishore kumar on 06/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailedTableViewCell.h"
#import "PolicyDetailViewController.h"
#import "BuyOptionTableViewCell.h"

@interface DetailedHomeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    IBOutlet UITableView *detailedTableView;
    IBOutlet UIButton *continueButton;
    
    NSMutableArray *arrPlanList,*arrColorList;
    NSInteger selectedPlan;
    NSInteger costPrice;
    NSString *phoneCost;
    NSString *phoneMonth;
    
    BOOL isPurchaseDateEditable;
    BOOL isGadgetPriceEditable;
}

@property BOOL purchaseDate;
@property BOOL purchasePrice;
@property BOOL renew;
@property BOOL isTablet;

@property (strong, nonatomic) NSString *devicePurchaseCost;
@property (strong, nonatomic) NSDate *devicePurchaseDate;
@property (strong, nonatomic) NSString *strDeviceId;
@property (strong, nonatomic) NSString *strCurrencyId;

@end
