//
//  ResponseSpeedController.m
//  SCLTest
//
//  Created by xtrrsg on 13-7-25.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "HHResponseSpeedController.h"
#import "HttpUtils.h"
#import "JSONKit.h"
#import "HHHttpInterface.h"

#define MAX_TEST 3

@interface HHResponseSpeedController ()

@property NSTimer *timer;      // 测试计时器
@property NSDate *startTime;   // 开始测试时间
@property NSMutableArray *testScore;  // 测试结果
@property BOOL drawGreen;
@property NSMutableArray *timerLables;
@property int curIndex;

@end

@implementation HHResponseSpeedController

@synthesize timer;
@synthesize startTime;
@synthesize testScore;
@synthesize startBtn;
@synthesize stopBtn;
@synthesize responseBtn;
@synthesize drawGreen;
@synthesize time1;
@synthesize time2;
@synthesize time3;
@synthesize timeAverage;
@synthesize timerLables;
@synthesize retestBtn;
@synthesize curIndex;
@synthesize client;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    drawGreen = NO;
    
    testScore = [[NSMutableArray alloc] init];
    
    [testScore addObject:[[NSNumber alloc] initWithDouble:0]];
    [testScore addObject:[[NSNumber alloc] initWithDouble:0]];
    [testScore addObject:[[NSNumber alloc] initWithDouble:0]];
    
    timerLables = [[NSMutableArray alloc] init];
    
    [timerLables addObject:time1];
    [timerLables addObject:time2];
    [timerLables addObject:time3];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    
    [self SwitchGreenBlock:NO];
    [self SwitchTest:NO];
    [self ResetTest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)send{

    if (curIndex != MAX_TEST)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请做完测试再提交数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return;
    }
    
    NSMutableDictionary *requestData = [[NSMutableDictionary alloc] init];
    
    [requestData setObject:[testScore objectAtIndex:0] forKey:@"t1"];
    [requestData setObject:[testScore objectAtIndex:1] forKey:@"t2"];
    [requestData setObject:[testScore objectAtIndex:2] forKey:@"t3"];
    [requestData setObject:client.clientId forKey:@"patientId"];
    
    NSString *requestJson = [requestData JSONString];
    HttpUtils *http = [[HttpUtils alloc] initWithURL:[HHHttpInterface ResponseSpeed]];

    [http AddGetData:@"json" :requestJson];
    
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

- (IBAction)PressRetest:(id)sender {

    [self ResetTimer:YES];
    [self ResetTest];
    [self SwitchGreenBlock:NO];
    [self SwitchTest:YES];
}

- (IBAction)PressStartTest:(id)sender {
    
    if (curIndex >= MAX_TEST)
    {
        [self ResetTest];
    }
    
    [self SwitchTest:YES];
    [self SwitchGreenBlock:NO];
    [self ResetTimer:YES];
}

- (IBAction)PressStopTest:(id)sender {
    
    [self ResetTimer:NO];
    [self SwitchTest:NO];
    [self SwitchGreenBlock:NO];
}

- (IBAction)PressResponse:(id)sender {
    
    if (drawGreen)
    {
        [self ResetTimer:NO];
        [self SwitchGreenBlock:NO];
        [self SwitchTest:NO];
        
        NSDate *now = [[NSDate alloc]init];
        double interval = [now timeIntervalSinceDate:startTime];
        
        [testScore replaceObjectAtIndex:curIndex withObject:[[NSNumber alloc] initWithInt:(int)(interval * 1000)]];
        NSString *lableText = [NSString stringWithFormat:@"第%d次时间: %f", curIndex + 1, interval];
        
        UILabel *lable = [timerLables objectAtIndex:curIndex];
        [lable setText:lableText];
            
        curIndex++;
            
        float total = 0;
            
        for (int i = 0; i < curIndex; i++)
        {
            total += [((NSNumber *)[testScore objectAtIndex:i]) intValue];
        }
        
        [timeAverage setText:[NSString stringWithFormat:@"平均时间: %0.3f", total / 1000 / curIndex]];
        
        [self SwitchTest:NO];
    }
}

-(void) SwitchTest:(BOOL)startTest
{
    startBtn.enabled = !startTest;
    retestBtn.enabled = startTest;
    stopBtn.enabled = startTest;
}

-(void) SwitchGreenBlock:(BOOL)draw
{
    drawGreen = draw;
    
    if(draw)
    {
        //[responseBtn setBackgroundColor:[UIColor greenColor]];
        [responseBtn setTitle:@"点我" forState:UIControlStateNormal];
        responseBtn.enabled = YES;
    }
    else
    {
        //[responseBtn setBackgroundColor:[UIColor whiteColor]];
        [responseBtn setTitle:@"" forState:UIControlStateDisabled];
        responseBtn.enabled = NO;
    }

}

-(void) ResetTest
{
    curIndex = 0;
    
    for (int i = 0; i < MAX_TEST; i++)
    {
        UILabel *lable = [timerLables objectAtIndex:i];
        
        [lable setText:[NSString stringWithFormat:@"第%d次时间: ", i + 1]];
        [testScore replaceObjectAtIndex:i withObject:[[NSNumber alloc] initWithInt:0]];
    }
    
    [timeAverage setText:@"平均时间: "];
}

-(void) ResetTimer:(BOOL)start
{    
    int second = arc4random() % 10 + 1;
    
    if(start)
    {
         timer = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(TimerHandler) userInfo:nil repeats:NO];   
    }
}

-(void)TimerHandler{
    //[self ResetTimer:NO];
    [self SwitchGreenBlock:YES];
    
    startTime = [[NSDate alloc] init];
}

- (void)dealloc {
    [stopBtn release];
    [retestBtn release];
    [startBtn release];
    [responseBtn release];
    [time2 release];
    [time1 release];
    [timeAverage release];
    [time3 release];
    [client release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setStartBtn:nil];
    [self setRetestBtn:nil];
    [self setStopBtn:nil];
    [self setStopBtn:nil];
    [self setRetestBtn:nil];
    [self setStartBtn:nil];
    [self setResponseBtn:nil];
    [self setTime1:nil];
    [self setTime2:nil];
    [self setTime1:nil];
    [self setTimeAverage:nil];
    [self setTime3:nil];
    [super viewDidUnload];
}


@end
