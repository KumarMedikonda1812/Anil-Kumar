//
//  PolicyModel.h
//  TECPROTEC
//
//  Created by Sethu on 4/2/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PolicyModel : NSObject
{
    
}
@property (strong, nonatomic) NSString *planBenifits;
@property (strong, nonatomic) NSString *planTnC;
@property (strong, nonatomic) NSString *planDescriptions;
@property (strong, nonatomic) NSString *planExclusions;
@property (strong, nonatomic) NSString *planName;
@property (strong, nonatomic) NSString *planPrice;

- (instancetype) init;
- (void) updateModelWithDictionary:(NSDictionary *)dict;

@end
