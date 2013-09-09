//
//  HttpUtils.m
//  SCLTest
//
//  Created by xtrrsg on 13-7-26.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "HttpUtils.h"
#import "JSONKit.h"

static NSString *rootUrl = nil;
static NSString *userName = nil;
static NSString *password = nil;

@interface HttpUtils ()

@property NSMutableDictionary *fields;
@property NSString *url;

@end

@implementation HttpUtils

@synthesize fields;
@synthesize url;

+(void)destroy
{
    if(nil != rootUrl)
    {
        [rootUrl release];
    }
    
    if(nil != userName)
    {
        [userName release];
    }
    
    if(nil != password)
    {
        [password release];
    }
}

+(void) setUserName:(NSString *)UserName Password:(NSString*)Password
{
    if(nil != userName)
    {
        [userName release];
    }
    
    if(nil != password)
    {
        [password release];
    }
    
    userName = [[NSString alloc] initWithString:UserName];
    password = [[NSString alloc] initWithString:Password];
}

+(void) setRootUrlAndPort:(NSString *)root :(NSString*)port
{
    // 修补http开头
    NSRange range = NSMakeRange(0, 7);  // 7 == strlen(http://)
    NSMutableString *tempUrl = nil;
    
    if(NSOrderedSame != [root compare:@"http://" options:0 range:range])
    {
        tempUrl = [[NSMutableString alloc] initWithFormat:@"http://%@", root];
    }
    else
    {
        tempUrl = [[NSMutableString alloc] initWithString:root];
    }
    
    // 修补:
    if( ':' != [tempUrl characterAtIndex:(tempUrl.length - 1)] )
    {
        [tempUrl appendString:@":"];
    }
    
    // 拼接port
    [tempUrl appendString:port];

    // 修补/
    if( '/' != [tempUrl characterAtIndex:(tempUrl.length - 1)] )
    {
        [tempUrl appendString:@"/"];
    }

    // 拼接根接口
    [tempUrl appendString:@"HH/"];
    
    if(nil != rootUrl)
    {
        [rootUrl release];
    }

    rootUrl = [[NSString alloc] initWithString:tempUrl];
    
    [tempUrl release];
}

+(BOOL) isError:(NSDictionary *)dic error:(NSString **)error
{
    NSNumber *number = [dic objectForKey:@"success"];
    
    if([number intValue] == 0)
    {
        *error = (NSString *)[dic objectForKey:@"errorMessage"];
        
        return YES;
    }
    
    return NO;
}

-(HttpUtils*)initWithURL:(NSString *)requestUrl
{
    url = [NSString stringWithFormat:@"%@%@", rootUrl, requestUrl];
    
    // init and add default fields
    fields = [NSMutableDictionary dictionaryWithObjectsAndKeys:userName, @"userName", password, @"password", nil];
    
    return self;
}

-(void)AddGetData:(NSString *)field :(NSString*)value
{
    [fields setObject:value forKey:field];
}

-(NSDictionary *) Get
{    
    NSArray *allKeys = [fields allKeys];
    NSMutableString *requestUrl = [[NSMutableString alloc] initWithString:url];

    if(nil != allKeys && allKeys.count > 0)
    {
        [requestUrl appendString:@"?"];
        
        for(int i = 0; i < allKeys.count; i++)
        {
            NSString *field = [allKeys objectAtIndex:i];
            NSString *value = [fields objectForKey:field];
            
            [requestUrl appendFormat:@"%@=%@", field, value];
            
            if(i != allKeys.count - 1)
            {
                [requestUrl appendString:@"&"];
            }
        }
    }

    NSLog(@"http request: %@", requestUrl);
    
    NSString *utf8Url= [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *http = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:utf8Url]];
    
    [http addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [http setTimeoutInterval:10];
    [http setHTTPMethod:@"GET"];
    
    NSURLResponse *res = nil;
    NSError *err = nil;
    NSData *receiveData = [NSURLConnection sendSynchronousRequest:http returningResponse:&res error:&err];
    NSString *receiveJson = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
    NSDictionary *json = [receiveJson objectFromJSONStringWithParseOptions:JKParseOptionValidFlags];
    
    NSLog(@"http receive: %@",receiveJson);
    
    [receiveJson release];
    [requestUrl release];
    
    return json;
}

-(void)release
{
    [super release];
}



@end
