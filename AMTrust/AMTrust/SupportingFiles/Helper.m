//
//  Helper.m
//  AMTrust
//
//  Created by kishore kumar on 24/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "Helper.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>

@implementation Helper

+ (instancetype)sharedInstance
{
    static Helper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Helper alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

+ (UIColor *)colorWithHexString:(NSString *)colorString
{
    colorString = [colorString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if (colorString.length == 3)
        colorString = [NSString stringWithFormat:@"%c%c%c%c%c%c",
                       [colorString characterAtIndex:0], [colorString characterAtIndex:0],
                       [colorString characterAtIndex:1], [colorString characterAtIndex:1],
                       [colorString characterAtIndex:2], [colorString characterAtIndex:2]];
    
    if (colorString.length == 6)
    {
        int r, g, b;
        sscanf([colorString UTF8String], "%2x%2x%2x", &r, &g, &b);
        return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0];
    }
    return nil;
}

+(float) getHeightForText:(NSString*) text withFont:(UIFont*) font andWidth:(float) width{
    CGSize constraint = CGSizeMake(width , 20000.0f);
    CGSize title_size;
    float totalHeight;
    
    SEL selector = @selector(boundingRectWithSize:options:attributes:context:);
    if ([text respondsToSelector:selector]) {
        title_size = [text boundingRectWithSize:constraint
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{ NSFontAttributeName : font }
                                        context:nil].size;
        
        totalHeight = ceil(title_size.height);
    } else {
        CGSize size = CGSizeMake(320,9999);
        CGRect textRect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        
        totalHeight = textRect.size.height;
    }
    
    CGFloat height = MAX(totalHeight, 40.0f);
    return height;
    
}

-(void)trackingScreen:(NSString *)screenName
{
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:GOOGLEANALYTICS];
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
}

+(void)popUpMessage:(NSString *)message titleForPopUp:(NSString *)title view:(UIView *)viewSelf
{
    LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:title message:message style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"ok" destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
    } cancelHandler:^(LGAlertView * _Nonnull alertView) {
        
    } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
        
    }];
    alertView.tintColor = THEMECOLOR;
    [alertView show];
}

+(void)showAlert:(NSString *)message titleForPopUp:(NSString *)title view:(UIView *)viewSelf handler:(void (^)(_Bool OkbuttonPressed))completion

{
    LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:title message:message style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"ok" destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
    } cancelHandler:^(LGAlertView * _Nonnull alertView) {
        
        completion(true);
        
    } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
        
    }];
    alertView.tintColor = THEMECOLOR;
    [alertView show];
}

+(void)catchPopUp:(NSString *)message titleForPopUp:(NSString *)title
{
    LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:title message:message style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"ok" destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
    } cancelHandler:^(LGAlertView * _Nonnull alertView) {
        
    } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
        
    }];
    alertView.tintColor = THEMECOLOR;
    [alertView show];
}

+(void)popUpMessage:(NSString *)message titleForPopUp:(NSString *)title buttonTitle:(NSString *)strButton
{
    LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:title message:message style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:strButton destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
    } cancelHandler:^(LGAlertView * _Nonnull alertView) {
        
    } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
        
    }];
    alertView.tintColor = THEMECOLOR;
    [alertView show];

}

+(void)showConnectionFailed
{
    [Helper popUpMessage:NSLocalizedStringFromTableInBundle(@"Connection to server failed. Please try again later", nil, [[Helper sharedInstance] getLocalBundle], nil) titleForPopUp:@"" view:[UIView new]];
}


-(void)getTokenString{
    
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
            
            [self getTokenString];
            
        } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
            
        }];
        alertView.tintColor = THEMECOLOR;
        [alertView show];

        [SVProgressHUD dismiss];
    };
    
    [r startAsynchronous];
    
}

-(void)getSessionID:(NSString *)accessKey
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
        //
        if(success)
        {
            NSDictionary *resultDict = [json objectForKey:@"result"];
            NSString *sessionName = [resultDict objectForKey:@"sessionName"];
            
            [[NSUserDefaults standardUserDefaults] setValue:[json objectForKey:@"result"] forKey:@"result"];
            [[NSUserDefaults standardUserDefaults] setValue:sessionName forKey:@"sessionID"];
            
        }
        [SVProgressHUD dismiss];

    };
    response.errorBlock = ^(NSError *error) {
        // ...
        [SVProgressHUD dismiss];
        [Helper popUpMessage:error.localizedDescription titleForPopUp:@"Error" view:[UIView new]];
    };
    
    
    [response startAsynchronous];
}

- (NSString *)deviceModelName {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //MARK: More official list is at
    //http://theiphonewiki.com/wiki/Models
    //MARK: You may just return machineName. Following is for convenience
    
    NSDictionary *commonNamesDictionary =
    @{
      @"i386":     @"i386 Simulator",
      @"x86_64":   @"x86_64 Simulator",
      
      @"iPhone1,1":    @"iPhone",
      @"iPhone1,2":    @"iPhone 3G",
      @"iPhone2,1":    @"iPhone 3GS",
      @"iPhone3,1":    @"iPhone 4",
      @"iPhone3,2":    @"iPhone 4(Rev A)",
      @"iPhone3,3":    @"iPhone 4(CDMA)",
      @"iPhone4,1":    @"iPhone 4S",
      @"iPhone5,1":    @"iPhone 5(GSM)",
      @"iPhone5,2":    @"iPhone 5(GSM+CDMA)",
      @"iPhone5,3":    @"iPhone 5c(GSM)",
      @"iPhone5,4":    @"iPhone 5c(GSM+CDMA)",
      @"iPhone6,1":    @"iPhone 5s(GSM)",
      @"iPhone6,2":    @"iPhone 5s(GSM+CDMA)",
      
      @"iPhone7,1":    @"iPhone 6+(GSM+CDMA)",
      @"iPhone7,2":    @"iPhone 6(GSM+CDMA)",
      
      @"iPhone8,1":    @"iPhone 6S(GSM+CDMA)",
      @"iPhone8,2":    @"iPhone 6S+(GSM+CDMA)",
      @"iPhone8,4":    @"iPhone SE(GSM+CDMA)",
      @"iPhone9,1":    @"iPhone 7(GSM+CDMA)",
      @"iPhone9,2":    @"iPhone 7+(GSM+CDMA)",
      @"iPhone9,3":    @"iPhone 7(GSM+CDMA)",
      @"iPhone9,4":    @"iPhone 7+(GSM+CDMA)",
      @"iPhone10,1": @"iPhone 8",
      @"iPhone10,4": @"iPhone 8",
      @"iPhone10,2": @"iPhone 8 plus",
      @"iPhone10,5": @"iPhone 8 plus",
      @"iPhone10,3": @"iPhone x",
      @"iPhone10,6": @"iPhone x",
      
      @"iPad1,1":  @"iPad",
      @"iPad2,1":  @"iPad 2(WiFi)",
      @"iPad2,2":  @"iPad 2(GSM)",
      @"iPad2,3":  @"iPad 2(CDMA)",
      @"iPad2,4":  @"iPad 2(WiFi Rev A)",
      @"iPad2,5":  @"iPad Mini 1G (WiFi)",
      @"iPad2,6":  @"iPad Mini 1G (GSM)",
      @"iPad2,7":  @"iPad Mini 1G (GSM+CDMA)",
      @"iPad3,1":  @"iPad 3(WiFi)",
      @"iPad3,2":  @"iPad 3(GSM+CDMA)",
      @"iPad3,3":  @"iPad 3(GSM)",
      @"iPad3,4":  @"iPad 4(WiFi)",
      @"iPad3,5":  @"iPad 4(GSM)",
      @"iPad3,6":  @"iPad 4(GSM+CDMA)",
      
      @"iPad4,1":  @"iPad Air(WiFi)",
      @"iPad4,2":  @"iPad Air(GSM)",
      @"iPad4,3":  @"iPad Air(GSM+CDMA)",
      
      @"iPad5,3":  @"iPad Air 2 (WiFi)",
      @"iPad5,4":  @"iPad Air 2 (GSM+CDMA)",
      
      @"iPad4,4":  @"iPad Mini 2G (WiFi)",
      @"iPad4,5":  @"iPad Mini 2G (GSM)",
      @"iPad4,6":  @"iPad Mini 2G (GSM+CDMA)",
      
      @"iPad4,7":  @"iPad Mini 3G (WiFi)",
      @"iPad4,8":  @"iPad Mini 3G (GSM)",
      @"iPad4,9":  @"iPad Mini 3G (GSM+CDMA)",
      
      @"iPod1,1":  @"iPod 1st Gen",
      @"iPod2,1":  @"iPod 2nd Gen",
      @"iPod3,1":  @"iPod 3rd Gen",
      @"iPod4,1":  @"iPod 4th Gen",
      @"iPod5,1":  @"iPod 5th Gen",
      @"iPod7,1":  @"iPod 6th Gen",
      };
    
    NSString *deviceName = commonNamesDictionary[machineName];
    
    if (deviceName == nil) {
        deviceName = machineName;
    }
    
    return deviceName;
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

+(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark - Mobile Number validation
- (BOOL)mobileNumberValidate:(NSString*)number
{
    NSString *numberRegEx = @"[0-13]";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
        return TRUE;
    else
        return FALSE;
}

+(NSString *)countryCode
{
    NSLocale *countryLocale = [NSLocale currentLocale];
    NSString *countryCode = [countryLocale objectForKey:NSLocaleCountryCode];
    NSString *country = [countryLocale displayNameForKey:NSLocaleCountryCode value:countryCode];
    NSLog(@"Country Code:%@ Name:%@", countryCode, country);

        NSDictionary *dictionaryCountry = [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
                @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
                @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
                @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
                @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
                @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
                @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
                @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
                @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
                @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
    
    return [dictionaryCountry objectForKey:countryCode];
}

-(BOOL)isLogin
{
    NSDictionary *profileDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];
    if(profileDict.count ==0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(NSBundle *)getLocalBundle
{
    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:@"BundlePath"];
    return [NSBundle bundleWithPath:path];
}

-(NSString *)getCurrencyFormatting:(NSString *)cost
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *myNumber = [formatter numberFromString:cost];
    NSString *formatted = [formatter stringFromNumber:myNumber];
    
    return formatted;
}

-(BOOL)checkForNull:(NSString *)processValue
{
    if([processValue isEqual:[NSNull null]])
    {
        return YES;
    }else if([processValue isEqualToString:@"<null>"] || [processValue isEqualToString:@"(null)"])
    {
        return YES;
    }
    
    return NO;
}

-(BOOL)shouldShowRenewButton:(NSArray *)categoryArray withCurrentDict:(NSDictionary *)dict
{
    NSString *currentCategory = [dict objectForKey:@"device_category"];

    if([currentCategory isEqualToString:@"Smartphone"])
    {
        //Get remaining days from end date
        NSString *endDateStr = [dict objectForKey:@"duedate"];
        
        if([[Helper sharedInstance] checkForNull:endDateStr] || [endDateStr isEqualToString:@"NA"]){
            endDateStr = [dict objectForKey:@"cf_1858"];
        }
        
        NSInteger remainingDays = [self calculateRemainingDays:endDateStr];
        
        //Get number of smartphone plans this customer has
        int numberOfSmartPhonePlan = [self getNumberOfSmartphonePlans:categoryArray];

        if(remainingDays <= 30)
        {
            if(numberOfSmartPhonePlan == 1)
            {
                return NO;
            }else{
                return YES;
            }
        }else
        {
            return YES;
        }
    }else
    {
        return NO;
    }
}

-(int)getNumberOfSmartphonePlans:(NSArray *)categoryArray
{
    int numberOfSmartPhonePlan = 0;
    
    for(int i=0;i<[categoryArray count];i++)
    {
        NSDictionary *dict = [categoryArray objectAtIndex:i];
        if([[dict objectForKey:@"device_category"] isEqualToString:@"Smartphone"])
        {
            numberOfSmartPhonePlan++;
        }
    }
    
    return numberOfSmartPhonePlan;
}

-(NSInteger)calculateRemainingDays:(NSString *)endDateStr
{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *endDate = [f dateFromString:endDateStr];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents *remainingDays = [gregorianCalendar components:NSCalendarUnitDay
                                                           fromDate:[NSDate date]
                                                             toDate:endDate
                                                            options:0];
    
    CGFloat currentDays;
    currentDays = [remainingDays day];
    NSInteger remainDays = [remainingDays day];
    
    return remainDays;
}
@end
