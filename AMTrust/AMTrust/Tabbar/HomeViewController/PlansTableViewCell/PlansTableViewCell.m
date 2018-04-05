//
//  PlansTableViewCell.m
//  AMTrust
//
//  Created by kishore kumar on 05/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "PlansTableViewCell.h"

@implementation PlansTableViewCell
@synthesize planLabel;
@synthesize descriptionLabel;
@synthesize progressBar;
@synthesize dateLabel;
@synthesize logoImageView;
@synthesize renewButton;
@synthesize statusLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)updateContent:(NSDictionary *)dict withContentArray:(NSArray *)contentArray
{
    NSString *startDateStr = [dict objectForKey:@"cf_1297"];
    NSString *endDateStr = [dict objectForKey:@"duedate"];
    NSString *currentCategory = [dict objectForKey:@"device_category"];
    NSString *planNameStr = [dict objectForKey:@"productname"];
    
    self->contentArray = contentArray;
    
    if([[Helper sharedInstance] checkForNull:endDateStr])
    {
        endDateStr = [dict objectForKey:@"cf_1858"];
    }

    if([[Helper sharedInstance] checkForNull:startDateStr] || [[Helper sharedInstance] checkForNull:endDateStr])
    {
        dateLabel.text =  @"";
        renewButton.hidden = YES;
    }else{
        dateLabel.text = [self getFormattedDate:endDateStr withStartDate:startDateStr];
        progressBar.progress = [self getProgressValue:startDateStr withEndDate:endDateStr];
    }
    
    if([[Helper sharedInstance] checkForNull:currentCategory])
    {
        descriptionLabel.text = @"";
    }else
    {
        descriptionLabel.text = NSLocalizedStringFromTableInBundle(currentCategory, nil, [[Helper sharedInstance] getLocalBundle], nil);
        
        if([currentCategory isEqualToString:@"Smartphone"])
        {
            logoImageView.image = [UIImage imageNamed:@"premium_plan"];
            renewButton.hidden = [[Helper sharedInstance] shouldShowRenewButton:contentArray withCurrentDict:dict];
        }else{
            logoImageView.image = [UIImage imageNamed:@"tablet_plan"];
            renewButton.hidden = YES;
        }
    }
    
    NSString *status =  [dict objectForKey:@"cf_1965"];
    
    if([[Helper sharedInstance] checkForNull:status])
    {
        statusLabel.text = @"NA";
    }else
    {
        if([status isEqualToString:@"POLICY-Current"])
        {
            NSDateFormatter *f = [[NSDateFormatter alloc] init];
            [f setDateFormat:@"yyyy-MM-dd"];

            NSDate *startDate = [f dateFromString:startDateStr];

            [self checkStartDate:startDate];
            
            if(!isPolicyLive)
            {
                statusLabel.text = @"POLICY-Renewal";
            }else
            {
                statusLabel.text = status;
            }
        }else
        {
            statusLabel.text = status;
        }
    }
    
    planLabel.text = planNameStr;
    

}

-(CGFloat)getProgressValue:(NSString *)startDateStr withEndDate:(NSString *)endDateStr
{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [f dateFromString:startDateStr];
    NSDate *endDate = [f dateFromString:endDateStr];
    

    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *totalDays = [gregorianCalendar components:NSCalendarUnitDay
                                                       fromDate:startDate
                                                         toDate:endDate
                                                        options:0];
    
    NSDateComponents *remainingDays = [gregorianCalendar components:NSCalendarUnitDay
                                                           fromDate:[NSDate date]
                                                             toDate:endDate
                                                            options:0];
    
    CGFloat totalDay ,currentDays,progressValue;
    totalDay = [totalDays day];
    currentDays = [remainingDays day];
    progressValue = currentDays/totalDay;
    
    if (progressValue==0)
        progressValue = 1;
    else
        progressValue = 1 - progressValue;
    
    return progressValue;
}

-(NSString *)getFormattedDate:(NSString *)endDateStr withStartDate:(NSString *)startDateStr
{
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat: @"yyyy/MM/dd"];
    
    NSDate *endDate = [dateformate dateFromString:endDateStr];
    NSDate *startDate = [dateformate dateFromString:startDateStr];

    [dateformate setDateFormat:@"dd MMMM yyyy"];
    
    NSString *displayEndDate = [dateformate stringFromDate:endDate]; // Convert date to string
    NSString *displayStartDate = [dateformate stringFromDate:startDate]; // Convert date to string

    NSString *returnStr =  [NSString stringWithFormat:@"%@ - %@",displayStartDate,displayEndDate];
   
    return returnStr;
}

- (NSInteger)checkStartDate:(NSDate *)startDate{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *remainingDays = [gregorianCalendar components:NSCalendarUnitDay
                                                           fromDate:[NSDate date]
                                                             toDate:startDate
                                                            options:0];
    
    NSInteger remainDays = [remainingDays day];
    
    if(remainDays <= 0){
        isPolicyLive = YES;
    }else{
        isPolicyLive = NO;
    }
    
    return remainDays;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
