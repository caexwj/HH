//
//  ResponseSpeedController.h
//  SCLTest
//
//  Created by xtrrsg on 13-7-25.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHClient.h"

@interface HHResponseSpeedController : UIViewController

@property (retain, nonatomic) HHClient *client;

@property (retain, nonatomic) IBOutlet UIButton *stopBtn;
@property (retain, nonatomic) IBOutlet UIButton *retestBtn;
@property (retain, nonatomic) IBOutlet UIButton *startBtn;
@property (retain, nonatomic) IBOutlet UIButton *responseBtn;

@property (retain, nonatomic) IBOutlet UILabel *time1;
@property (retain, nonatomic) IBOutlet UILabel *time2;
@property (retain, nonatomic) IBOutlet UILabel *time3;
@property (retain, nonatomic) IBOutlet UILabel *timeAverage;

- (IBAction)PressRetest:(id)sender;
- (IBAction)PressStartTest:(id)sender;
- (IBAction)PressStopTest:(id)sender;
- (IBAction)PressResponse:(id)sender;

@end
