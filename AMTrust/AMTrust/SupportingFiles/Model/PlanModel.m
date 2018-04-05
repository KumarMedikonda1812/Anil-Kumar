//
//  PlanModel.m
//  TECPROTEC
//
//  Created by Sethu on 23/2/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import "PlanModel.h"

@implementation PlanModel

@synthesize subscriber;
@synthesize plan;
@synthesize category;
@synthesize status;
@synthesize gadgetPurchasedOn;
@synthesize gadgetPrice;
@synthesize purchasedOn;
@synthesize expiresOn;
@synthesize subTotal;
@synthesize imei;

@synthesize receiptUploadStatus;
@synthesize crackScreenStatus;

@synthesize showPayNowButton;
@synthesize showCancelButton;
@synthesize showRenewButton;
@synthesize showClaimButton;

- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        subscriber = @"";
        plan = @"";
        category = @"";
        status = @"";
        gadgetPrice = @"";
        purchasedOn = nil;
        expiresOn = nil;
        subTotal = @"";
        imei = @"";
        
        receiptUploadStatus = @"Not Uploaded";
        crackScreenStatus = @"Not Uploaded";
        
        showPayNowButton = NO;
        showCancelButton = NO;
        showRenewButton = NO;
        showClaimButton = NO;
    }
    
    return self;
}


- (void)updateModelWithDictionary:(NSDictionary *)dict {
        
    planDictionary = dict;

    self.plan = [dict objectForKey:@"productname"];
    self.category = [dict objectForKey:@"device_category"];
    self.status = [dict objectForKey:@"cf_1965"];
    self.gadgetPrice = [dict objectForKey:@"cf_1333"];
    self.subTotal = [dict objectForKey:@"subtotal"];
    self.imei = [dict objectForKey:@"subject"];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];

    self.purchasedOn = [dateFormatter dateFromString:[dict objectForKey:@"cf_1925"]];
    self.expiresOn = [dateFormatter dateFromString:[dict objectForKey:@"duedate"]];
    self.gadgetPurchasedOn = [dateFormatter dateFromString:[dict objectForKey:@"cf_2493"]];
}

-(void)checkRenewPlan:(NSArray *)categoryArray
{
    if([self.category isEqualToString:@"Tablet"])
    {
        showRenewButton = YES;
    }else
    {
        showRenewButton = [[Helper sharedInstance] shouldShowRenewButton:categoryArray withCurrentDict:planDictionary];
    }
}

-(void)checkPayNow
{
    if([self.status isEqualToString:@"Waiting for Payment"])
    {
        showPayNowButton = YES;
    }else
    {
        showPayNowButton = NO;
    }
}

-(void)checkCancel
{
    if([self.status isEqualToString:@"Waiting for Payment"])
    {
        showCancelButton = YES;
    }else
    {
        showCancelButton = NO;
    }
}

-(void)checkSubmitClaim
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *startRemainingDays = [gregorianCalendar components:NSCalendarUnitDay
                                                                fromDate:[NSDate date]
                                                                  toDate:self.purchasedOn
                                                                 options:0];
    NSDateComponents *endRemainingDays = [gregorianCalendar components:NSCalendarUnitDay
                                                              fromDate:[NSDate date]
                                                                toDate:self.expiresOn
                                                               options:0];
    
    
    NSInteger startDays = [startRemainingDays day];
    NSInteger endDays = [endRemainingDays day];
    
    if([self.category isEqualToString:@"Tablet"])
    {
        if([self.status isEqualToString:@"POLICY-Current"] && endDays > 0 && startDays <= 0)
        {
            showClaimButton = YES;
        }else
        {
            showClaimButton = NO;
        }
    }else
    {
        if([self.status isEqualToString:@"POLICY-Current"] && endDays > 0 && startDays <= 0 && [self.crackScreenStatus isEqualToString:@"Approved"])
        {
            showClaimButton = YES;
        }else
        {
            showClaimButton = NO;
        }
    }
}

@end

