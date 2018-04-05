//
//  CommonRequest.m
//  TecProtec
//
//  Created by kishore kumar on 28/07/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "CommonRequest.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>

@implementation CommonRequest
@synthesize delegate;

+ (instancetype)sharedInstance
{
    static CommonRequest *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CommonRequest alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void)getAccessKey{
    
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    r.GETDictionary =@{@"operation":@"getchallenge",
                       @"username":@"WS"};
    
    NSLog(@"PARAMETER %@", r.GETDictionary);
    
    r.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:kNilOptions
                                                                      error:&error];
        
        json = [json replaceNullsWithObject:@"NA"];
        
        NSLog(@"RESPONSE %@",json);
        
        @try {
            
            int success = [[json objectForKey:@"success"] intValue];
            if( success == 1)
            {
                NSString *token = [[json objectForKey:@"result"] objectForKey:@"token"];
                
                NSString *md5Value = [self md5:[NSString stringWithFormat:@"%@%@",token,@"xf2MY6iTVxAL0hNO"]];
                
                [self getSessionID:md5Value];
                
            }
            
        } @catch (NSException *exception) {
            
        }
        
        
        [SVProgressHUD dismiss];
    };
    r.errorBlock = ^(NSError *error) {
        // ...
        LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:error.localizedDescription message:@"" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"Retry" destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
        } cancelHandler:^(LGAlertView * _Nonnull alertView) {
            
            [self getAccessKey];
            
        } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
            
        }];
        alertView.tintColor = THEMECOLOR;
        [alertView show];
        
        [SVProgressHUD dismiss];
    };
    
    [r startAsynchronous];
    
}

- (void)getSessionID:(NSString *)accessKey
{
    NSDictionary *paramDictionary=[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"login", @"operation",
                                   @"WS",@"username",
                                   accessKey,@"accessKey",
                                   nil];
    
    NSLog(@"PARAMETER %@", paramDictionary);
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    
    response.POSTDictionary = paramDictionary;
    
    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:kNilOptions
                                                                      error:&error];
        
        json = [json replaceNullsWithObject:@"NA"];
        
        NSLog(@"RESPONSE %@", json);
        
        BOOL success = [[json objectForKey:@"success"] boolValue];
        
        if(success)
        {
            NSDictionary *resultDict = [json objectForKey:@"result"];
            NSString *sessionName = [resultDict objectForKey:@"sessionName"];
            
            [[NSUserDefaults standardUserDefaults] setValue:[json objectForKey:@"result"] forKey:@"result"];
            [[NSUserDefaults standardUserDefaults] setValue:sessionName forKey:@"sessionID"];
            
            [delegate commonRequestGetResponse:json withAPIName:@"getAccessKey"];
        }
        [SVProgressHUD dismiss];
        
    };
    response.errorBlock = ^(NSError *error) {
        [SVProgressHUD dismiss];
        [Helper popUpMessage:error.localizedDescription titleForPopUp:@"Error" view:[UIView new]];
    };
    
    
    [response startAsynchronous];
}

- (NSString *)md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

- (void)requestForTopTips:(NSString *)customerID
{
    NSLog(@"requestForTopTips");

    [SVProgressHUD showWithStatus:@"Loading.."];
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    NSString *apiLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"ApiCurrentLanguage"];
    response.POSTDictionary =@{@"operation":@"ams.top_tips",
                               @"sessionName":sessionName,
                               @"contactid":customerID,
                               @"language":apiLanguage
                               };
    
    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary* response = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        response = [response replaceNullsWithObject:@"NA"];

        [delegate commonRequestGetResponse:response withAPIName:@"tipsDetails"];
    
    };
    response.errorBlock = ^(NSError *error) {
        // ...
        [SVProgressHUD dismiss];
        [Helper popUpMessage:error.localizedDescription titleForPopUp:@"Error" view:[UIView new]];
    };
    
    [response startAsynchronous];

}

- (void)getMyPlans
{
    NSLog(@"getMyPlans");

    [SVProgressHUD showWithStatus:@"loading.."];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    NSString *apiLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"ApiCurrentLanguage"];
    NSString *customerId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"profile"] objectForKey:@"customerid"];
    
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:BASEURL];
    
    response.POSTDictionary = @{@"operation":@"ams.policy_list",
                                @"sessionName":sessionName,
                                @"contactid":customerId,//@"3196718",
                                @"language":apiLanguage
                                };
    
    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        @try {
            NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
            
            if(data != nil)
            {
                NSMutableDictionary* response = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:kNilOptions
                                                                           error:&error];
                response = [response replaceNullsWithObject:@"NA"];

                NSLog(@"response = %@",response);
                
                [delegate commonRequestGetResponse:response withAPIName:@"getMyPlans"];
            }else
            {
                [Helper showConnectionFailed];
            }
           
            [SVProgressHUD dismiss];

        }@catch (NSException *exception) {
            [Helper showConnectionFailed];
        }
        
        [SVProgressHUD dismiss];
    };
    response.errorBlock = ^(NSError *error) {

        [SVProgressHUD dismiss];
        [Helper showConnectionFailed];
    };
    
    [response startAsynchronous];
}

- (void)getPlanDetails:(NSString *)policyID
{
    NSLog(@"getPlanDetails");
    
    [SVProgressHUD showWithStatus:@"My plans loading.."];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:BASEURL];
    
    response.POSTDictionary = @{@"operation":@"ams.policy_detail",
                                @"sessionName":sessionName,
                                @"policyid":policyID
                                };
    
    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        @try {
            NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
            
            if(data != nil)
            {
                NSMutableDictionary* response = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:kNilOptions
                                                                           error:&error];
                response = [response replaceNullsWithObject:@"NA"];

                [delegate commonRequestGetResponse:response withAPIName:@"getPlanDetails"];
            }else
            {
                [Helper showConnectionFailed];
            }

        }@catch (NSException *exception) {

            [Helper showConnectionFailed];
        }
        
        [SVProgressHUD dismiss];

    };
    response.errorBlock = ^(NSError *error) {
        [Helper showConnectionFailed];
    };
    
    [response startAsynchronous];
}

- (void)getPlanUploadStatus:(NSString *)policyID
{
    NSLog(@"getPlanUploadStatus");
    
    [SVProgressHUD showWithStatus:@"waiting.."];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:BASEURL];
    
    response.POSTDictionary = @{@"operation":@"ams.retriveservicerequest",
                                @"sessionName":sessionName,
                                @"policyid":policyID
                                
                                };
    
    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        @try {
            NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
            
            if(data != nil)
            {
                NSMutableDictionary* response = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:kNilOptions
                                                                           error:&error];
                response = [response replaceNullsWithObject:@"NA"];

                [delegate commonRequestGetResponse:response withAPIName:@"getPlanUploadStatus"];
            }else
            {
                [Helper showConnectionFailed];
            }

        }@catch (NSException *exception) {
            [Helper showConnectionFailed];
        }
        
        [SVProgressHUD dismiss];
    };
    response.errorBlock = ^(NSError *error) {
        [SVProgressHUD dismiss];
        [Helper showConnectionFailed];
    };
    
    [response startAsynchronous];
    
}

- (void)cancelPolicy:(NSString *)policyID
{
    NSLog(@"cancelPolicy");

    [SVProgressHUD showWithStatus:@"Cancelling.."];
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    
    
    response.POSTDictionary = @{@"operation":@"ams.cancelpolicy",
                                @"sessionName":sessionName,
                                @"policyid":policyID
                                };
    
    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        @try {
            NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
            
            if(data != nil)
            {
                NSMutableDictionary* response = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:kNilOptions
                                                                           error:&error];
                response = [response replaceNullsWithObject:@"NA"];

                [delegate commonRequestGetResponse:response withAPIName:@"cancelPolicy"];
            }else{
                [Helper showConnectionFailed];
            }
            
            
        }@catch (NSException *exception) {
            [Helper showConnectionFailed];
        }
        
        [SVProgressHUD dismiss];

    };
    response.errorBlock = ^(NSError *error) {
        [SVProgressHUD dismiss];
        [Helper showConnectionFailed];

    };
    
    [response startAsynchronous];
}

- (void)getDeviceCategories
{
    NSLog(@"getDeviceCategories");

    [SVProgressHUD showWithStatus:@"Loading.."];
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    NSString *countryId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Country"];
    NSString *apiLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"ApiCurrentLanguage"];
    
    response.POSTDictionary =@{@"operation":@"ams.device_list",
                               @"sessionName":sessionName,
                               @"language":apiLanguage,
                               @"country_id":countryId
                               };
    
    NSLog(@"response.POSTDictionary = %@",response.POSTDictionary);
    NSLog(@"url = %@",[NSString stringWithFormat:@"%@",BASEURL]);

    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        @try{
            
            NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
            
            if(data != nil)
            {
                NSMutableDictionary* response = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:kNilOptions
                                                                       error:&error];
                
                response = [response replaceNullsWithObject:@"NA"];
                
                NSLog(@"response = %@",response);
                BOOL status = [[response objectForKey:@"success"] boolValue];
                
                if(status){
                    [delegate commonRequestGetResponse:response withAPIName:@"getDeviceCategories"];
                }else{
                    NSString *code = [response objectForKey:@"code"];

                    if([code isEqualToString:@"INVALID_SESSIONID"])
                    {
                        [self getAccessKey];
                    }
                }
            }else
            {
                [Helper showConnectionFailed];
            }
            
        }@catch(NSException *exception)
        {
            [Helper showConnectionFailed];
        }
        
        [SVProgressHUD dismiss];
    };
    response.errorBlock = ^(NSError *error) {
        [SVProgressHUD dismiss];
        [Helper showConnectionFailed];
    };
    
    [response startAsynchronous];
}

- (void)loginRequest:(NSString *)loginUser withPassword:(NSString *)password withType:(NSString *)type
{
    [SVProgressHUD showWithStatus:@"Login.."];
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    response.POSTDictionary =@{@"operation":@"ams.login",
                               type:loginUser,
                               @"sessionName":sessionName,
                               @"password":password
                               };
    
    NSLog(@"PARAMETER = %@",response.POSTDictionary);
    
    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
        
        @try {
            
            if(data != nil)
            {
                NSMutableDictionary* response = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:kNilOptions
                                                                                  error:&error];
                response = [response replaceNullsWithObject:@"NA"];
                
                if([password isEqualToString:@"facebook"])
                {
                    [delegate commonRequestGetResponse:response withAPIName:@"facebook"];
                }else
                {
                    [delegate commonRequestGetResponse:response withAPIName:@"normal"];
                }

            }else
            {
                [Helper showConnectionFailed];
            }
            
            [SVProgressHUD dismiss];

        } @catch (NSException *exception) {
            [Helper catchPopUp:body titleForPopUp:@""];
        }
    };
    response.errorBlock = ^(NSError *error) {
        [SVProgressHUD dismiss];
        [Helper showConnectionFailed];
    };
    
    [response startAsynchronous];
}

- (void)customerExist:(NSDictionary *)elementDictionary
{
    [SVProgressHUD showWithStatus:@"Customer verification.."];
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:elementDictionary // Here you can pass array or dictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString;
    
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        NSLog(@"Got an error: %@", error);
        jsonString = @"";
    }
    
    response.POSTDictionary = @{@"operation":@"ams.userexist",
                                @"sessionName":sessionName,
                                @"element":jsonString,
                                @"elementType":@"Contacts"
                                };
    
    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:kNilOptions
                                                                      error:&error];
        json = [json replaceNullsWithObject:@"NA"];
        
        [delegate commonRequestGetResponse:json withAPIName:@"customerExist"];
       
    };
    response.errorBlock = ^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [Helper popUpMessage:error.localizedDescription titleForPopUp:@"Error" view:[UIView new]];
    };
    
    [response startAsynchronous];
}

@end

