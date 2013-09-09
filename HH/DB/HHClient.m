//
//  HHClient.m
//  HH
//
//  Created by xtrrsg on 13-9-7.
//  Copyright (c) 2013年 鸿鹤抗衰老. All rights reserved.
//

#import "HHClient.h"
#import "HHUtils.h"

@implementation HHClient

@synthesize name;
@synthesize sex;
@synthesize smoker;
@synthesize clientId;
@synthesize regTime;
@synthesize bornCity;
@synthesize liveCity;
@synthesize company;
@synthesize job;
@synthesize address;
@synthesize phone;
@synthesize checkDate;
@synthesize born;

-(void)dealloc
{
    [super dealloc];
    
    [name release];
    [clientId release];
    [regTime release];
    [bornCity release];
    [liveCity release];
    [company release];
    [job release];
    [address release];
    [phone release];
    [checkDate release];
    [born release];
}

-(NSString*) getSexAsString
{
    return [sex intValue] == 1 ? @"男" : @"女";
}

-(NSString*) GetSmokerAsString
{
    return [smoker intValue]== 1 ? @"是" : @"否";
}

-(int) getAge
{    
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;    
    NSDateComponents *breakdownInfo = [sysCalendar components:flags fromDate:born];
    
    return breakdownInfo.year;
}

-(NSDictionary *) ToJson
{
    NSArray *keysArray = [NSArray arrayWithObjects:
                          @"id",
                          @"name",
                          @"born",
                          @"sex",
                          @"smoker",
                          @"createTime",
                          @"bornCity",
                          @"liveCity",
                          @"company",
                          @"job",
                          @"address",
                          @"phone",
                          @"checkDate",
                          nil];
    
    NSArray *objectsArray = [NSArray arrayWithObjects:
                             clientId,
                             name,
                             [HHUtils formatDate:born],
                             sex,
                             smoker,
                             [HHUtils formatDate:regTime],
                             bornCity,
                             liveCity,
                             company,
                             job,
                             address,
                             phone,
                             [HHUtils formatDate:checkDate],
                             nil];
    
    return [NSDictionary dictionaryWithObjects:objectsArray forKeys:keysArray];
}

+(HHClient*) FromJson:(NSDictionary *)json
{
    HHClient *client = [[HHClient alloc] init];
    
    client.clientId = [json objectForKey:@"id"];
    client.name = [json objectForKey:@"name"];
    client.born = [HHUtils parseDate: [json objectForKey:@"born"]];
    client.sex = [NSNumber numberWithInt:[[json objectForKey:@"sex"] intValue]];
    client.smoker = [NSNumber numberWithInt:[[json objectForKey:@"smoker"] intValue]];
    client.regTime = [HHUtils parseDate: [json objectForKey:@"createTime"]];
    client.bornCity = [json objectForKey:@"bornCity"];
    client.liveCity = [json objectForKey:@"liveCity"];
    client.company = [json objectForKey:@"company"];
    client.job = [json objectForKey:@"job"]; 
    client.address = [json objectForKey:@"address"];
    client.phone = [json objectForKey:@"phone"];
    client.checkDate = [HHUtils parseDate: [json objectForKey:@"checkDate"]];
    
    return client;
}

@end
