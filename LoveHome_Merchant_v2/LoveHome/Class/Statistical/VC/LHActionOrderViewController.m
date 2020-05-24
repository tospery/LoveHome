//
//  LHActionOrderViewController.m
//  LoveHome
//
//  Created by MRH on 15/12/7.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import "LHActionOrderViewController.h"
#import "RHCharMode.h"
#import "VistrosXibViews.h"
#import "StatistChartModel.h"
#import "OrderStatisModel.h"

#import "TePopList.h"

@interface LHActionOrderViewController ()
{
    
    BOOL _isExpension;
    NSInteger selected;
    NSInteger myIndex;
    BOOL onceTime;
}
// showView
//显示下面四个label的视图
@property (weak, nonatomic) IBOutlet UIView *titleView;
//折线视图
@property (weak, nonatomic) IBOutlet UIView *chartView;
//总订单数 文字
@property (weak, nonatomic) IBOutlet UILabel *allOrderTitle;
//已完成 文字
@property (weak, nonatomic) IBOutlet UILabel *completTitle;
//已拒绝 文字
@property (weak, nonatomic) IBOutlet UILabel *rejectTitle;
//用户取消 文字
@property (weak, nonatomic) IBOutlet UILabel *userCancle;
// show Title
//总订单数 数字
@property (weak, nonatomic) IBOutlet UILabel *allOrderNumber;
//已完成 数字
@property (weak, nonatomic) IBOutlet UILabel *compleNumber;
//商家拒绝 数字
@property (weak, nonatomic) IBOutlet UILabel *rejectNumber;
//用户取消 数字
@property (weak, nonatomic) IBOutlet UILabel *userCacleNumber;

// Data property
@property (nonatomic,assign) NSInteger segCurrentIndex;
@property (nonatomic,strong) NSMutableArray *selectType;
@property (nonatomic,strong) NSMutableArray *baseAlltList;
@property (nonatomic,strong) OrderStatisModel *orderStatusCountMolde;
@property (nonatomic,strong) VistrosXibViews *orderListhearView;

@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, strong) NSMutableArray *acIdArr;

@property (nonatomic, assign) NSInteger activityId;

@property (nonatomic, assign) NSInteger days;

@property(nonatomic, assign) NSInteger currentDays;
@end

#pragma mark - 活动统计VC
@implementation LHActionOrderViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.arr = [[NSMutableArray alloc] init];
    self.acIdArr = [[NSMutableArray alloc] init];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    onceTime = YES;
    [self setUpActivityID];
    
    [self setUpDB];
    [self setUpUI];
    
    
    
}

#pragma mark - Data Config

- (void)configNewData:(NSDictionary *)responsObject {
    
    // Analytical network data
    
    NSArray *allList = responsObject[@"chart"];
    RHCharMode *allOrd = [OrderStatisModel getDiffrentStatusOrdersList:allList withType:PayOrdersIdentifer];
    RHCharMode *finish = [OrderStatisModel getDiffrentStatusOrdersList:allList withType:FinshiOrderIdentifer];
   // RHCharMode *refuse = [OrderStatisModel getDiffrentStatusOrdersList:allList withType:MerchantRefuseOrderIdentifer];
    RHCharMode *cancle = [OrderStatisModel getDiffrentStatusOrdersList:allList withType:UserCancelOrdersIdentifer];
    
    allOrd.chartFillColor = RHColorHex(0x9ECF42, 1);
    finish.chartFillColor = RHColorHex(0x2FB7F2, 1);
   // refuse.chartFillColor = RHColorHex(0xe4ff00, 1);
    cancle.chartFillColor = RHColorHex(0x00ff77, 1);
    NSMutableArray *dataList = [[NSMutableArray alloc] initWithObjects:allOrd,finish,cancle,nil];
    // reset base data
    [_orderStatusCountMolde setKeyValues:responsObject];
    [_baseAlltList removeAllObjects];
    _baseAlltList = dataList;
    

}
- (void)configActivityNumberData:(NSDictionary *)responsObject {
    
    //配置下面四个label
    
    if ([responsObject[@"allOrders"] isEqual:[NSNull null]]) {
        _allOrderNumber.text = @"0";
    } else {
        
        NSInteger all1  = [responsObject[@"allOrders"] integerValue];
        _allOrderNumber.text = [NSString stringWithFormat:@"%ld", (long)all1];
    }
    if ([responsObject[@"finisedOrders"] isEqual:[NSNull null]]) {
        _compleNumber.text = @"0";
    } else {
        NSInteger finish2  = [responsObject[@"finisedOrders"] integerValue];
        _compleNumber.text = [NSString stringWithFormat:@"%ld", (long)finish2];
    }
    
    //    NSInteger refuse3  = [responsObject[@"merchantRefuseOrders"] integerValue];
    //    _rejectNumber.text = [NSString stringWithFormat:@"%ld", (long)refuse3];
    if ([responsObject[@"userCancelOrders"] isEqual:[NSNull null]]) {
        _userCacleNumber.text = @"0";
    } else {
        NSInteger cancel4  = [responsObject[@"userCancelOrders"] integerValue];
        _userCacleNumber.text = [NSString stringWithFormat:@"%ld", (long)cancel4];
    }
    
}
#pragma mark - PraviteFuction

- (void)setUpDB
{
    self.title = @"活动统计";
    _baseAlltList = [[NSMutableArray alloc] init];
    _selectType = [[NSMutableArray alloc] initWithObjects:@0,@1,@2,nil];
    _orderStatusCountMolde = [[OrderStatisModel alloc] init];
    _orderListhearView = [[[NSBundle mainBundle] loadNibNamed:@"VistrosXibViews" owner:nil options:nil] lastObject];
}

- (void)setUpUI
{
    //view 包含了 折线图
    UIView *view  =  [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_WIDTH * 0.78)];
    _titleView.backgroundColor  = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:_titleView.bounds andColors:@[RHColorHex(0x9DCD4F, 1),RHColorHex(0x9DCD4F, 1)]];
    self.view.backgroundColor = RHBackgroudColor;
    _orderListhearView.frame = view.bounds;
    _orderListhearView.chartType = ActiveOrderStatis;
//    _chartView.backgroundColor = [UIColor blueColor];
//    _orderListhearView.backgroundColor = [UIColor yellowColor];
//    _chartView.backgroundColor = [UIColor redColor];
    __weak __typeof(self)weakSelf = self;
    _orderListhearView.selecBlcok = ^(NSInteger index){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf selctDays:index complete:nil];
    };
    [view  addSubview:self.orderListhearView];
    [_chartView addSubview:view];

}
- (void)setupACButtonWith:(NSArray *)responseObject
{
    for (int i = 0; i < responseObject.count; ++i) {
        [_arr addObject:[NSString stringWithFormat:@"活动 %d", i + 1]];
    
    }
    for (NSDictionary *dic in responseObject) {
        [_acIdArr addObject:dic[@"activityId"]];
    }
    _activityId = [_acIdArr.firstObject integerValue];
    _days = 90;
    _currentDays = 7;
#pragma mark - 活动按钮
   // _arr = @[@"活动 1",@"活动 2", @"活动 3", @"活动 4", @"活动 5"];
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(20, 5, [UIScreen mainScreen].bounds.size.width - 40, 30);
    listButton.backgroundColor = [UIColor whiteColor];
    [listButton setTitle:_arr[0] forState:UIControlStateNormal];
    listButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [listButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    listButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    listButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    
    [listButton setImage:[UIImage imageNamed:@"iconfont-ACdown.png"] forState:UIControlStateNormal];
    
    [listButton setImageEdgeInsets:UIEdgeInsetsMake(5, listButton.width - 10, 5, 10)];
    [listButton.layer setMasksToBounds:YES];
    [listButton.layer setCornerRadius:4];
    listButton.layer.borderWidth = 0.4;
    listButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [listButton addTarget:self action:@selector(listButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:listButton];

}
- (void)listButtonAction:(UIButton *)sender
{
    TePopList *pop = [[TePopList alloc]initWithListDataSource:_arr withSelectedBlock:^(NSInteger select) {
        NSLog( @"%li" ,(long)select);
        selected = select;
        
    [sender setTitle:_arr[selected] forState:UIControlStateNormal];
      _activityId = [_acIdArr[selected] integerValue];
        NSLog(@"%ld", _activityId);
        [self SetUpNet];
        [self requestNumbersWith:RHWebLaunchTypeSilent];

    }];
    [pop show];
    
    [pop selectIndex:selected];
   
    
    
}
- (void)SetUpNet
{
    [self requestWithMode:RHWebLaunchTypeHUD];
}
- (void)setUpActivityID
{
    [self requestActivityIDWith:RHWebLaunchTypeSilent];
}
- (void)requestActivityIDWith:(RHWebLaunchType)mode
{
    [LHHttpClient getActivityCountSuccess:^(AFHTTPRequestOperation *operation, id responsObject) {
        [self setupACButtonWith:responsObject];
        NSLog(@" activity resopnse === %@", responsObject);
        
        [self requestNumbersWith:RHWebLaunchTypeSilent];
        [self SetUpNet];
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [RHRequstLauchTool handleErrorFailureForView:nil lauchType:RHWebLaunchTypeHUD ToastWay:RHErrorShowTypeHUD error:error callback:^{
            
            [self requestActivityIDWith:mode];

        }];
        
    }];
}

- (void)requestWithMode:(RHWebLaunchType)mode
{
    [RHRequstLauchTool showLauchWithType:mode toView:nil];
    
    [LHHttpClient requestStatistiGetActivitOrderrCountsWithDays:_days andActivityId:_activityId Success:^(AFHTTPRequestOperation *operation, id responsObject) {
        [self configNewData:responsObject];
        [self selctDays:myIndex complete:^{
            [RHRequstLauchTool handleSuceessRequestType:mode toView:nil];
        }];
        
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [RHRequstLauchTool handleErrorFailureForView:nil lauchType:RHWebLaunchTypeHUD ToastWay:RHErrorShowTypeHUD error:error callback:^{
            [self requestWithMode:mode];
        }];
    }];
    
}
- (void)requestNumbersWith:(RHWebLaunchType)mode
{
    [LHHttpClient requestActivtyCountsWithDays:_currentDays andActivityId:_activityId Success:^(AFHTTPRequestOperation *operation, id responsObject) {
        [self configActivityNumberData:responsObject];
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [RHRequstLauchTool handleErrorFailureForView:nil lauchType:RHWebLaunchTypeHUD ToastWay:RHErrorShowTypeHUD error:error callback:^{
            [self requestNumbersWith:mode];
        }];
    }];
}

- (void)selctDays:(NSInteger)index complete:(void(^)(void))complet{
    
    if (onceTime == YES) {
        index = 0;
        myIndex = index;
        onceTime = NO;
    } else {
        myIndex = index;
    }
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


#pragma mark - ActionButton

- (IBAction)selectTypeAction:(UIButton *)sender {
    NSInteger tag = sender.tag - 1000;
    sender.selected = !sender.selected;
    switch (tag) {
        case 0:
        {
            [self setTitleColorStatusIsSelect:sender.selected lable:_allOrderTitle];
            [self setTitleColorStatusIsSelect:sender.selected lable:_allOrderNumber];
            break;
        }
        case 1:
        {
            [self setTitleColorStatusIsSelect:sender.selected lable:_compleNumber];
            [self setTitleColorStatusIsSelect:sender.selected lable:_completTitle];
            break;
        }
        case 2:
        {
            [self setTitleColorStatusIsSelect:sender.selected lable:_userCacleNumber];
            [self setTitleColorStatusIsSelect:sender.selected lable:_userCancle];
            break;
        }
        default:
            break;
    }
    [self resetDataSource:tag isSelect:sender.selected];
    
    
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
        NSArray *rightDat = [self chooseSegemeny:myIndex withdata:mode.chartListData];
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
            index = 0;
            
            _currentDays = 7;
            
            [self requestNumbersWith:RHWebLaunchTypeSilent];

            break;
        }
        case 1: {
            [chartlist removeAllObjects];
            arry = [NSArray arrayWithArray:[[arry reverseObjectEnumerator] allObjects]];
            chartlist = arry.count >= 30 ? [arry subarrayWithRange:NSMakeRange(0, 30)].mutableCopy: arry;
            chartlist = [NSMutableArray arrayWithArray:[[chartlist reverseObjectEnumerator] allObjects]];
            index = 1;
            
            _currentDays = 30;
            
            [self requestNumbersWith:RHWebLaunchTypeSilent];
            break;
        }
        case 2: {
            [chartlist removeAllObjects];
            arry = [NSArray arrayWithArray:[[arry reverseObjectEnumerator] allObjects]];
            chartlist = arry.count >= 90 ? [arry subarrayWithRange:NSMakeRange(0, 90)].mutableCopy: arry;
            chartlist = [NSMutableArray arrayWithArray:[[chartlist reverseObjectEnumerator] allObjects]];
            index = 2;
            
            _currentDays = 90;
            
            [self requestNumbersWith:RHWebLaunchTypeSilent];
        }
        default:
            break;
    }
    
    return chartlist;
}
// setTitleColorWithStatus
- (void)setTitleColorStatusIsSelect:(BOOL)select lable:(UILabel *)lable{
    lable.textColor   = select ? UIColor.lightGrayColor : UIColor.whiteColor;
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
