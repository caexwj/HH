//
//  HHClient.h
//  HH
//
//  Created by xtrrsg on 13-9-7.
//  Copyright (c) 2013年 鸿鹤抗衰老. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHClient : NSObject

@property (retain) NSString *name;
@property (retain) NSNumber *sex;
@property (retain) NSNumber *smoker;
@property (retain) NSString *clientId;
@property (retain) NSDate *regTime;
@property (retain) NSString *bornCity;
@property (retain) NSString *liveCity;
@property (retain) NSString *company;
@property (retain) NSString *job;
@property (retain) NSString *address;
@property (retain) NSString *phone;
@property (retain) NSDate *checkDate;
@property (retain) NSDate *born;

-(NSString*) getSexAsString;
-(NSString*) GetSmokerAsString;
-(int) getAge;
-(NSDictionary*) ToJson;

+(HHClient*) FromJson:(NSDictionary *)json;

@end
