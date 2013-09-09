//
//  EyeMemoryViewController.m
//  SCLTest
//
//  Created by xtrrsg on 13-7-4.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "HHEyeMemoryViewController.h"
#import <UIKit/UIColor.h>
#import "HHHttpInterface.h"
#import "HttpUtils.h"
#import "JSONKit.h"

#define TABLE_CELL_IMAGE_HEIGHT 40

#define STATUS_STOP 0
#define STATUS_TESTING 1

@interface HHEyeMemoryViewController ()

@property int status;
@property NSTimer *timer;
@property NSMutableArray *correctArray;
@property NSMutableArray *pickerArray;

@end

@implementation HHEyeMemoryViewController

@synthesize status;
@synthesize client;
@synthesize timer;

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 4;
}

#define PICKER_HEIGHT 162

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return (self.view.frame.size.width - 40) / 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return PICKER_HEIGHT;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{    
    int pickerWidth = (self.view.frame.size.width - 40) / 2;
    UIView *tmpView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, pickerWidth, PICKER_HEIGHT)] autorelease];
    
    if(0 == row)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerWidth, PICKER_HEIGHT)];
        
        label.text = @"准备";
        label.font = [UIFont fontWithName:@"Arial" size:40];

        [tmpView addSubview:label];
    }
    else
    {
        UIImage *img = [HHEyeMemoryViewController GetColorImage:(row - 1)% 3];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, pickerWidth, PICKER_HEIGHT)];
        
        icon.image = img;
        [tmpView addSubview:icon];
    }

    [tmpView setUserInteractionEnabled:NO];
    [tmpView setTag:row];

    return tmpView;
}

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
    _correctArray = [[NSMutableArray alloc] initWithCapacity:10];
    _pickerArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    
    int pickerWidth = (self.view.frame.size.width - 40) / 2;
    
    for(int i = 0; i < 10; i++)
    {
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame: CGRectMake(i % 2 * pickerWidth + (i % 2 + 1) * 10, (PICKER_HEIGHT + 5) * (i / 2) + 5, pickerWidth, PICKER_HEIGHT)];
        
        picker.delegate = self;
        
        [_pickerArray addObject:picker];
        [self.view addSubview:picker];
    }
    
    [self ResetArray];
    [self SwitchStatus:STATUS_STOP];
}

-(void)RandomButtonColor
{
    for(int i = 0; i < 9; i++)
    {
        _correctArray[i] = [NSNumber numberWithInt:i % 3];
    }
    
    for(int i = 0; i < 9; i++)
    {
        NSNumber *temp = [_correctArray objectAtIndex:i];
        NSNumber *newIndex = [NSNumber numberWithInt:arc4random() % 9];
        
        _correctArray[i] = _correctArray[newIndex.intValue];
        _correctArray[newIndex.intValue] = temp;
    }
    
    _correctArray[9] = [NSNumber numberWithInt:random() % 3];
    
    for(int i = 0; i < 10; i++)
    {
        UIPickerView *picker = [_pickerArray objectAtIndex:i];
        NSNumber *number = [_correctArray objectAtIndex:i];
        
        [picker selectRow:number.intValue + 1 inComponent:0 animated:YES];
        //[picker reloadAllComponents];
    }
}

-(void)StartTest
{
    [self ResetArray];
    [self RandomButtonColor];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(TimerHandler) userInfo:nil repeats:NO];
    
    [self SetPickerEnable:NO];
    _CorrectLable.text = @"正确数:0";
    [self.testBtn setEnabled:NO];
}

-(void)ResetArray
{
    [_correctArray removeAllObjects];
    
    for (int i = 0; i < 10; i++)
    {
        [_correctArray addObject:[NSNumber numberWithInt:-10]];
    }
}

-(void)SetPickerEnable:(BOOL)enable
{
    for(int i = 0; i < 10; i++)
    {
        UIPickerView *picker = [_pickerArray objectAtIndex:i];

        [picker setUserInteractionEnabled:enable];
    }
}

-(void)StopTest
{
    timer = nil;
    
    [self SetPickerEnable:NO];
    _CorrectLable.text = [NSString stringWithFormat:@"正确数:%d", [self correctCount]];
}

-(void)TimerHandler
{
    if(STATUS_TESTING == status)
    {
        for(int i = 0; i < 10; i++)
        {
            UIPickerView *picker = [_pickerArray objectAtIndex:i];
            
            [picker selectRow:0 inComponent:0 animated:YES];
        }
        
        [self SetPickerEnable:YES];
        [self.testBtn setEnabled:YES];
    }
}

- (void)SwitchStatus:(int)newStatus
{
    status = newStatus;
    
    if(STATUS_STOP == status)
    {
        [_testBtn setTitle:@"开始测试" forState:UIControlStateNormal];
        [self StopTest];
    }
    else if(STATUS_TESTING == status)
    {
        [_testBtn setTitle:@"停止测试" forState:UIControlStateNormal];
        [self StartTest];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)send {
    
    if(STATUS_TESTING == status)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先点结束测试再提交" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
    }
    else
    {
        HttpUtils *http = [[HttpUtils alloc] initWithURL:[HHHttpInterface EyeMemory]];

        NSString * message = [NSString stringWithFormat:@"{\"patientId\":\"%@\", \"memory\":\"%d\"}", client.clientId, [self correctCount]];
        
        [http AddGetData:@"json" :message];
        
        NSDictionary *response = [http Get];
        NSString *error = nil;
        
        if([HttpUtils isError:response error:&error])
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)TestBtnPressed:(id)sender
{
    if(STATUS_STOP == status)
    {
        [self SwitchStatus:STATUS_TESTING];
    }
    else if(STATUS_TESTING == status)
    {
        [self SwitchStatus:STATUS_STOP];
    }
}

-(int)correctCount
{
    int count = 0;
    
    for(int i = 0; i < 10; i++)
    {
        UIPickerView *picker = [_pickerArray objectAtIndex:i];
        int sel = [picker selectedRowInComponent:0];
        NSNumber *number = [_correctArray objectAtIndex:i];
        
        if(number.intValue == sel - 1)
        {
            count++;
        }
    }
    
    return count;
}

- (void)dealloc
{
    [_testBtn release];
    [_CorrectLable release];
    [client release];
    [_correctArray release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setTestBtn:nil];
    [self setCorrectLable:nil];
    [super viewDidUnload];
}

+ (UIImage*)GetColorImage:(int)index
{
    UIImage * image = nil;
    
    switch (index)
    {
        case 0:
        {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"resource.bundle/红" ofType:@"png"]];
            
            break;
        }
        case 1:
        {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"resource.bundle/黄" ofType:@"png"]];
            
            break;
        }
        case 2:
        {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"resource.bundle/蓝" ofType:@"png"]];
            
            break;
        }
        default:
        {
            return nil;
        }
    }
    
    return image;
}

@end
