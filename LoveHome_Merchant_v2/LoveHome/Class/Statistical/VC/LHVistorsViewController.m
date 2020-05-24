//
//  LHVistorsViewController.m
//  LoveHome
//
//  Created by MRH on 15/12/5.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import "LHVistorsViewController.h"
#import "StatistChartModel.h"
#import "VistrosXibViews.h"
#import "RHCharMode.h"
#import "LHFlowViewViewController.h"
#import "LHShopStatiViewController.h"
#import "LoveHome-Swift.h"
@interface LHVistorsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) NSArray *cellitems;
@property (nonatomic,strong) VistrosXibViews *hearView;
@property (nonatomic,strong) NSMutableArray *currentCharList;
@end

#pragma mark - 访客数量VC
@implementation LHVistorsViewController

//- (void)awakeFromNib
//{
//    self.currentCharList = [NSMutableArray array];
//}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpDB];
    [self setUpUI];
    [self SetUpNet];
    
}

#pragma  mark - Config Data

- (void)refreshChartView:(NSArray *)data {
    RHCharMode *chartModel = [RHCharMode new];
    chartModel.chartListData = [NSMutableArray arrayWithArray:data];
    chartModel.chartFillColor = UIColor.clearColor;
    [self.hearView.currenDataList removeAllObjects];
    [self.hearView.currenDataList addObjectsFromArray:@[chartModel]];
    [_hearView resetData];
}
#pragma mark - 此处判断的是 点击segmentedControll 的哪个 item , 仅限于访客数量 ,调试完成
- (NSArray *)getCurrentChartData:(NSInteger)index {
    NSMutableArray *chartlist = [[NSMutableArray alloc] init];
    switch (index) {
        case 0: {
            [chartlist removeAllObjects];
            chartlist = _currentCharList.count >= 7 ? [_currentCharList subarrayWithRange:NSMakeRange(0, 7)].mutableCopy : _currentCharList;
             chartlist = [NSMutableArray arrayWithArray:[[chartlist reverseObjectEnumerator] allObjects]];
            break;
        }
        case 1: {
            [chartlist removeAllObjects];
            chartlist = _currentCharList.count >= 30 ? [_currentCharList subarrayWithRange:NSMakeRange(0, 30)].mutableCopy: _currentCharList;
            chartlist = [NSMutableArray arrayWithArray:[[chartlist reverseObjectEnumerator] allObjects]];
            break;
        }
        case 2: {
            [chartlist removeAllObjects];
            chartlist = _currentCharList.count >= 90 ? [_currentCharList subarrayWithRange:NSMakeRange(0, 90)].mutableCopy: _currentCharList;
            chartlist = [NSMutableArray arrayWithArray:[[chartlist reverseObjectEnumerator] allObjects]];
        }
        default:
            break;
    }
    return chartlist;
}

#pragma mark - PraviteFuction

- (void)setUpDB
{
    self.title = @"访客数量";
    CellConfig *everyDatyStatis = [CellConfig new];
    CellConfig *shopCountStatis = [CellConfig new];
    everyDatyStatis.className = @"";
    shopCountStatis.className = @"";
    everyDatyStatis.titleName = @"每日流量统计";
    everyDatyStatis.imageUrl  = @"statistical_ico_flow";
    shopCountStatis.titleName = @"商品统计";
    shopCountStatis.imageUrl  = @"statistical_ico_goods";
    _cellitems = @[everyDatyStatis,shopCountStatis];
    _currentCharList = [[NSMutableArray alloc] init];
}

- (void)setUpUI
{
    // tableView 的 头
    _hearView  = [[[NSBundle mainBundle] loadNibNamed:@"VistrosXibViews" owner:nil options:nil] lastObject];
    _hearView.chartType = VistrosCount;
    _hearView.frame = CGRectMake(0, 0, SCREEN_HIGHT, 247);
    _myTableView.tableHeaderView = _hearView;
    [self.view  addSubview:self.myTableView];
    [self.myTableView setTableHeaderView:self.hearView];
    // 此处回调
    __weak __typeof(self)weakSelf = self;
    _hearView.selecBlcok = ^(NSInteger index){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf selctDays:index];
    };
}

- (void)SetUpNet
{
    [self requestWithMode:RHWebLaunchTypeHUD];
}

- (void)requestWithMode:(RHWebLaunchType)mode {
    [RHRequstLauchTool showLauchWithType:mode toView:nil];
    [LHHttpClient requestStatistitGetVisitersCountSuccess:^(AFHTTPRequestOperation *operation, NSMutableArray * responsObject) {
        [_currentCharList removeAllObjects];
        _currentCharList = responsObject;
        [self selctDays:0];
        [RHRequstLauchTool handleSuceessRequestType:mode toView:nil];
        
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [RHRequstLauchTool handleErrorFailureForView:nil lauchType:mode ToastWay:RHErrorShowTypeHUD error:error callback:^{
            [self requestWithMode:mode];
        }];
    }];
}

- (void)selctDays:(NSInteger)index
{
    if (_currentCharList.count < 1) {
        return;
    }
    NSArray *chartlist = [self getCurrentChartData:index];
    [self refreshChartView:chartlist];
}

- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.tableFooterView = [UIView new];
        _myTableView.backgroundColor = RHBackgroudColor;
    }
    return _myTableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifer = @"wjlfa";
    CellConfig *mode = _cellitems[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifer];
    }
    cell.imageView.image = [UIImage imageNamed:mode.imageUrl];
    cell.textLabel.text = mode.titleName;
    cell.textLabel.font = RHFontAdap(16);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        LHFlowViewViewController *vc = [[LHFlowViewViewController alloc] initWithNibName:@"LHFlowViewViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 1)
    {
        LHShopStatiViewController *vc = [[LHShopStatiViewController alloc] initWithNibName:@"LHShopStatiViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}






@end
