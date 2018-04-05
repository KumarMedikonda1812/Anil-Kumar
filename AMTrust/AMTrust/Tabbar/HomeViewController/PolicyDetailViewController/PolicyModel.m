//
//  PolicyModel.m
//  TECPROTEC
//
//  Created by Sethu on 4/2/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import "PolicyModel.h"

@implementation PolicyModel
@synthesize planBenifits;
@synthesize planTnC;
@synthesize planDescriptions;
@synthesize planExclusions;
@synthesize planName;
@synthesize planPrice;

- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        planBenifits = @"";
        planTnC = @"";
        planDescriptions = @"";
        planExclusions = @"";
        planName = @"";
        planPrice = @"";
    }
    
    return self;
}


- (void) updateModelWithDictionary:(NSDictionary *)dict {
    
    NSLog(@"Dict = %@",dict);
    
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"ApiCurrentLanguage"];

    if([language isEqualToString:@"english"])
    {
        planBenifits = [dict objectForKey:@"detaildescription"];;
        planTnC = [dict objectForKey:@"prodtnc"];
        planDescriptions = [dict objectForKey:@"description"];
        planExclusions = [dict objectForKey:@"cf_2435"];
    }else
    {
        planBenifits = [dict objectForKey:@"cf_2439"];
        planTnC = [dict objectForKey:@"cf_2443"];
        planDescriptions = [dict objectForKey:@"cf_2437"];
        planExclusions = [dict objectForKey:@"cf_2441"];
    }
    
    planName = [dict objectForKey:@"productname"];
    planDescriptions = [planDescriptions stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    planPrice = [dict objectForKey:@"price_inc_vat"];
    planPrice = [[Helper sharedInstance] getCurrencyFormatting:planPrice];
}

@end
