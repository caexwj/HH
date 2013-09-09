//
//  HHTestItemsViewController.h
//  HH
//
//  Created by xtrrsg on 13-9-8.
//  Copyright (c) 2013年 鸿鹤抗衰老. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHClient.h"

@interface HHTestItemsViewController : UIViewController

@property (retain) HHClient *client;

- (IBAction)testBtnPressed:(id)sender;

@end
