//
//  EyeMemoryViewController.h
//  SCLTest
//
//  Created by xtrrsg on 13-7-4.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHClient.h"

@interface HHEyeMemoryViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>

@property (retain, nonatomic) IBOutlet UILabel *CorrectLable;
@property (retain, nonatomic) IBOutlet UIButton *testBtn;
@property (retain, nonatomic) HHClient *client;

- (IBAction)TestBtnPressed:(id)sender;

@end
