//
//  LHOrderIncomViewController.m
//  LoveHome
//
//  Created by MRH on 15/12/5.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import "LHOrderIncomViewController.h"
#import "VistrosXibViews.h"
#import "IncomModel.h"
#import "DatePicker.h"
#import "HomeTool.h"
#import "RHCharMode.h"
#import "RHLoadView.h"

#import "IncomeMothDetailViewController.h"


@interface LHOrderIncomViewController ()
   

@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@property (weak, nonatomic) IBOutlet UIView *heardContentView;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UILabel *footerView;
@property (weak, nonatomic) IBOutlet UILabel *orderContLab;
@property (weak, nonatomic) IBOutlet UILabel *orderAllPriceLab;

@property (nonatomic,strong) VistrosXibViews *hearView;
@property (nonatomic,strong) DatePicker *starPick;
@property (nonatomic,strong) DatePicker *endDayPicker;
@property (nonatomic,strong) NSMutableArray *mothData;
@property (nonatomic,strong) NSMutableArray *dateStrList;
@property (nonatomic,strong) NSMutableArray *chartList;
@property (nonatomic,strong) NSString *fistDay;
@property (nonatomic,strong) NSString *endDay;

@property (nonatomic, assign) BOOL onceGo;

@end

#pragma mark - 统计 订单收入统计VC

@implementation LHOrderIncomViewController

- (void)dealloc
{
    [_starPick removeFromSuperview];
    [_endDayPicker removeFromSuperview];
    _starPick = nil;
    _endDayPicker = nil;
    _endDay = nil;
//    _endDay = nil;
//    _endDay = nil;
 //   NSLog(@"%s",__func__);
}

#pragma mark - Data configuration

- (void)configNewData:(NSMutableArray *)responsObject {
    [_chartList removeAllObjects];
    if (responsObject.count == 1) {
        [responsObject addObject:[responsObject lastObject]];
    }
    _chartList = responsObject;
}

#pragma mark - 配置日期数据
- (void)conFistfigDateData {
    NSString *starMoth = [NSString stringWithFormat:@"2015-8"];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM"];
    NSDate *starDate = [formater dateFromString:starMoth];
#pragma mark - 修改2015 - 2016日期
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *conmpe = [calendar components:NSCalendarUnitMonth  fromDate:starDate toDate:[NSDate date] options:0];
    for (int i = 0; i <= conmpe.month; i++) {
        NSDateComponents *new = [[NSDateComponents alloc] init];
        new.month = i;
        NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:new toDate:starDate options:0];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        
        NSInteger interval = [zone secondsFromGMTForDate:date];
        
        NSDate *localeDate = [date dateByAddingTimeInterval:interval];
        
        NSString  *time = [formater stringFromDate:localeDate];
        [_dateStrList addObject:time];
    }
    _fistDay = [_dateStrList lastObject];
    _endDay  = [_dateStrList lastObject];
    [_startBtn setTitle:_fistDay forState:UIControlStateNormal];
    [_endBtn setTitle:_endDay forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self setUpDB];
    [self setUpUI];
    [self SetUpNet];
}

#pragma mark - BasePravite Fuction

- (void)setUpDB {
    self.title = @"订单收入统计";
    _hearView = [[[NSBundle mainBundle] loadNibNamed:@"VistrosXibViews" owner:nil options:nil] lastObject];
    _mothData = [[NSMutableArray alloc] init];
    _dateStrList = [[NSMutableArray alloc] init];
    _chartList = [[NSMutableArray alloc] init];
    
    // fist come configDateData
    [self conFistfigDateData];
}

- (void)setUpUI {
    
    _starPick = [[DatePicker alloc] initWithtitle:@[@"开始时间"] ];
    [_starPick setContentData:self.dateStrList andSconde:nil];
    _endDayPicker = [[DatePicker alloc] initWithtitle:@[@"结束时间"]];
    [_endDayPicker setContentData:self.dateStrList andSconde:nil];
    __weak LHOrderIncomViewController *myself = self;
    _starPick.block = ^(NSString *content , id cate){
        myself.fistDay = content;
        [myself.startBtn setTitle:content forState:UIControlStateNormal];
    };
    _endDayPicker.block = ^(NSString *content , id cate){
        myself.endDay = content;
        [myself.endBtn setTitle:content forState:UIControlStateNormal];
    };
    _hearView.selecBlcok = ^(NSInteger index){
        
        [myself selectSegementIndex:index];
    };

    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_WIDTH * 0.78)];
     _footerView.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 7.5) andColors:@[RHColorHex(0xeec95f, 1),RHColorHex(0xf19066, 1)]];
    _hearView.frame = view.bounds;
    _hearView.chartType = OrderPriceStatis;
    ConfigButtonLayerBorderColor(UIColor.lightGrayColor, _startBtn);
    ConfigButtonLayerBorderColor(UIColor.lightGrayColor, _endBtn);
    ConfigButtonLayerBorderColor(UIColor.orangeColor, _searchBtn);
    
    _mytableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    _mytableView.sectionHeaderHeight = 1;
    _mytableView.sectionFooterHeight = 10;
    _mytableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
    _mytableView.backgroundColor = RHBackgroudColor;
    self.view.backgroundColor = RHBackgroudColor;
    [view addSubview:self.hearView];
    [_heardContentView addSubview:view];
}

- (void)SetUpNet {
    [self requestSearchOrderList];
    [self requestWithMode:RHWebLaunchTypeHUD];
}

- (void)requestWithMode:(RHWebLaunchType)mode
{
    [RHRequstLauchTool showLauchWithType:mode toView:nil];
    [LHHttpClient requestStatistiGetAroundIncomeListSuccess:^(AFHTTPRequestOperation *operation, NSMutableArray * responsObject) {
        [self configNewData:responsObject];
        [self selectSegementIndex:0];
        [RHRequstLauchTool handleSuceessRequestType:mode toView:nil];
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [RHRequstLauchTool handleErrorFailureForView:nil lauchType:RHWebLaunchTypeHUD ToastWay:RHErrorShowTypeHUD error:error callback:^{
            [self requestWithMode:mode];
        }];
    }];
}

#pragma mark - Logic Handle Fuction

- (void)selectSegementIndex:(NSInteger)index {
    
    if (_chartList.count < 1) {
        return;
    }
    NSMutableArray *chartlist = [[NSMutableArray alloc] init];
    
    if (!_onceGo) {
        
    
        self.chartList = [NSMutableArray arrayWithArray:[[_chartList /*objectEnumerator*/reverseObjectEnumerator] allObjects]];
        _onceGo = YES;
    }
    
    

    switch (index) {
        case 0: {
            [chartlist removeAllObjects];
            chartlist = _chartList.count >= 7 ? [_chartList subarrayWithRange:NSMakeRange(0, 7)].mutableCopy : _chartList;
            chartlist = [NSMutableArray arrayWithArray:[[chartlist reverseObjectEnumerator] allObjects]];
            break;
        }
        case 1: {
            [chartlist removeAllObjects];
          //  self.chartList = [NSMutableArray arrayWithArray:[[_chartList /*objectEnumerator*/reverseObjectEnumerator] allObjects]];
            chartlist = _chartList.count >= 30 ? [_chartList subarrayWithRange:NSMakeRange(0, 30)].mutableCopy : _chartList;
            chartlist = [NSMutableArray arrayWithArray:[[chartlist reverseObjectEnumerator] allObjects]];
            break;
        }
        case 2: {
            [chartlist removeAllObjects];
           // self.chartList = [NSMutableArray arrayWithArray:[[_chartList /*objectEnumerator*/reverseObjectEnumerator] allObjects]];
            chartlist = _chartList.count >= 90 ? [_chartList subarrayWithRange:NSMakeRange(0, 90)].mutableCopy : _chartList;
            chartlist = [NSMutableArray arrayWithArray:[[chartlist reverseObjectEnumerator] allObjects]];
            
        }
        default:
            break;
    }
    RHCharMode *chartModel = [RHCharMode new];
    chartModel.chartListData = [NSMutableArray arrayWithArray:chartlist];
    chartModel.chartFillColor = UIColor.clearColor;
    [self.hearView.currenDataList removeAllObjects];
    [self.hearView.currenDataList addObjectsFromArray:@[chartModel]];
    [self.hearView resetData];
}

-(IBAction)starDayClick:(UIButton *)sender {
    [_starPick coverStarAnimation];
}

-(IBAction)endDayClick:(UIButton *)sender {
    [_endDayPicker coverStarAnimation];
}

-(IBAction)searchClick:(UIButton *)sender {
    if (JudgeContainerCountIsNull(_fistDay) || JudgeContainerCountIsNull(_endDay))
    {
        ShowWaringAlertHUD(@"日期未选择", nil);
        return;
    }
    [self requestSearchOrderList];
}

- (void)requestSearchOrderList{
    
//    ShowProgressHUD(YES, self.view);
    NSString *star = [_fistDay stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *end = [_endDay stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [HomeTool sendWalletGetShopWalletMonthStarMoth:star endMoth:end andSuceess:^(AFHTTPRequestOperation *operation, id responsObject) {
//        ShowProgressHUD(NO, self.view);
        self.mothData = responsObject;
        [_mytableView reloadData];
        [self calculatePrice:responsObject];
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
//        ShowProgressHUD(NO, self.view);
        ShowWaringAlertHUD(error.localizedDescription, self.view);
    }];
}

- (void)calculatePrice:(NSArray *)arry
{
    if (arry.count < 1) {
        return;
    }
    NSInteger allCount = 0;
    CGFloat allPrice = 0.00;
    for (IncomModel *model in arry) {
        allCount += model.orders;
        allPrice += model.totalIncome;
    }
    _orderContLab.text = [NSString stringWithFormat:@"￥%.2lf",allPrice];
    _orderAllPriceLab.text = [NSString stringWithFormat:@"小计 %ld单",allCount];
    
}

#pragma mark - UITableViewDelegate - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _mothData.count / 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"row1"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"row1"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        IncomModel *mode = _mothData[indexPath.section *2];
        cell.textLabel.text = [mode.startDate substringToIndex:7];
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"row2"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"row2"];
        }
        IncomModel *model =  _mothData[(indexPath.section * 2) + indexPath.row  - 1] ;
        cell.textLabel.text = model.half;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.2lf",model.totalIncome];
        cell.detailTextLabel.textColor = [UIColor flatRedColor];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    SGOrderDetailViewController *orderIncomedetailVC = [[SGOrderDetailViewController alloc] init];
//    
//    [self.navigationController pushViewController:orderIncomedetailVC animated:YES];
    if (indexPath.row != 0) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        IncomModel *model = _mothData[(indexPath.section * 2) + indexPath.row - 1] ;
        IncomeMothDetailViewController *vc = [[IncomeMothDetailViewController alloc] init];
        vc.mothModel = model;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


@end
