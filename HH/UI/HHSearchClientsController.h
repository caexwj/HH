//
//  HHSearchClientsController.h
//  HH
//
//  Created by xtrrsg on 13-9-7.
//  Copyright (c) 2013年 鸿鹤抗衰老. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHMainViewController.h"

@interface HHSearchClientsController : UIViewController

@property (assign) HHMainViewController *mainView;
@property (retain, nonatomic) IBOutlet UIDatePicker *regTimeStart;
@property (retain, nonatomic) IBOutlet UIDatePicker *regTimeEnd;
@property (retain, nonatomic) IBOutlet UITextField *name;
@property (retain, nonatomic) IBOutlet UITextField *clientId;

@end
