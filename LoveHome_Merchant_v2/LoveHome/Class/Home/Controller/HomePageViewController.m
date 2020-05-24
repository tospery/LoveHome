//
//  HomePageViewController.m
//  LoveHome
//
//  Created by MRH-MAC on 15/8/26.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomeHearView.h"
#import "OrderListViewController.h"
#import "IncomeDetailsViewController.h"
#import "SettingViewController.h"
#import "OrderAddedCell.h"
#import "NoOneNewOrderCell.h"
#import "Paging.h"
#import "Chameleon.h"
#import "ErrorHandleTool.h"
#import "BaseNavigationController.h"
#import "RHLoadView.h"
#import "TestViewController.h"
#import "Test2ViewController.h"
#import "StatistChartModel.h"
#import "NotificationViewController.h"
@interface HomePageViewController ()<UITableViewDataSource,UITableViewDelegate,HomeHearViewDeleage, UIScrollViewDelegate>
{
    BOOL driver;
}
@property (assign, nonatomic) NSInteger selectedRow;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *shopInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *shopLogo;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *shopCategory;
@property (weak, nonatomic) IBOutlet UILabel *shopServerTime;

@property (weak, nonatomic) IBOutlet UIButton *addActionBtn;
//将未响应订单修改为累计完成订单
@property (weak, nonatomic) IBOutlet UIButton *unWaiting;
//累计完成订单修改为未读消息
@property (weak, nonatomic) IBOutlet UIButton *allFinishBtn;

@property (weak, nonatomic) IBOutlet UILabel *addOrderLable;
@property (weak, nonatomic) IBOutlet UILabel *unWatingLbale;
@property (weak, nonatomic) IBOutlet UILabel *allOrderLbale;

@property (strong, nonatomic) IBOutlet UILabel *customerCount;

@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, strong) HomeHearView *heardView;
@property (nonatomic, strong) Paging *paging;
@property (nonatomic, strong) OrderModel *order;
@property (nonatomic, strong) OrderCount *count;

@property (nonatomic,strong) NSMutableArray *currentCharList;



@end

@implementation HomePageViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHomePageReload object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{

//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    driver = NO;
    //判断是不是第一次启动应用
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"newDriver"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"newDriver"];
        NSLog(@"第一次启动");
        [self makeLaunchView];
        
    }
    else
    {
        NSLog(@"不是第一次启动");
        
    }

    
    
//获取订单数量
    [self requestOrdersCount];
    [self requestCustomerCountWithMode:RHWebLaunchTypeSilent];

    [self.myTableView reloadData];
 
}
- (void)makeLaunchView{
    NSArray *arr=[NSArray arrayWithObjects:@"sh01",@"sh02",@"sh03",@"sh04", nil];//数组内存放的是我要显示的假引导页面图片
    //通过scrollView 将这些图片添加在上面，从而达到滚动这些图片
    UIScrollView *scr=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    scr.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width*arr.count, self.view.frame.size.height);
    
    
    scr.pagingEnabled = YES;
    scr.tag = 1700;
    scr.delegate=self;
    [self.view addSubview:scr];
    for (int i=0; i<arr.count; i++) {
        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(i*[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height)];
        img.image=[UIImage imageNamed:arr[i]];
        [scr addSubview:img];
        
    }
    
}
#pragma mark scrollView的代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //这里是在滚动的时候判断 我滚动到哪张图片了，如果滚动到了最后一张图片，那么
    //如果在往下面滑动的话就该进入到主界面了，我这里利用的是偏移量来判断的，当
    //一共四张图片，所以当图片全部滑完后 又像后多滑了30 的时候就做下一个动作
    if (scrollView.contentOffset.x > 3*[UIScreen mainScreen].bounds.size.width+30) {
        driver = YES;//这是我声明的一个全局变量Bool 类型的，初始值为no，当达到我需求的条件时将值改为yes
    }
}

//停止滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //判断driver为真 就要进入主界面了
    if (driver) {
        //这里添加了一个动画，（可根据个人喜好）
        [UIView animateWithDuration:1 animations:^{
            scrollView.alpha = 0;//让scrollview 渐变消失
        }completion:^(BOOL finished) {
            [scrollView  removeFromSuperview];//将scrollView移除
            
        } ];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.myTableView.header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
#pragma mark - 调用方法
    //设计界面
    [self setUpUI];

}
/*!
 *  @brief 设计界面
 */
- (void)setUpUI
{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    //导航栏设置按钮
    [button setImage:[UIImage imageNamed:@"top_ico_setup"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionSetting) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.title = @"爱为家商铺版";
    //不需要scrollView自适应屏幕
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //切边? -- 将商户头像设置为圆形
    _shopLogo.layer.cornerRadius = _shopLogo.frame.size.height / 2;
    _shopLogo.layer.masksToBounds = YES;
    _shopLogo.clipsToBounds = YES;
    
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    //tableView 无分割线
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //注册tableView的cell
    [_myTableView registerNib:[UINib nibWithNibName:@"OrderAddedCell" bundle:nil] forCellReuseIdentifier:[OrderAddedCell identifier]];
    [_myTableView registerNib:[UINib nibWithNibName:@"NoOneNewOrderCell" bundle:nil] forCellReuseIdentifier:@"NoOneNewOrderCell"];
    
    _myTableView.backgroundColor = [UIColor clearColor];
    //tableView 的 header 红色的那个图
    _heardView = [[HomeHearView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    
#pragma mark - 取消了原来的 新加个假的
    UILabel *newAddLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 80, 20)];
    newAddLabel.text = @"新增订单";
    newAddLabel.textColor = JXColorHex(0xff4400);
    newAddLabel.font = RHFontAdap(13);
    [_heardView addSubview:newAddLabel];
    
    UILabel *ssLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 33, 70, 2)];
   
    ssLabel.backgroundColor = JXColorHex(0xff4400);
    [_heardView addSubview:ssLabel];
    
    UIView *ppV = [[UIView alloc] initWithFrame:CGRectMake(0, 34, [UIScreen mainScreen].bounds.size.width, 1)];
    ppV.backgroundColor = JXColorHex(0xeeeeee);
    [_heardView addSubview:ppV];
    
    UIView *bkV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35)];
    bkV.backgroundColor = [UIColor whiteColor];
    [_heardView addSubview:bkV];
    [_heardView sendSubviewToBack:bkV];
    
    _heardView.backgroundColor = self.view.backgroundColor;
    _heardView.delegate = self;
    _myTableView.tableHeaderView = _heardView;
    [self reloadShopInfo];
    
    //刷新
    self.myTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestOrdersWithMode:JXRequestModeRefresh];
    }];
    
    
    [self.myTableView.header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHomePage:) name:kHomePageReload object:nil];
    
    self.count = [[OrderTools sharedOrderTools] fetchOrderCount];
    self.unWatingLbale.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.count.notResponseCount];
    

    //功能：延迟一段时间把一项任务提交到队列中执行，返回之后就不能取消常用来在在主队列上延迟执行一项任务
    /*!
     * @prama DISPATCH_TIME_NOW 过了多久执行的时间间隔
     * @prama quque 提交到任务队列
     * @prama block 执行的任务
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{


    });
    //打印view的子视图
    [self setNet];
}
/*!
 *  @brief 打印view的子视图
 */

- (void)setNet {
     NSLog(@"%@",self.view.subviews);
}
/*!
 * @brief 判断订单数量
 */
- (void)judgeOrderCont
{
    if (self.orders.count < 1) {
        //批量接单按钮状态
        self.heardView.allReciveOrderBtn.selected = NO;
    }
}



/*!
 *  @brief  获取订单数量
 */
- (void)requestOrdersCount
{
    //网络请求
    [OrderTools getCountWithSuccess:^(AFHTTPRequestOperation *operation, OrderCount *count) {
        self.count = count;
        [[OrderTools sharedOrderTools] storeOrderCount:self.count];
        self.addOrderLable.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.count.newlyIncreasedCount];
#pragma mark - 曾经的未响应订单数改为已完成订单数
    self.unWatingLbale.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.count.finishedCount];


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [ErrorHandleTool handleErrorWithCode:error toShowView:self.view didFinshi:^{
            
        } cancel:NULL];
        
    }];
    
    
#pragma mark ---
    [HttpServiceManageObject sendPostRequestWithPathUrl:@"general/getOrderMsgUnreadTotal" andToken:YES andParameterDic:nil andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:^(AFHTTPRequestOperation *operation, id responsObject) {
        
        NSLog(@"%ld",(long)[responsObject integerValue]);
#pragma mark - 曾经的累计已完成改为 未读消息
    self.allOrderLbale.text = [NSString stringWithFormat:@"%ld", (unsigned long)[responsObject integerValue]];
        
    } andFailedCallback:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];

}

/**
 *  获取昨日访客数量
 *
 *  @param mode 方式
 */
- (void)requestCustomerCountWithMode:(RHWebLaunchType)mode
{
    [LHHttpClient requestStatistitGetVisitersCountSuccess:^(AFHTTPRequestOperation *operation, NSMutableArray * responsObject) {
        [_currentCharList removeAllObjects];
        _currentCharList = responsObject;
        StatistChartModel *model = [[StatistChartModel alloc] init];
        model = _currentCharList.firstObject;
        NSString *count = [NSString stringWithFormat:@"%ld", (long)model.cost];
        _customerCount.text = [NSString stringWithFormat:@"昨日访客: %@", count];
        [RHRequstLauchTool handleSuceessRequestType:mode toView:nil];
        
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [RHRequstLauchTool handleErrorFailureForView:nil lauchType:mode ToastWay:RHErrorShowTypeHUD error:error callback:^{
            [self requestCustomerCountWithMode:mode];
        }];
    }];
}

/*!
 *  @brief 查看新增订单
 *
 *  @param mode
 */
- (void)requestOrdersWithMode:(JXRequestMode)mode {
    switch (mode) {
        case JXRequestModeRefresh: {
            [OrderTools getListWithType:OrderTypeAdded page:1 size:self.paging.pageSize * self.paging.currentPage success:^(AFHTTPRequestOperation *operation, OrderCollectionModel *collect) {
                if (collect.totalRows == 0 || collect.orders.count == 0) {
                    ShowWaringAlertHUD(@"没有新增订单", self.view);
                } {
                    [self handleSuccessForRefresh:self.myTableView];
                }
                
                self.paging.currentPage = collect.currentPage;
                self.paging.pageSize = (self.paging.pageSize * self.paging.currentPage);
                if (collect.currentPage < collect.totalPages) {
                 //加载下一页
                    self.myTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                        [self requestOrdersWithMode:JXRequestModeMore];
                    }];
                }else {
                    [self.myTableView.footer noticeNoMoreData];
                }
                
                [[OrderTools sharedOrderTools] storeOrders:collect.orders type:OrderTypeAdded];
                [self.orders removeAllObjects];
                [self.orders addObjectsFromArray:collect.orders];
                [self.myTableView reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [self.myTableView.header endRefreshing];
                [ErrorHandleTool handleErrorWithCode:error toShowView:self.view didFinshi:^{
                    
                } cancel:NULL];
            }];
            break;
        }
        case JXRequestModeMore: {
            [OrderTools getListWithType:OrderTypeAdded page:(self.paging.currentPage + 1) size:(self.paging.pageSize * self.paging.currentPage) success:^(AFHTTPRequestOperation *operation, OrderCollectionModel *collect) {
                self.paging.currentPage = collect.currentPage;
                self.paging.pageSize = self.paging.pageSize * self.paging.currentPage;
                if (collect.currentPage < collect.totalPages) {
                    self.myTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                        [self requestOrdersWithMode:JXRequestModeMore];
                    }];
                }else {
                    [self.myTableView.footer noticeNoMoreData];
                }
                
                [self.orders exInsertObjects:collect.orders atIndex:self.orders.count unduplicated:YES];
                [self.myTableView reloadData];
                
                [self handleSuccessForMore:self.myTableView];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [self.myTableView.footer endRefreshing];
                [ErrorHandleTool handleErrorWithCode:error toShowView:self.view didFinshi:^{
                    
                } cancel:NULL];
            }];
            break;
        }
        default:
            break;
    }
}
#pragma mark - 之前的接单  应该 调用 收衣的接口
/*!
 * @brief 接受订单
 */
- (void)requestAccept:(OrderModel *)order {
    JXHUDProcessing(nil);
// 此处调用收衣的接口 服务器 只返回状态
    
    [OrderTools confirmOrderClothes:order.orderid success:^(AFHTTPRequestOperation *operation, NSNumber *result) {
        [self handleSuccessForHUD];
#warning 此处应该做修改
        //[self.orders removeObject:order];
        [self judgeOrderCont];
        
        
        // test
        [self  requestOrdersCount];
        //弹出提示框
        
        JXToast(@"确认收件成功");
        [[OrderTools sharedOrderTools] storeOrders:self.orders type:2];
        [self.myTableView reloadData];
        [self requestOrdersWithMode:JXRequestModeRefresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //小菊花隐藏..
        JXHUDHide()
        [ErrorHandleTool handleErrorWithCode:error toShowView:self.view didFinshi:^{
            
        } cancel:NULL];
    }];
}

- (NSMutableArray *)orders {
    if (!_orders) {
        _orders = [NSMutableArray array];
        [_orders addObjectsFromArray:[[OrderTools sharedOrderTools] fetchOrdersWithType:OrderTypeAdded]];
    }
    return _orders;
}

- (Paging *)paging {
    if (!_paging) {
        _paging = [[Paging alloc] init];
        _paging.onceToken = NO;
        _paging.currentPage = 1;
        _paging.pageSize = 10;
    }
    return _paging;
}


- (void)reloadShopInfo
{
    if ([UserTools sharedUserTools].userModel != nil) {
        
        UserDataModel *user = [UserTools sharedUserTools].userModel;
        _shopName.text = user.shopName;
        _shopCategory.text =user.businessScopes;
        _shopServerTime.text = user.serviceTime;
        [ImageTool downloadImage:user.shopLogo placeholder:nil imageView:_shopLogo];
    }
}
/*!
 * @brief 重载
 */
- (void)reloadHomePage:(NSNotification *)notification
{
    [self reloadShopInfo];
    [self.orders removeAllObjects];

    if ([UserTools sharedUserTools].userModel != nil)
    {
        
        [self.myTableView reloadData];
    }

     
    __weak HomePageViewController *weak = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weak.myTableView.header beginRefreshing];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.orders.count <1) {
        return 1;
    }
    return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (self.orders.count < 1) {
     
        NoOneNewOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoOneNewOrderCell"];
        return cell;
        
    }
    else
    {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderAddedCell identifier]];
        
        
    [(OrderAddedCell *)cell configOrder:self.orders[indexPath.row]];
    [(OrderAddedCell *)cell setupFuncBlock:^(UIButton *button, OrderModel *order) {
        if (0 == button.tag) {
            NSLog(@"点击确认收件");
            [self requestAccept:self.orders[indexPath.row]];
            
 
        }
    }];
    ;
    return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.orders.count < 1) {
        return self.myTableView.height ;
    }
    return [OrderAddedCell height];
}


#pragma mark -- homeHearViewDeleageOrderDetail

//首页 -- 新增订单
- (IBAction)addNewAction:(id)sender
{
    OrderListViewController *orderVC = [[OrderListViewController alloc] initWithType:OrderTypeAdded];
    [self.navigationController pushViewController:orderVC animated:YES];

}
//首页 -- 未响应订单(待修改)
//点击事件修改为进入 "已完成"
- (IBAction)unwationAction:(id)sender {
    
    OrderListViewController *orderVC = [[OrderListViewController alloc] initWithType:3];
    [self.navigationController pushViewController:orderVC animated:YES];

}
//首页 -- 累计完成订单(待修改)
- (IBAction)allFinishAction:(id)sender
{
//    OrderListViewController *orderVC = [[OrderListViewController alloc] initWithType:3];
//    [self.navigationController pushViewController:orderVC animated:YES];
#pragma mark - 新的修改 进入 消息通知 页面
    NotificationViewController *notificationVC = [[NotificationViewController alloc] init];
    [self.navigationController pushViewController:notificationVC animated:YES];


}


// 收入明细
- (void)homeHearViewDeleageOrderDetail:(UIButton *)sender
{

    IncomeDetailsViewController *detail = [[IncomeDetailsViewController alloc] init];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];

}



- (void)homeHearViewDeleageOrderList:(UIButton *)sender
{
    OrderListViewController *orderVC = [[OrderListViewController alloc] initWithType:OrderTypeAdded];
    [self.navigationController pushViewController:orderVC animated:YES];
}


- (void)homeHearViewDeleageWaittingOrder:(UIButton *)sender
{
//    OrderListViewController *orderVC = [[OrderListViewController alloc] initWithType:OrderTypeUnhandled];
//    [self.navigationController pushViewController:orderVC animated:YES];
}


- (void)homeHearViewDeleageSelectAll:(UIButton *)sender
{
    if (self.orders.count < 1) {
        ShowWaringAlertHUD(@"暂无新增订单", nil);
        return;
    }
    sender.selected = !sender.selected;
    [self.orders enumerateObjectsUsingBlock:^(OrderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = sender.selected;
    }];
    
    [_myTableView reloadData];
    
}

#pragma mark - 设置按钮点击事件
- (void)actionSetting
{
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (alertView.cancelButtonIndex == buttonIndex || !self.order) {
//        return;
//    }
//    
//    UITextField *textField = [alertView textFieldAtIndex:0];
//    if (textField.text.length == 0) {
//        JXToast(@"必须填写拒绝理由");
//        return;
//    }
//    
//    [self requestRejectWithReason:textField.text];
#pragma mark - 此处修改为是否确认收衣
//    if (buttonIndex == 1) {
//        NSLog(@"点击确定按钮");
//        [self requestAccept:self.orders[self.selectedRow]];
//        self.order.collectedByMerchant = 1;
//
//    } else {
//        NSLog(@"点击取消按钮");
//    }
}

@end
