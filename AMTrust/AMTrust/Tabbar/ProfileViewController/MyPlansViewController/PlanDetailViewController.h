//
//  PlanDetailViewController.h
//  TECPROTEC
//
//  Created by Sethu on 23/2/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanModel.h"
#import "PlanRequirementCell.h"
#import "PlanButtonTableViewCell.h"
#import "Ipay.h"
#import "IpayPayment.h"
#import "SuccessViewControllerLost.h"
#import "WebViewController.h"
#import "DetailedHomeViewController.h"

@interface PlanDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CommonRequestDelegate,PaymentResultDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    IBOutlet UITableView *planTableView;
    
    CommonRequest *commonRequest;
    
    NSArray *orderArray;
    NSArray *deviceCategoryArray;
    
    NSMutableArray *buttonArray;

    PlanModel *planModel;

    BOOL invoiceReceipt;
    UIImage *imgScreen;
    BOOL FrontCamera;


}

@property (strong, nonatomic) NSString *policyID;
@property (strong, nonatomic) NSString *deviceCategory;
@property (strong, nonatomic) NSArray *categoryArray;
@property (strong, nonatomic) NSArray *myPlanArray;
@property UIView *paymentView;
@property Ipay *paymentSdk;

@end
