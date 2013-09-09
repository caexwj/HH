//
//  HttpUtils.h
//  SCLTest
//
//  Created by xtrrsg on 13-7-26.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HttpUtils : NSObject

+(void) setRootUrlAndPort:(NSString *)requestUrl :(NSString*)port;
+(void) setUserName:(NSString *)UserName Password:(NSString*)Password;

+(BOOL) isError:(NSDictionary *)dic error:(NSString **)error;

-(void)AddGetData:(NSString *)field :(NSString*)value;
-(NSMutableDictionary *) Get;

// init and destroy
-(HttpUtils*)initWithURL:(NSString *)requestUrl;
-(void)release;
+(void)destroy;

@end
