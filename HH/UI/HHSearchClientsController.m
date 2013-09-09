//
//  HHSearchClientsController.m
//  HH
//
//  Created by xtrrsg on 13-9-7.
//  Copyright (c) 2013年 鸿鹤抗衰老. All rights reserved.
//

#import "HHSearchClientsController.h"
#import "HHUtils.h"

@interface HHSearchClientsController ()

@end

@implementation HHSearchClientsController

@synthesize mainView;

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"提交" style: UIBarButtonItemStyleBordered target:self action:@selector(search)];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSMonthCalendarUnit|NSYearCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    
    components.month = components.month - 1;
    
    _regTimeStart.date = [cal dateFromComponents:components];
    _regTimeEnd.date = [NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [_regTimeStart release];
    [_regTimeEnd release];
    [_name release];
    [_clientId release];
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{

}

-(void)search
{
    if(nil != _name.text && _name.text.length > 0)
    {
        [mainView.searchCondition setObject:_name.text forKey:@"name"];
    }
    
    if(nil != _clientId.text && _clientId.text.length > 0)
    {
        [mainView.searchCondition setObject:_clientId.text forKey:@"id"];
    }
    
    [mainView.searchCondition setObject:[HHUtils formatDate:_regTimeStart.date] forKey:@"RegTimeStart"];
    [mainView.searchCondition setObject:[HHUtils formatDate:_regTimeEnd.date] forKey:@"RegTimeEnd"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setRegTimeStart:nil];
    [self setRegTimeEnd:nil];
    [self setName:nil];
    [self setClientId:nil];
    [super viewDidUnload];
}
@end
