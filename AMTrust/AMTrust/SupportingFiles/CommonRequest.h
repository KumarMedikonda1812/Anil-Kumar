//
//  CommonRequest.h
//  TecProtec
//
//  Created by kishore kumar on 28/07/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+RemoveNulls.h"

@protocol CommonRequestDelegate <NSObject>
@required
-(void)commonRequestGetResponse:(NSDictionary *)response withAPIName:(NSString *)name;
@end

@interface CommonRequest : NSObject

@property( nonatomic, weak) id<CommonRequestDelegate> delegate;

+ (instancetype)sharedInstance;
- (void)requestForTopTips:(NSString *)customerID;
- (void)getMyPlans;
- (void)getPlanDetails:(NSString *)policyID;
- (void)getPlanUploadStatus:(NSString *)policyID;
- (void)cancelPolicy:(NSString *)policyID;
- (void)getDeviceCategories;
- (void)loginRequest:(NSString *)loginUser withPassword:(NSString *)password withType:(NSString *)type;
- (void)customerExist:(NSDictionary *)elementDictionary;
- (void)getAccessKey;
- (void)getSessionID:(NSString *)accessKey;
@end
