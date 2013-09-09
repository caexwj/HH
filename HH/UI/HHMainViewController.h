//
//  HHMainViewController.h
//  HH
//
//  Created by xtrrsg on 13-9-7.
//  Copyright (c) 2013年 鸿鹤抗衰老. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHMainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (retain) NSMutableDictionary *searchCondition;
@property (retain, nonatomic) IBOutlet UITableView *ClientsTable;

@end
