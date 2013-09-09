//
//  HHSCL90Controller.h
//  HH
//
//  Created by xtrrsg on 13-9-8.
//  Copyright (c) 2013年 鸿鹤抗衰老. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHClient.h"

@interface HHSCL90Controller : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate>

@property (retain) HHClient *client;

@end
