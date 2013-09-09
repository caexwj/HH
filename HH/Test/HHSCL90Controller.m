//
//  HHSCL90Controller.m
//  HH
//
//  Created by xtrrsg on 13-9-8.
//  Copyright (c) 2013年 鸿鹤抗衰老. All rights reserved.
//

#import "HHSCL90Controller.h"
#import "VCRadioButton.h"
#import "HttpUtils.h"
#import "HHHttpInterface.h"

@interface HHSCL90Controller ()

@property (nonatomic, retain) UITableView * tableview;
@property (nonatomic, retain )NSMutableArray * question;  //题目
@property (nonatomic, retain) NSMutableArray * answer;    //选项
@property (nonatomic, retain) NSXMLParser *parserXML;
@property (nonatomic, retain) NSMutableDictionary *dic;
@property (nonatomic, retain) NSData *xmlData;
@property (nonatomic, retain) NSString * keyName;
@property (nonatomic, retain) NSDictionary * atribute;
@property (nonatomic, retain) NSMutableArray *answeritemtitle;

@property BOOL itemMark;
@property BOOL itemAllkey;
@property BOOL itemRow;

@end

@implementation HHSCL90Controller

@synthesize client;

@synthesize tableview;
@synthesize parserXML;
@synthesize question;
@synthesize answer;
@synthesize dic;
@synthesize xmlData;

@synthesize keyName;
@synthesize atribute;
@synthesize itemMark;
@synthesize itemAllkey;
@synthesize itemRow;
@synthesize answeritemtitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"SCL90测试";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"提交" style: UIBarButtonItemStyleBordered target: self action:@selector(submitPressed)];
    
    self.question = [[NSMutableArray alloc] initWithCapacity:90];
    self.answer = [[NSMutableArray alloc] initWithCapacity:90];
    
    dic = [[NSMutableDictionary alloc] initWithCapacity:90];

    //
    //从资源文件中获取images.xml文件
	NSString *strPathXml = [[NSBundle mainBundle] pathForResource:@"resource.bundle/SCL90" ofType:@"xml"];
	
	//将xml文件转换成data类型
	xmlData = [[NSData alloc] initWithContentsOfFile:strPathXml];
	
	//初始化待解析的xml
	self.parserXML = [[NSXMLParser alloc] initWithData:xmlData];
    self.parserXML.delegate = self;
    [self.parserXML parse];
    
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
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
    [question release];
    [tableview release];
    [answer release];
    [parserXML release];
}

-(void)submitPressed
{
    if ([dic count] < 90)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查是否有没选中的" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
    }
    else
    {
        NSMutableString * str = [[NSMutableString alloc] init];

        for(int i = 0; i< [question count] ;i++){
            NSString * groupname = [question objectAtIndex:i];
            NSString * strdoc = [dic objectForKey:groupname];
            [str appendString:[NSString stringWithFormat:@"%@,",strdoc]];
        }
        
        NSString * message = [NSString stringWithFormat:@"{\"patientId\":\"%@\", \"scl\":\"%@\"}", client.clientId,[str substringToIndex:([str length]-1)]];
        HttpUtils *http = [[HttpUtils alloc] initWithURL:[HHHttpInterface SCL90]];
        
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

#pragma mark -
//遍例xml的节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict
{
    // entry: { id (link), im:name (app name), im:image (variable height) }
    itemAllkey = YES;//标记起始
    
    keyName = elementName;
    atribute = attributeDict;
    //判断elementName与Item是否相等
    if ([elementName isEqualToString:@"Item"])
	{
        //相等的话,重新初始化workingEntry
        itemMark = YES;//标记item开始
        
    }
    if ([elementName isEqualToString:@"Row"]) {
        itemRow = YES;
    }
}

//节点有值则调用此方法
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{   
    if (itemAllkey) {
        if (itemMark) {
            if ([keyName isEqualToString:@"Item"]) {
                NSString * title = [atribute objectForKey:@"Name"];
                [self.question addObject:title];
                answeritemtitle = [[NSMutableArray alloc] initWithCapacity:5];
            }
            
        }
        
    }
}

//当遇到结束标记时，进入此句
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"Item"])
	{
        [self.answer addObject:answeritemtitle];
        [answeritemtitle release];
        itemMark = NO;
    }
    if ([elementName isEqualToString:@"Row"])
    {
        [answeritemtitle addObject:[atribute objectForKey:@"Value"]];
        itemRow = NO;
    }
    
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.tableview reloadData];
}

#pragma mark -
#pragma mark Table view data source
//-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    //    return [self setupViews];
//    return nil;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView * footview = [[UIView alloc] init];
//    footview.backgroundColor = [UIColor blueColor];
//    return footview;
//}

#define TEXT_HEIGHT 40
#define TEXT_RECT_HEIGHT (TEXT_HEIGHT + 6)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return TEXT_RECT_HEIGHT * 6 + 10;
    
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [question count];
    
    
}// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone; //这句话决定了cell选中时候背景不变蓝
        
    }
    if ([question count]>0) {
        NSString * questiongstr = [question objectAtIndex:indexPath.row];
        
        int tableWidth = [tableView frame].size.width;
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(10, 5, tableWidth - 10, TEXT_RECT_HEIGHT * 6)];
        container.backgroundColor = [UIColor whiteColor];
        
        UILabel *questionText = [[UILabel alloc] initWithFrame:CGRectMake(0,0,container.frame.size.width,TEXT_RECT_HEIGHT)];
        questionText.backgroundColor = [UIColor clearColor];
        questionText.text = questiongstr;
        questionText.font = [UIFont fontWithName:@"Arial" size:TEXT_HEIGHT];
        [container addSubview:questionText];
        
        RadioButtonControlSelectionBlock selectionBlock = ^(VCRadioButton *radioButton){
            if (radioButton.groupName){
                [dic setObject:radioButton.selectedValue forKey:radioButton.groupName];
            }
        };
        
        VCRadioButton *selRadio = nil;
        
        NSMutableArray * answerarray = [answer objectAtIndex:indexPath.row];
        for (int i = 0; i< [answerarray count]; i++) {
            VCRadioButton *group1RadioButton = [[VCRadioButton alloc] initWithFrame:CGRectMake(10,TEXT_RECT_HEIGHT *(i+1), TEXT_RECT_HEIGHT,TEXT_RECT_HEIGHT)];
            group1RadioButton.groupName = questiongstr;
            group1RadioButton.selectedValue = [NSString stringWithFormat:@"%d",i];
            group1RadioButton.selectionBlock = selectionBlock;
            
            [container addSubview:group1RadioButton];
            
            NSString *selValue = [dic objectForKey:group1RadioButton.groupName];
            
            if(nil != selValue)
            {
                NSComparisonResult result = [selValue compare:(NSString*)group1RadioButton.selectedValue];
                //group1RadioButton.selected = result == NSOrderedSame;
                if(result == NSOrderedSame)
                {
                    selRadio = group1RadioButton;
                }
            }
            
            UILabel *label1 =[[UILabel alloc] initWithFrame:CGRectMake(10 + group1RadioButton.frame.size.width + group1RadioButton.frame.origin.x, TEXT_RECT_HEIGHT * (i+1), container.frame.size.width - group1RadioButton.frame.origin.x - group1RadioButton.frame.size.width, TEXT_RECT_HEIGHT)];
            label1.backgroundColor = [UIColor clearColor];
            label1.text = [answerarray objectAtIndex:i];
            label1.font = [UIFont fontWithName:@"Arial" size:TEXT_HEIGHT];
            [container addSubview:label1];
            [label1 release];
            
            [group1RadioButton release];
        }
        
        if(nil != selRadio)
        {
            selRadio.selected = YES;
        }
        
        [cell.contentView addSubview:container];
    }
    
    return cell;
}

@end
