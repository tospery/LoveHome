//
//  IncomeDetailsViewController.m
//  LoveHome
//
//  Created by MRH-MAC on 15/8/27.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "IncomeDetailsViewController.h"
#import "IncomeDetailsHearView.h"
#import "HomeTool.h"
#import "IncomTableViewCell.h"
#import "DatePicker.h"
#import "IncomModel.h"
#import "IncomeMothDetailViewController.h"
#import "OrderListViewController.h"
#import <WebKit/WebKit.h>
@interface IncomeDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) IncomeDetailsHearView *sevenDayView;
@property (nonatomic,strong) DatePicker *datePicker;
@property (nonatomic,strong) UILabel *priceLable;
@property (nonatomic,strong) UILabel *countLable;
@property (nonatomic,strong) UIView *hearView;
@property (nonatomic,strong) UIView *subtotalView;
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) UIView *sectionView;
@property (nonatomic,strong) UILabel *sectionLable;
@property (nonatomic,strong) NSArray *mothData;
@property (nonatomic,strong) NSMutableArray *starTime;
@property (nonatomic,strong) NSMutableArray *endTime;
@property (nonatomic,strong) NSString *selectStMoth;
@property (nonatomic,strong) NSString *selectEnMoth;
@end

@implementation IncomeDetailsViewController

- (void)initData
{
    // DatePicker
    _starTime                        = [[NSMutableArray alloc] init];
    _endTime                         = [[NSMutableArray alloc] init];
    
    
    NSString *starMoth = [NSString stringWithFormat:@"2015-8"];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM"];
    NSDate *starDate = [formater dateFromString:starMoth];
    NSDateComponents *conmpe = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth  fromDate:starDate toDate:[NSDate date] options:NSCalendarWrapComponents];
    
    for (int i = 0; i<=conmpe.month; i++) {
        
        NSDateComponents *new = [[NSDateComponents alloc] init];
        new.month = i;
        NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:new toDate:starDate options:NSCalendarWrapComponents];
        NSString  *time = [formater stringFromDate:date];
        [_starTime addObject:time];
        [_endTime addObject:time];
    }
    
    
    self.datePicker                          = [[DatePicker alloc] initWithtitle:@[@"开始时间",@"结束时间"] isShowTitle:NO];
    
    [_datePicker setContentData:_starTime andSconde:_endTime];
    
    
    if (_starTime.count <= 3) {
        [_datePicker scrollRow:0 inComponent:0 animated:YES];
    }
    else
    {
        [_datePicker scrollRow:_starTime.count - 3 inComponent:0 animated:YES];
    }
    [_datePicker scrollRow:_endTime.count - 1 inComponent:1 animated:YES];
    __weak __typeof(self)weakSelf = self;
    
    _datePicker.choosePickerBlock = ^(NSString *contetn1,NSString *content2)
    {
        
        if (contetn1 == nil ) {
            contetn1 = [_starTime firstObject];
        }
        if (content2 == nil) {
            content2 = [_endTime lastObject];
        }
        
        weakSelf.sectionLable.text = [NSString stringWithFormat:@"查询日期%@至%@",contetn1,content2];
        weakSelf.selectStMoth = contetn1;
        weakSelf.selectEnMoth = content2;
        
        [weakSelf refreshData];
    };
    _selectStMoth = [_starTime firstObject];
    _selectEnMoth = [_endTime lastObject];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收入明细";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"订单列表" style:UIBarButtonItemStylePlain target:self action:@selector(orderList)];
    
    
    [self initData];
    [self initSubViews];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)initSubViews
{
    _hearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.55 + 30)];
    _hearView.backgroundColor = [UIColor clearColor];
    
    _sevenDayView = [[IncomeDetailsHearView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH *0.55)];
    [_hearView addSubview:_sevenDayView];
    [_hearView addSubview:self.sectionView];
    [self.view addSubview:_hearView];
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.subtotalView];
    
    
    ShowIndicatorView(YES, _hearView);
    [HomeTool sendSelctWalletetShopNearly7daysIncome:^(AFHTTPRequestOperation *operation, id responsObject) {
        ShowIndicatorView(NO, _hearView);
        [_sevenDayView dataSource:responsObject];

    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        ShowIndicatorView(NO, _hearView);

    }];
    [self refreshData];
    
   

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
    _priceLable.text = [NSString stringWithFormat:@"￥%.2lf",allPrice];
    _countLable.text = [NSString stringWithFormat:@"小计 %ld单",allCount];

}

- (void)refreshData
{

    ShowProgressHUD(YES, self.view);
    NSString *star = [_selectStMoth stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *end = [_selectEnMoth stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [HomeTool sendWalletGetShopWalletMonthStarMoth:star endMoth:end andSuceess:^(AFHTTPRequestOperation *operation, id responsObject) {
        ShowProgressHUD(NO, self.view);


        self.mothData = responsObject;
        [_myTableView reloadData];
        [self calculatePrice:responsObject];
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {

        ShowProgressHUD(NO, self.view);
        ShowWaringAlertHUD(error.localizedDescription, self.view);
    }];
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _mothData.count / 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  3;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

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
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"row2"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"row2"];
        }
        
        IncomModel *model =  _mothData[(indexPath.section * 2) + indexPath.row  - 1] ;
        cell.textLabel.text = model.half;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.2lf",model.totalIncome];
        return cell;

    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    IncomModel *model =  _mothData[(indexPath.section * 2) + indexPath.row  - 1] ;
    IncomeMothDetailViewController *vc = [[IncomeMothDetailViewController alloc] init];
    vc.mothModel = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}



- (UIView *)subtotalView
{
    if (!_subtotalView) {
        _subtotalView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 20-64, SCREEN_WIDTH, 25)];
        _subtotalView.backgroundColor = [UIColor redColor];
        UILabel *priceLable = [[UILabel alloc] init];
        priceLable.textColor = [UIColor whiteColor];
        priceLable.font = [UIFont systemFontOfSize:13];
        priceLable.text = @"￥0.0";
        _priceLable = priceLable;
        [_subtotalView addSubview:_priceLable];
        [priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_subtotalView.mas_centerY);
            make.right.equalTo(_subtotalView).offset(-10);
        }];
        
        UILabel *count = [[UILabel alloc] init];
        count.textColor = [UIColor whiteColor];
        count.font = [UIFont systemFontOfSize:13];
        count.text = @"小计:0单";
        _countLable = count;
        [_subtotalView addSubview:_countLable];
        [count mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_subtotalView.mas_centerY);
            make.right.equalTo(priceLable.mas_left).offset(-5);
        }];


    }
    return _subtotalView;
}

- (UITableView *)myTableView
{
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _hearView.height, SCREEN_WIDTH, SCREEN_HIGHT - _hearView.height - 64) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        [_myTableView registerNib:[UINib nibWithNibName:@"IncomTableViewCell" bundle:nil] forCellReuseIdentifier:@"IncomTableViewCell"];
        
    }
    return _myTableView;
}


- (UIView *)sectionView
{
    if (!_sectionView) {
        _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, _sevenDayView.height, SCREEN_WIDTH, 30)];
        _sectionView.backgroundColor = self.view.backgroundColor;
        _sectionLable = [[UILabel alloc] init];
        _sectionLable.height = _sectionView.height - 10;
        _sectionLable.width  = _sectionView.width - 100;
        _sectionLable.font = [UIFont systemFontOfSize:14];
        _sectionLable.textAlignment = NSTextAlignmentLeft;
        
        NSString *starStr;
        if (_starTime.count <= 3) {
            starStr = _starTime.firstObject;
        }
        starStr = _starTime.count <=3 ? _starTime.firstObject : _starTime[_starTime.count - 3];
        
        _sectionLable.text = [NSString stringWithFormat:@"查询日期%@至%@",starStr,_endTime.lastObject] ;
        _sectionLable.x =  20;
        _sectionLable.y = 10;
        
        UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [dateButton setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
        [dateButton addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
        dateButton.y = 5;
        dateButton.x = SCREEN_WIDTH - 80;
        dateButton.width = 50;
        dateButton.height = 30;
        [_sectionView addSubview:dateButton];
        [_sectionView addSubview:_sectionLable];
    }
    return _sectionView;
}


- (void)orderList
{
    OrderListViewController *orderVC = [[OrderListViewController alloc] initWithType:OrderTypeAdded];
    [self.navigationController pushViewController:orderVC animated:YES];

}
- (void)chooseDate:(UIButton *)sender
{
    [_datePicker coverStarAnimation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
