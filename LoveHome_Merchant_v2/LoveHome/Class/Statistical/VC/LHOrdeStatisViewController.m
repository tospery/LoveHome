//
//  LHOrdeStatisViewController.m
//  LoveHome
//
//  Created by MRH on 15/12/7.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import "LHOrdeStatisViewController.h"
#import "RHCharMode.h"
#import "VistrosXibViews.h"
#import "StatistChartModel.h"
#import "OrderListViewController.h"
#import "OrderStatisModel.h"
@interface LHOrdeStatisViewController ()

/// IBOutlet Property
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UIView *titleContentView;
@property (weak, nonatomic) IBOutlet UILabel *finishTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *cancleTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *finishNumber;
@property (weak, nonatomic) IBOutlet UILabel *cancleNumber;
@property (nonatomic,assign) NSInteger segCurrentIndex;
@property (nonatomic,strong) NSMutableArray *selectType;
@property (nonatomic,strong) NSMutableArray *baseAlltList;
@property (nonatomic,strong) VistrosXibViews *orderListhearView;
@property (nonatomic,strong) OrderStatisModel *orderStatusCountMolde;

@property (nonatomic, strong) NSMutableArray *chartList;
@property (nonatomic, assign) BOOL onceGo;
/**
 *  天数
 */
@property (nonatomic, assign) NSInteger currentDays;

@end

@implementation LHOrdeStatisViewController
//订单统计VC

#pragma mark - config Data
// Rest Data
- (void)configNewData:(NSDictionary *)responsObject {
    // Analytical network data
    
    NSArray *allList = responsObject[@"chart"];
    RHCharMode *finish = [OrderStatisModel getDiffrentStatusOrdersList:allList withType:FinshiOrderIdentifer];
        
    RHCharMode *cancle = [OrderStatisModel getDiffrentStatusOrdersList:allList withType:UserCancelOrdersIdentifer];
    finish.chartFillColor = RHColorHex(0x2FB7F2, 1);
    cancle.chartFillColor = RHColorHex(0x00ff77, 1);
    NSMutableArray *dataList = [[NSMutableArray alloc] initWithObjects:finish,cancle,nil];
    
    // reset base data
    [_orderStatusCountMolde setKeyValues:responsObject];
    [_baseAlltList removeAllObjects];
    _baseAlltList = dataList;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpDB];
    [self setUpUI];
    [self SetUpNet];
    
}

#pragma mark - PraviteFuction

- (void)setUpDB {
    _segCurrentIndex = 0;
    _currentDays = 7;
    _baseAlltList = [[NSMutableArray alloc] init];
    _orderStatusCountMolde = [[OrderStatisModel alloc] init];
    _selectType = [[NSMutableArray alloc] initWithObjects:@0,@1,nil];
    _orderListhearView = [[[NSBundle mainBundle] loadNibNamed:@"VistrosXibViews" owner:nil options:nil] lastObject];
    self.title = @"订单统计";
}

- (void)setUpUI
{
    UIView *view  =  [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_WIDTH * 0.78)];
    _titleContentView.backgroundColor  = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:_titleContentView.bounds andColors:@[RHColorHex(0x5dccea, 1),RHColorHex(0x5dccea, 1)]];
    self.view.backgroundColor = RHBackgroudColor;
    _orderListhearView.frame = view.bounds;
    _orderListhearView.chartType = OrderStatis;
    __weak __typeof(self)weakSelf = self;
    _orderListhearView.selecBlcok = ^(NSInteger index){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.segCurrentIndex = index;
        [strongSelf selctDays:index complete:nil];
    };
    [view  addSubview:self.orderListhearView];
    [_chartView addSubview:view];

}

- (void)SetUpNet
{
    // first come refresh
    [self requestWithMode:RHWebLaunchTypeHUD];
}

- (void)requestWithMode:(RHWebLaunchType)mode
{
    [RHRequstLauchTool showLauchWithType:mode toView:nil];
    [LHHttpClient requestStatistiGetOrderCountsSuccess:^(AFHTTPRequestOperation *operation, NSDictionary * responsObject) {        
        [self configNewData:responsObject];
        [self selctDays:0 complete:^{
            [RHRequstLauchTool handleSuceessRequestType:mode toView:nil];
            
        }];

    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [RHRequstLauchTool handleErrorFailureForView:nil lauchType:RHWebLaunchTypeHUD ToastWay:RHErrorShowTypeHUD error:error callback:^{
            [self requestWithMode:mode];
        }];
    }];
    
}
- (void)setUpMyNum
{
    [self myNumberWithMode:RHWebLaunchTypeSilent];
}
/**
 *  填写数字label
 *
 *  @param responsObject  请求来的字典
 */
- (void)fillMyNumWithDic:(NSDictionary *)responsObject
{
    NSString *f = [NSString stringWithFormat:@"%@",responsObject[@"finisedOrders"]];
    _finishNumber.text = f;
    NSString *c = [NSString stringWithFormat:@"%@", responsObject[@"userCancelOrders"]];
    _cancleNumber.text = c;
}
/**
 *  请求两个状态
 *
 *  @param mode 请求方式
 */
- (void)myNumberWithMode:(RHWebLaunchType)mode
{
    [RHRequstLauchTool showLauchWithType:mode toView:nil];
    [LHHttpClient requestStatisticalNumbersWith:_currentDays Success:^(AFHTTPRequestOperation *operation, id responsObject) {
        
        [self fillMyNumWithDic:responsObject];
        [RHRequstLauchTool handleSuceessRequestType:mode toView:nil];
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [RHRequstLauchTool handleErrorFailureForView:nil lauchType:RHWebLaunchTypeHUD ToastWay:RHErrorShowTypeHUD error:error callback:^{
            [self myNumberWithMode:mode];
        }];
    }];
}
// select segment block
- (void)selctDays:(NSInteger )index complete:(void(^)(void))complet{
    
    if (_baseAlltList.count < 1) {
        return;
    }
    // use gcd speed up the performance
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // remove all data
        [self.orderListhearView.currenDataList removeAllObjects];
        
        // get chartView newData from basedatalist
        for (int i = 0 ; i < _baseAlltList.count; i++) {
            RHCharMode *mode = _baseAlltList[i];
            NSArray *arry = mode.chartListData;
            
            //  _selecttype can't constains i -->> continue current for
            if (![_selectType containsObject:@(i)]) {
                continue;
            }
            // get  right effective‘s data
            NSArray *chartlist = [self chooseSegemeny:index withdata:arry];
            
            // creat newModel to chartlistData
            RHCharMode *newModel = [RHCharMode new];
            newModel.name = mode.name;
            newModel.chartFillColor = mode.chartFillColor;
            newModel.chartListData = [NSMutableArray arrayWithArray:chartlist];
            [self.orderListhearView.currenDataList addObject:newModel];
        }
        // note: UI have to update in main_queue
        dispatch_async(dispatch_get_main_queue(), ^{
            // reload orderListHearView
            [self.orderListhearView resetData];
            if (complet) {
                complet();
            }
        });
    });
}

#pragma mark Click Function

- (IBAction)goOrderList:(UIButton *)sender {
    OrderListViewController *vc = [[OrderListViewController alloc] initWithType:OrderTypeAdded];
    [self.navigationController pushViewController:vc animated:YES];
    
}
// 点击事件
- (IBAction)finishOderAction:(UIButton *)sender
 {
     // change the button status
     sender.selected = !sender.selected;
     // config by show line in current View
     [self resetDataSource:0 isSelect:sender.selected];
     // change title color
     _finishNumber.textColor = sender.selected ? UIColor.lightGrayColor : UIColor.whiteColor;
     _finishTitleLab.textColor = sender.selected ? UIColor.lightGrayColor : UIColor.whiteColor;
}
- (IBAction)cancleOrderAction:(UIButton *)sender
 {
     sender.selected = !sender.selected;
     [self resetDataSource:1 isSelect:sender.selected];
     _cancleNumber.textColor   = sender.selected ? UIColor.lightGrayColor : UIColor.whiteColor;
     _cancleTitleLab.textColor = sender.selected ? UIColor.lightGrayColor : UIColor.whiteColor;
}

#pragma mark - Handle DataSource
// reload chartView when select conditions bar
- (void)resetDataSource:(NSInteger)index isSelect:(BOOL)select{
 
    if( _baseAlltList.count < 1){
        return;
    }
    RHCharMode *mode = _baseAlltList[index];
    
    if (select){
        [_selectType removeObject:@(index)];
        [_orderListhearView.currenDataList removeObject:mode];
    }
    else
    {
        [_selectType addObject:@(index)];
        RHCharMode *mode = _baseAlltList[index];
        NSArray *rightDat = [self chooseSegemeny:_segCurrentIndex withdata:mode.chartListData];
        RHCharMode *newModel = [RHCharMode new];
        newModel.name = mode.name;
        
        newModel.chartFillColor = mode.chartFillColor;
        newModel.chartListData = [NSMutableArray arrayWithArray:rightDat];
        [_orderListhearView.currenDataList addObject:newModel];
    }
    [_orderListhearView reloadDataView];
    
}

// select segnent config data
- (NSArray *)chooseSegemeny:(NSInteger)index  withdata:(NSArray *)arry{
    NSMutableArray *chartlist = [[NSMutableArray alloc] init];
        // choose date data
    switch (index) {
        case 0: {
            [chartlist removeAllObjects];
            arry = [NSArray arrayWithArray:[[arry reverseObjectEnumerator] allObjects]];
            chartlist = arry.count >= 7 ? [arry subarrayWithRange:NSMakeRange(0, 7)].mutableCopy: arry;
            chartlist = [NSMutableArray arrayWithArray:[[chartlist reverseObjectEnumerator] allObjects]];
            _currentDays = 7;
            _finishNumber.text = @"";
            [self myNumberWithMode:RHWebLaunchTypeSilent];
            break;
        }
        case 1: {
            [chartlist removeAllObjects];
            arry = [NSArray arrayWithArray:[[arry reverseObjectEnumerator] allObjects]];

            chartlist = arry.count >= 30 ? [arry subarrayWithRange:NSMakeRange(0, 30)].mutableCopy: arry;
            chartlist = [NSMutableArray arrayWithArray:[[chartlist reverseObjectEnumerator] allObjects]];
            _finishNumber.text = @"";
            _currentDays = 30;
            [self myNumberWithMode:RHWebLaunchTypeSilent];

            
            break;
        }
        case 2: {
            [chartlist removeAllObjects];
            arry = [NSArray arrayWithArray:[[arry reverseObjectEnumerator] allObjects]];

            chartlist = arry.count >= 90 ? [arry subarrayWithRange:NSMakeRange(0, 90)].mutableCopy: arry;
            chartlist = [NSMutableArray arrayWithArray:[[chartlist reverseObjectEnumerator] allObjects]];
            _currentDays = 90;
            _finishNumber.text = @"";
            [self myNumberWithMode:RHWebLaunchTypeSilent];

        }
        default:
            break;
    }

    return chartlist;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
