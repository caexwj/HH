//
//  HHPittsburghController.m
//  HH
//
//  Created by xtrrsg on 13-9-8.
//  Copyright (c) 2013年 鸿鹤抗衰老. All rights reserved.
//

#import "HHPittsburghController.h"
#import "HHHttpInterface.h"
#import "HttpUtils.h"
#import "HHUtils.h"
#import "GDataXMLNode.h"
#import "VCRadioButton.h"
#import "JSONKit.h"

// 问题结构
@interface Question : NSObject

@property (retain) NSString *question;  // 问题
@property (retain) NSMutableArray *answer;  // 答案
@property (retain) NSString *addText;   // 补充说明
@property int sel;
@property (assign) UITextField *text;

@end

@implementation Question

@synthesize question;
@synthesize answer;
@synthesize addText;
@synthesize sel;
@synthesize text;

-(void)dealloc
{
    [super dealloc];
    
    [question release];
    [answer release];  // 答案
    [addText release];   // 补充说明
}

-(id)init
{
    [super init];
    
    answer = [[NSMutableArray alloc] init];
    
    return self;
}

-(id)initWidthQuestion:(NSString *)q AddText:(NSString*)add
{
    [super init];
    
    question = q;
    addText = add;
    
    return self;
}

@end

@interface HHPittsburghController ()

@property (retain) NSMutableArray *questionArray;
@property (retain) UITableView *table;


@end

@implementation HHPittsburghController

@synthesize questionArray;
@synthesize client;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [_table reloadData];
}

#define TEXT_HEIGHT 40
#define TEXT_RECT_HEIGHT (TEXT_HEIGHT + 6)

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"匹兹堡睡眠测试";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"提交" style: UIBarButtonItemStyleBordered target: self action:@selector(submitPressed)];
    
    questionArray = [[NSMutableArray alloc] init];
    
    // 这一部分写死的    
    [questionArray addObject:[[Question alloc] initWidthQuestion:@"近1个月，晚上上床睡觉通常是(24小时制时间)" AddText:@"24小时制时间"]];
    [questionArray addObject:[[Question alloc] initWidthQuestion:@"近1个月，从上床到入睡通常需要(分钟)" AddText:@"分钟"]];
    [questionArray addObject:[[Question alloc] initWidthQuestion:@"近1个月，早上通常起床时间(24小时制时间)" AddText:@"24小时制时间"]];
    [questionArray addObject:[[Question alloc] initWidthQuestion:@"近1个月，每夜通常实际睡眠时间(不等于卧床时间，单位：小时)" AddText:@"小时"]];
    
    //从资源文件中获取images.xml文件
	NSString *strPathXml = [[NSBundle mainBundle] pathForResource:@"resource.bundle/Pittsburgh" ofType:@"xml"];
	NSData *xmlData = [[NSData alloc] initWithContentsOfFile:strPathXml];
	
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    GDataXMLElement *root = [xmlDoc rootElement];
    GDataXMLElement *items = [[root elementsForName:@"Items"] objectAtIndex:0];
    
    NSArray *itemArray = [items elementsForName:@"Item"];
    
    for (GDataXMLElement *item in itemArray)
    {
        Question *q = [[Question alloc] init];
        NSArray *array = [item elementsForName:@"Row"];

        q.question = [[item attributeForName:@"Name"] stringValue];
        
        GDataXMLNode *add = [item attributeForName:@"AdditionalLable"];
        
        if(nil != add)
        {
            q.addText = [add stringValue];
        }
        
        for (GDataXMLElement *row in array)
        {
            [q.answer addObject:[[row attributeForName:@"Value"] stringValue]];
        }
        
        [questionArray addObject:q];
    }
    
    [xmlData release];
    [xmlDoc release];
    
    [self initScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [questionArray release];
    
    [_scrollView release];
    [super dealloc];
    
    [client release];
}

-(void)submitPressed
{        
    if (![HHUtils veryfi24HourTime:((Question *)[questionArray objectAtIndex:0]).text.text]
        || ![HHUtils veryfi24HourTime:((Question *)[questionArray objectAtIndex:2]).text.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"时间格式必须是24小时制式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
        [alert show];
        [alert release];
            
        return ;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
    [dic setObject:((Question *)[questionArray objectAtIndex:0]).text.text forKey:@"sleepTime"];
    [dic setObject:((Question *)[questionArray objectAtIndex:2]).text.text forKey:@"wakeUpTime"];
    [dic setObject:((Question *)[questionArray objectAtIndex:1]).text.text forKey:@"needSleep"];
    [dic setObject:((Question *)[questionArray objectAtIndex:3]).text.text forKey:@"realSleep"];
    
    [dic setObject:[NSNumber numberWithInt:((Question *)[questionArray objectAtIndex:4]).sel] forKey:@"hardToSleep"];
    [dic setObject:[NSNumber numberWithInt:((Question *)[questionArray objectAtIndex:5]).sel] forKey:@"easyToWakeUp"];
    [dic setObject:[NSNumber numberWithInt:((Question *)[questionArray objectAtIndex:6]).sel] forKey:@"wc"];
    [dic setObject:[NSNumber numberWithInt:((Question *)[questionArray objectAtIndex:7]).sel] forKey:@"breath"];
    [dic setObject:[NSNumber numberWithInt:((Question *)[questionArray objectAtIndex:8]).sel] forKey:@"snoring"];
    [dic setObject:[NSNumber numberWithInt:((Question *)[questionArray objectAtIndex:9]).sel] forKey:@"cold"];
    [dic setObject:[NSNumber numberWithInt:((Question *)[questionArray objectAtIndex:10]).sel] forKey:@"hot"];
    [dic setObject:[NSNumber numberWithInt:((Question *)[questionArray objectAtIndex:11]).sel] forKey:@"nightmare"];
    [dic setObject:[NSNumber numberWithInt:((Question *)[questionArray objectAtIndex:12]).sel] forKey:@"pain"];
    [dic setObject:[NSNumber numberWithInt:((Question *)[questionArray objectAtIndex:13]).sel] forKey:@"otherSel"];
    [dic setObject:((Question *)[questionArray objectAtIndex:13]).text.text forKey:@"other"];
    [dic setObject:[NSNumber numberWithInt:((Question *)[questionArray objectAtIndex:14]).sel] forKey:@"sleepQuailty"];
    [dic setObject:[NSNumber numberWithInt:((Question *)[questionArray objectAtIndex:15]).sel] forKey:@"medicine"];
    [dic setObject:[NSNumber numberWithInt:((Question *)[questionArray objectAtIndex:16]).sel] forKey:@"tire"];
    [dic setObject:[NSNumber numberWithInt:((Question *)[questionArray objectAtIndex:17]).sel] forKey:@"sleepy"];

    [dic setObject:client.clientId forKey:@"patientId"];
    
    HttpUtils *http = [[HttpUtils alloc] initWithURL:[HHHttpInterface Pittsburgh]];
    
    [http AddGetData:@"json" :[dic JSONString]];
    
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

-(void)initScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.scrollEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = YES;
    
    [self.view addSubview:_scrollView];
    
    int prevHeight = 0;
    
    for (int j = 0; j < questionArray.count; j++)
    {
        Question *q = [questionArray objectAtIndex:j];
        int tableWidth = _scrollView.frame.size.width;
        int height = [self containerHeight:j];
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(10, prevHeight, tableWidth - 10, height)];
        
        container.backgroundColor = [UIColor whiteColor];
        
        UILabel *questionText = [[UILabel alloc] initWithFrame:CGRectMake(0,0,container.frame.size.width,TEXT_RECT_HEIGHT)];
        
        questionText.backgroundColor = [UIColor clearColor];
        questionText.text = q.question;
        questionText.font = [UIFont fontWithName:@"Arial" size:TEXT_HEIGHT];
        
        [container addSubview:questionText];
        
        RadioButtonControlSelectionBlock selectionBlock = ^(VCRadioButton *radioButton)
        {
            Question *qu = [questionArray objectAtIndex:radioButton.tag];
            
            qu.sel = [radioButton.selectedValue intValue];
        };
        
        for (int i = 0; i < q.answer.count; i++)
        {
            VCRadioButton *group1RadioButton = [[VCRadioButton alloc] initWithFrame:CGRectMake(10,TEXT_RECT_HEIGHT *(i+1), TEXT_RECT_HEIGHT,TEXT_RECT_HEIGHT)];
            
            group1RadioButton.groupName = q.question;
            group1RadioButton.selectedValue = [NSString stringWithFormat:@"%d",i];
            group1RadioButton.selectionBlock = selectionBlock;
            group1RadioButton.tag = j;
            
            [container addSubview:group1RadioButton];
            
            UILabel *label1 =[[UILabel alloc] initWithFrame:CGRectMake(10 + group1RadioButton.frame.size.width + group1RadioButton.frame.origin.x, TEXT_RECT_HEIGHT * (i+1), container.frame.size.width - group1RadioButton.frame.origin.x - group1RadioButton.frame.size.width, TEXT_RECT_HEIGHT)];
            
            label1.backgroundColor = [UIColor clearColor];
            label1.text = [q.answer objectAtIndex:i];
            label1.font = [UIFont fontWithName:@"Arial" size:TEXT_HEIGHT];
            
            [container addSubview:label1];
            [label1 release];
            
            [group1RadioButton release];
        }
        
        if(nil != q.addText)
        {
            UITextField *addText = [[UITextField alloc] initWithFrame:CGRectMake( 10, TEXT_RECT_HEIGHT * (q.answer.count + 1), container.frame.size.width - 10, TEXT_RECT_HEIGHT)];
            
            addText.font = [UIFont fontWithName:@"Arial" size:TEXT_HEIGHT];
            addText.placeholder = q.answer.count != 0 ? @"请写明：" : q.addText;
            addText.tag = j;
            q.text = addText;
            
            [container addSubview:addText];
            [addText release];
        }
        
        [_scrollView addSubview:container];
        
        prevHeight += height;
    }
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, prevHeight + 30);
}

- (int)containerHeight:(int)index
{
    Question *q = [questionArray objectAtIndex:index];
    
    int height = TEXT_RECT_HEIGHT;
    
    height += (q.addText == nil ? 0 : TEXT_RECT_HEIGHT);
    height += (q.answer.count == 0 ? 0 : (TEXT_RECT_HEIGHT * q.answer.count));
    
    return height + 10;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
@end
