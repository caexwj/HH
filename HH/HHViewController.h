//
//  HHViewController.h
//  HH
//
//  Created by xtrrsg on 13-9-7.
//  Copyright (c) 2013年 鸿鹤抗衰老. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHViewController : UIViewController

// member variables
@property (retain, nonatomic) IBOutlet UITextField *UserNameText;
@property (retain, nonatomic) IBOutlet UITextField *PasswordText;
@property (retain, nonatomic) IBOutlet UITextField *IPText;
@property (retain, nonatomic) IBOutlet UITextField *PortText;

// member methods
- (IBAction)LoginPressed:(id)sender;

@end
