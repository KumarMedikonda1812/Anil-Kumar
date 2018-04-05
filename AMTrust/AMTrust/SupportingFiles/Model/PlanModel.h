//
//  PlanModel.h
//  TECPROTEC
//
//  Created by Sethu on 23/2/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanModel : NSObject
{
    NSDictionary *planDictionary;
}

@property (strong, nonatomic) NSString *subscriber;
@property (strong, nonatomic) NSString *plan;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *gadgetPrice;
@property (strong, nonatomic) NSString *currencyUnit;
@property (strong, nonatomic) NSDate *purchasedOn;
@property (strong, nonatomic) NSDate *expiresOn;
@property (strong, nonatomic) NSString *subTotal;
@property (strong, nonatomic) NSString *imei; // Used for claims
@property (strong, nonatomic) NSDate *gadgetPurchasedOn;
    
@property (strong, nonatomic) NSString *receiptUploadStatus;
@property (strong, nonatomic) NSString *crackScreenStatus;

@property (nonatomic) BOOL showPayNowButton;
@property (nonatomic) BOOL showCancelButton;
@property (nonatomic) BOOL showRenewButton;
@property (nonatomic) BOOL showClaimButton;

- (instancetype)init;
- (void)updateModelWithDictionary:(NSDictionary *)dict;
- (void)checkRenewPlan:(NSArray *)categoryArray;
- (void)checkPayNow;
- (void)checkCancel;
- (void)checkSubmitClaim;
@end
