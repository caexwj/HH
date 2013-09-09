//
//  HHMainViewController.m
//  HH
//
//  Created by xtrrsg on 13-9-7.
//  Copyright (c) 2013年 鸿鹤抗衰老. All rights reserved.
//

#import "HHMainViewController.h"
#import "HttpUtils.h"
#import "HHHttpInterface.h"
#import "HHClient.h"
#import "HHSearchClientsController.h"
#import "HHTestItemsViewController.h"

@interface HHMainViewController ()

@property (retain) NSMutableArray *clientArray;
@property (retain) HHSearchClientsController *searchView;   // 搜索界面
@property (retain) HHTestItemsViewController *testView;     // 测试菜单界面

//-(void)SearchClientPressed;

@end

@implementation HHMainViewController

@synthesize clientArray;
@synthesize searchCondition;

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
    
    _ClientsTable.delegate = self;
    _ClientsTable.dataSource = self;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"查询客户" style: UIBarButtonItemStyleBordered target: self action:@selector(SearchClientPressed)];
    
    self.navigationItem.rightBarButtonItem = backButton;
    self.navigationItem.title = @"客户列表";
    
    searchCondition = [[NSMutableDictionary alloc] init];
    
    _searchView = [[HHSearchClientsController alloc] init];
    _searchView.mainView = self;
    
    _testView = [[HHTestItemsViewController alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_ClientsTable release];
    [clientArray release];
    [searchCondition release];
    [_searchView release];

    [super dealloc];
}

- (void)viewDidUnload {
    [self setClientsTable:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    HttpUtils *http = [[HttpUtils alloc] initWithURL:[HHHttpInterface QueryClient]];
    
    if(searchCondition.count == 0)
    {
        // 默认搜索今天注册的客户
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        
        [fmt setDateFormat:@"yyyy-MM-dd"];
        
        NSString *regTime = [NSString stringWithFormat:@"%@ 00:00:00", [fmt stringFromDate:[NSDate date]]];
        
        [http AddGetData:@"RegTimeStart" :regTime];
        [fmt release];
    }
    else
    {
        // 设置的搜索条件，搜索之
        NSArray *allKeys = [searchCondition allKeys];
        
        for (NSString *key in allKeys)
        {
            [http AddGetData:key :[searchCondition objectForKey:key]];
        }
        
        [searchCondition removeAllObjects];
    }
    
    NSDictionary *response = [http Get];
    NSString *error = nil;
    
    [http release];
    
    if(nil != clientArray)
    {
        [clientArray removeAllObjects];
    }
    else
    {
        clientArray = [[NSMutableArray alloc] init];
    }
    
    if(![HttpUtils isError:response error:&error])
    {
        NSArray *clientsArray = [response objectForKey:@"clients"];
    
        if(nil != clientsArray)
        {
            for (NSDictionary *json in clientsArray) {
                @try {
                    [clientArray addObject:[HHClient FromJson:json]];
                }
                @catch (NSException *exception) {
                    continue;
                }
            }
        }
    }
    
    [_ClientsTable reloadData];
}

#pragma mark Table view data source

#define TEXT_HEIGHT 18
#define TEXT_RECT_HEIGHT (TEXT_HEIGHT + 10)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TEXT_RECT_HEIGHT;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [clientArray count] + 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = indexPath.row == 0 ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDetailDisclosureButton;
        cell.selectionStyle = indexPath.row == 0 ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleBlue;
    }
    
    // table header order
    // ----id----name----sex----age----
    UILabel *clientId = nil;
    UILabel *name = nil;
    UILabel *sex = nil;
    UILabel *age = nil;
    
    int idWidth = 200;
    int nameWidth = 200;
    int sexWidth = 100;
    int ageWidth = tableView.frame.size.width - idWidth - nameWidth - sexWidth;

    clientId = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, idWidth, TEXT_RECT_HEIGHT)];
    name = [[UILabel alloc] initWithFrame:CGRectMake(idWidth, 0, nameWidth, TEXT_RECT_HEIGHT)];
    sex = [[UILabel alloc] initWithFrame:CGRectMake(idWidth + nameWidth, 0, sexWidth, TEXT_RECT_HEIGHT)];
    age = [[UILabel alloc] initWithFrame:CGRectMake(idWidth + nameWidth + sexWidth, 0, ageWidth, TEXT_RECT_HEIGHT)];
    
    clientId.font = [UIFont fontWithName:@"Arial" size:TEXT_HEIGHT];
    name.font = [UIFont fontWithName:@"Arial" size:TEXT_HEIGHT];
    sex.font = [UIFont fontWithName:@"Arial" size:TEXT_HEIGHT];
    age.font = [UIFont fontWithName:@"Arial" size:TEXT_HEIGHT];
    
    if(0 == indexPath.row)
    {
        // init table headers
        [clientId setText:@"编号"];
        [name setText:@"姓名"];
        [sex setText:@"性别"];
        [age setText:@"年龄"];
    }
    else
    {
        // fill clients data
        HHClient *client = [clientArray objectAtIndex:indexPath.row - 1];

        [sex setText:[client getSexAsString]];
        [age setText:[NSString stringWithFormat:@"%d", [client getAge]] ];
        [clientId setText: client.clientId];
        [name setText:client.name];
    }

    [cell addSubview:clientId];
    [cell addSubview:name];
    [cell addSubview:sex];
    [cell addSubview:age];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    _testView.client = [clientArray objectAtIndex:indexPath.row - 1];
    [self.navigationController pushViewController:_testView animated:YES];
}

-(void)SearchClientPressed
{
    [self.navigationController pushViewController:_searchView animated:YES];
}

@end
