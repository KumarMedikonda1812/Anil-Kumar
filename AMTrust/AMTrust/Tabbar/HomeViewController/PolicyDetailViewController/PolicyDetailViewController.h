//
//  PolicyDetailViewController.h
//  Tecprotec
//
//  Created by kishore kumar on 07/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PolicyHeaderTableViewCell.h"
#import "PolicyPriceTableViewCell.h"
#import "TextTableViewCell.h"
#import "TestDataCollectionViewController.h"
#import "ButtonTableViewCell.h"
#import "WebViewController.h"
#import "PolicyModel.h"

@interface PolicyDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
{
    IBOutlet UITableView *policyDetailsTableView;
    IBOutlet UIButton *btnBuyNow;
    
    NSArray *arrayForTitle;
    NSString *prodtnc;
    PolicyModel *policyModel;
}
@property (strong, nonatomic) NSDictionary *dicProductDetails;
@property(strong) NSString *rangeInput;
@property(strong) NSString *productId;
@property(strong) NSString *backgroundColor;
@property(strong) NSString *currencyCode;
@property BOOL isTablet;

@property (strong, nonatomic) UIImage *img;

@end
