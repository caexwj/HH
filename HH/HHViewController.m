//
//  HHViewController.m
//  HH
//
//  Created by xtrrsg on 13-9-7.
//  Copyright (c) 2013年 鸿鹤抗衰老. All rights reserved.
//

#import "HHViewController.h"
#import "HttpUtils.h"
#import "HHHttpInterface.h"
#import "HHMainViewController.h"

@interface HHViewController ()

@property (assign) HHMainViewController *mainView;

@end

@implementation HHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    _mainView = [[HHMainViewController alloc] init];
    self.navigationItem.title = @"登录";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_UserNameText release];
    [_PasswordText release];
    [_IPText release];
    [_PortText release];
    [_mainView release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setUserNameText:nil];
    [self setPasswordText:nil];
    [self setIPText:nil];
    [self setPortText:nil];
    [super viewDidUnload];
}

- (IBAction)LoginPressed:(id)sender
{
    // init http root
    [HttpUtils setRootUrlAndPort:_IPText.text :_PortText.text];
    [HttpUtils setUserName:_UserNameText.text Password:_PasswordText.text];
    
    HttpUtils *http = [[HttpUtils alloc] initWithURL:[HHHttpInterface Login]];
    
    NSDictionary *response = [http Get];
    NSString *error = nil;
    
    if([HttpUtils isError:response error:&error])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
    }
    else
    {
        [self.navigationController pushViewController:_mainView animated:YES];
    }

    [http release];
}

@end
