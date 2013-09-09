//
//  HHTestItemsViewController.m
//  HH
//
//  Created by xtrrsg on 13-9-8.
//  Copyright (c) 2013年 鸿鹤抗衰老. All rights reserved.
//

#import "HHTestItemsViewController.h"
#import "HHSCL90Controller.h"
#import "HHPittsburghController.h"
#import "HHEyeMemoryViewController.h"
#import "HHResponseSpeedController.h"

// 测试按钮的tag
#define SLC90_TAG       0
#define PI_SLEEP        1
#define YEY_MEM         2
#define RESPONSE_SPEED  3

@interface HHTestItemsViewController ()

@end

@implementation HHTestItemsViewController

@synthesize client;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"测试清单";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
    
    [client release];
}

- (IBAction)testBtnPressed:(id)sender
{
    switch (((UIButton*)sender).tag)
    {
        case SLC90_TAG:
        {
            HHSCL90Controller *scl90 = [[HHSCL90Controller alloc] init];
            
            scl90.client = client;
            
            [self.navigationController pushViewController:scl90 animated:YES];
            
            break;
        }
        case PI_SLEEP:
        {
            HHPittsburghController *pittsburgh = [[HHPittsburghController alloc] init];
            
            pittsburgh.client = client;
            
            [self.navigationController pushViewController:pittsburgh animated:YES];
            
            break;
        }
        case YEY_MEM:
        {
            HHEyeMemoryViewController *eye = [[HHEyeMemoryViewController alloc] init];
            
            eye.client = client;
            
            [self.navigationController pushViewController:eye animated:YES];
            
            break;
        }
        case RESPONSE_SPEED:
        {
            HHResponseSpeedController *speed = [[HHResponseSpeedController alloc] init];

            speed.client = client;
            
            [self.navigationController pushViewController:speed animated:YES];
            
            break;
        }
        default:
        {
            break;
        }
    }
}

@end
