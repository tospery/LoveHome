//
//  FlowViewViewController.m
//  LoveHome
//
//  Created by MRH on 15/12/5.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import "LHFlowViewViewController.h"
#import "Paging.h"
#import "FunctionManageObject.h"
@interface LHFlowViewViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) Paging *page;
@end

#pragma mark - 流量统计VC
@implementation LHFlowViewViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpDB];
    
    [self setUpUI];
    [self SetUpNet];
}


#pragma mark - Config Data 

- (void)refreshNewData {
    
}

#pragma mark - PraviteFuction

- (void)setUpDB
{
    self.title = @"流量统计";
#pragma mark - 修改  写到初始化里面
    //_dataSource = [[NSMutableArray alloc] init];
    _page = [[Paging alloc] init];
    _page.currentPage = 1;
}

- (void)setUpUI
{
    _myTableView.sectionFooterHeight = 10;
    _myTableView.sectionHeaderHeight = 2;
    _myTableView.backgroundColor = RHBackgroudColor;
    
    _myTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page.currentPage = 1;
        [self requestWithMode:JXRequestModeRefresh];
    }];
    
    _myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestWithMode:JXRequestModeMore];
    }];
    
    
    
}

- (void)SetUpNet
{
    [self requestWithMode:JXRequestModeRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestWithMode:(JXRequestMode)mode
{
    switch (mode) {
        case JXRequestModeHUD:
       
        case JXRequestModeRefresh:
        {
            if (mode == JXRequestModeHUD) {
                ShowProgressHUD(YES, nil);
            }
            [LHHttpClient requestStatistiGetFlowListWithPage:_page.currentPage Success:^(AFHTTPRequestOperation *operation, id responsObject) {
                // TOO 配置数据
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:responsObject[@"data"]];
                [_myTableView reloadData];
                [self handleSuccessWithMode:mode view:nil];
#pragma mark - 修改 刷新不结束bug
                [_myTableView.header endRefreshing];
            } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureWithMode:mode view:nil error:error retry:^{
                    [self requestWithMode:mode];
                }];
            }];
            break;
        }
        case JXRequestModeMore:{
            [LHHttpClient requestStatistiGetFlowListWithPage:(_page.currentPage + 1) Success:^(AFHTTPRequestOperation *operation, id responsObject) {
                // TOO 配置数据
                
#warning  加载不出来数据的原因是 因为 data 为空 ()
                _page.currentPage += 1;
                 if (responsObject[@"data"] != [NSArray array]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:responsObject[@"data"]];
                [_myTableView reloadData];
                [self handleSuccessWithMode:mode view:nil];
                [_myTableView.footer endRefreshing];
                 } else {
                     ShowWaringAlertHUD(@"暂无更多数据", self.view);
                     [_myTableView.footer endRefreshing];
                 }
            } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureWithMode:mode view:nil error:error retry:^{
                    [self requestWithMode:mode];
                }];
            }];
            
            break;
        }
        default:
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifer = @"systemcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifer];
        cell.detailTextLabel.textColor = [UIColor orangeColor];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.font  =  RHFontAdap(16);
        cell.textLabel.font  =  RHFontAdap(18);
    }
    NSDictionary *detail = _dataSource[indexPath.section];
    NSString *newDate = [detail[@"accessDate"] substringWithRange:NSMakeRange(0, 10)];
    cell.textLabel.text = newDate;
    if ([detail[@"daynumber"] isEqual:[NSNull null]]) {
        cell.detailTextLabel.text = @"0";
    } else {
    cell.detailTextLabel.text =  [NSString stringWithFormat:@"%@",detail[@"daynumber"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
