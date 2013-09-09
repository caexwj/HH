//
//  HHUtils.h
//  HH
//
//  Created by xtrrsg on 13-9-7.
//  Copyright (c) 2013年 鸿鹤抗衰老. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHUtils : NSObject

+(NSString*) formatDate:(NSDate *)date;
+(NSDate*) parseDate:(NSString *)date;
+(BOOL) veryfi24HourTime:(NSString *)timerString;

@end
