//
//  HHUtils.m
//  HH
//
//  Created by xtrrsg on 13-9-7.
//  Copyright (c) 2013年 鸿鹤抗衰老. All rights reserved.
//

#import "HHUtils.h"

@implementation HHUtils

+(NSDate*) parseDate:(NSString *)date
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *dateValue = [fmt dateFromString:date];
    
    [fmt release];
    
    return dateValue;
}

+(NSString*) formatDate:(NSDate *)date
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *dateValue = [fmt stringFromDate:date];
    
    [fmt release];
    
    return dateValue;
}

+(BOOL) veryfi24HourTime:(NSString *)timerString
{
    NSArray* timerArray = [timerString componentsSeparatedByString: @":"];
    
    if(nil != timerArray && timerArray.count == 3)
    {
        return [[timerArray objectAtIndex:0] intValue] >= 0 && [[timerArray objectAtIndex:0] intValue] < 24
                && [[timerArray objectAtIndex:1] intValue] >= 0 && [[timerArray objectAtIndex:1] intValue] < 60
                && [[timerArray objectAtIndex:2] intValue] >= 0 && [[timerArray objectAtIndex:2] intValue] < 60;
        
    }

    return NO;
}

@end
