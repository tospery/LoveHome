//
//  OrderViewController.m
//  LoveHome
//
//  Created by 杨建祥 on 15/8/27.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderCollectionModel.h"
#import "OrderCommonCell.h"
#import "Paging.h"
#import "OrderFinishCell.h"
#import "OrderRejectCell.h"
#import "IncomeDetailsViewController.h"
#import "OrderDetailViewController.h"
#import "ErrorHandleTool.h"
#import "MJRefresh.h"

@interface OrderListViewController ()
@property (nonatomic, assign) NSInteger isHScrolling;

//订单状态
@property (nonatomic, assign) OrderType type;
//订单model
@property (nonatomic, strong) OrderModel *order;
//全部订单数组
@property (nonatomic, strong) NSArray *allOrders;
//tableView的高度
@property (nonatomic, assign) CGFloat tableHeight;

@property (nonatomic, strong) NSMutableArray *loadingBgViews;
@property (nonatomic, strong) NSMutableArray *pageInfos;

//@property (nonatomic, weak) IBOutlet UITableView *tableView;

//tabelView的数组, 用哪个取那个
@property (nonatomic, strong) IBOutletCollection(UITableView) NSArray *tableViews;
//seg
@property (nonatomic, weak) IBOutlet HMSegmentedControl *segmentedControl;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger iii;

@property (nonatomic, assign) BOOL onceTokenForRefresh;
@end

@implementation OrderListViewController
#pragma mark - Override methods

-(void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initVar];
    [self initView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.onceTokenForRefresh) {
        self.onceTokenForRefresh = YES;
    }else {
        [[self getCurrrentTableView].header beginRefreshing];
    }

}

#pragma mark - Private methods
#pragma mark init
- (void)initVar {
    self.tableHeight = kJXMetricScreenHeight - 64 - 44;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)initView {
    self.navigationItem.title = @"订单列表";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"收入明细" style:UIBarButtonItemStylePlain target:self action:@selector(detailItemPressed:)];
#pragma mark - 配置 segmentedControl
    self.segmentedControl.sectionTitles = @[@"新增", @"服务中",@"已完成", @"已取消"];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : COLOR_HEX(0x333333), NSFontAttributeName: [UIFont systemFontOfSize:14]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : COLOR_HEX(0xff4400), NSFontAttributeName: [UIFont systemFontOfSize:14]};
    self.segmentedControl.selectionIndicatorColor = COLOR_HEX(0xEB0E1B);
    self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.selectionIndicatorHeight = 1.5f;
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, weakSelf.tableHeight) animated:YES];
       [[self getCurrrentTableView].header beginRefreshing];
        if (index == 5) {
            index = 2;
        }
        [weakSelf handleEntry:(index + 1)];
    }];
    
    //加载tableView的cell
    // 新增, 未响应, 去收衣, 服务中
    UINib *cellNib = [UINib nibWithNibName:@"OrderCommonCell" bundle:nil];
    for (int i = 0; i < 2; ++i) {
        [self.tableViews[i] registerNib:cellNib forCellReuseIdentifier:[OrderCommonCell identifier]];
    }
    //已完成
    cellNib = [UINib nibWithNibName:@"OrderFinishCell" bundle:nil];
    [self.tableViews[2] registerNib:cellNib forCellReuseIdentifier:[OrderFinishCell identifier]];
    //已拒绝---  已取消
    cellNib = [UINib nibWithNibName:@"OrderRejectCell" bundle:nil];
    [self.tableViews[3] registerNib:cellNib forCellReuseIdentifier:[OrderRejectCell identifier]];
    
    for (UITableView *tableView in self.tableViews) {
            tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [self requestOrdersWithMode:JXRequestModeRefresh];
        }];
    }
    
    //延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.segmentedControl setSelectedSegmentIndex:(self.type - 1) animated:NO notify:YES];
    });

    
    
//    [[self getCurrrentTableView].header beginRefreshing];

}

//- (void)initDB {
//    [self fetchCurrentOrdersFromLocal];
//    if ([self getCurrentOrders].count != 0) {
//        [[self getCurrrentTableView] reloadData];
//    }
//}
//
//- (void)initNet {
//    [[self getCurrrentTableView].header beginRefreshing];
//}

#pragma mark db
//貌似没什么用
- (void)fetchCurrentOrdersFromLocal {
    
    [[self getCurrentOrders] addObjectsFromArray:[[OrderTools sharedOrderTools] fetchOrdersWithType:self.type]];
}

#pragma mark web
//网络请求
- (void)requestOrdersWithMode:(JXRequestMode)mode {
    Paging *pageInfo = [self getCurrentPageInfo];
    UIView *loadingBgView = [self getCurrentLoadingBgView];
    NSMutableArray *orders = [self getCurrentOrders];
    
    switch (mode) {
        case JXRequestModeRefresh: {
            ShowProgressHUD(YES, self.view);
            [OrderTools getListWithType:self.type page:1 size:(pageInfo.pageSize * pageInfo.currentPage) success:^(AFHTTPRequestOperation *operation, OrderCollectionModel *collect) {
                
                if ((collect.totalRows == 0 || collect.orders.count == 0) && collect.orders.count == 0) {
                    [self getCurrrentTableView].tableHeaderView = loadingBgView;
                    
                    [ErrorHandleTool handleLoadViewWithCode:[JXError errorWithCode:JXErrorCodeDataEmpty description:@"没有相应的订单"] toShowView:loadingBgView didFinshi:NULL cancel:NULL];
                    
                }else {
                    [self getCurrrentTableView].tableHeaderView = nil;
                    [JXLoadingView hideForView:loadingBgView];
                }
                
                pageInfo.currentPage = collect.currentPage;
                pageInfo.pageSize = collect.pageSize;
                if (collect.currentPage < collect.totalPages) {
                    [self getCurrrentTableView].footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                        [self requestOrdersWithMode:JXRequestModeMore];
                    }];

                }else {
                    [[self getCurrrentTableView].footer noticeNoMoreData];
                }
                
                [[OrderTools sharedOrderTools] storeOrders:collect.orders type:self.type];
                
                [orders removeAllObjects];
                [orders addObjectsFromArray:collect.orders];
                [[self getCurrrentTableView] reloadData];
                
                [self handleSuccessForRefresh:[self getCurrrentTableView]];
                ShowProgressHUD(NO, self.view);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                ShowProgressHUD(NO, self.view);

                [self getCurrrentTableView].tableHeaderView = loadingBgView;
                [[self getCurrrentTableView].header endRefreshing];
                 [ErrorHandleTool handleLoadViewWithCode:error toShowView:loadingBgView didFinshi:^{
                     [self requestOrdersWithMode:mode];
                 } cancel:NULL];
                    

            }];
            break;
        }
        case JXRequestModeMore: {
            ShowProgressHUD(YES, self.view);
            [OrderTools getListWithType:self.type page:(pageInfo.currentPage + 1) size:pageInfo.pageSize success:^(AFHTTPRequestOperation *operation, OrderCollectionModel *collect) {
                pageInfo.currentPage = collect.currentPage;
                pageInfo.pageSize = collect.pageSize;
                if (collect.currentPage < collect.totalPages) {
                    [self getCurrrentTableView].footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                        [self requestOrdersWithMode:JXRequestModeMore];
                    }];
                }else {
                    [[self getCurrrentTableView].footer noticeNoMoreData];
                }
                
                [orders exInsertObjects:collect.orders atIndex:orders.count unduplicated:YES];
                [[self getCurrrentTableView] reloadData];
                
                [self handleSuccessForMore:[self getCurrrentTableView]];
                ShowProgressHUD(NO, self.view);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                ShowProgressHUD(NO, self.view);

                [[self getCurrrentTableView].footer endRefreshing];
                [ErrorHandleTool handleErrorWithCode:error toShowView:[self getCurrrentTableView] didFinshi:^{
                    
                } cancel:NULL];
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark 接受订单 --- 现已修改为确认收衣
- (void)requestAccept:(OrderModel *)order WithIndex:(NSIndexPath *)indexPath {
    JXHUDProcessing(nil);
    [OrderTools confirmOrderClothes:order.orderid success:^(AFHTTPRequestOperation *operation, NSNumber *result) {
        [self handleSuccessForHUD];
        self.order.collectedByMerchant = 1;
       // [[self getCurrentOrders] removeObject:order];
        [[self getCurrrentTableView] reloadData];
//        [[self getCurrrentTableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        JXHUDHide()
        [ErrorHandleTool handleErrorWithCode:error toShowView:nil didFinshi:^{
            
        } cancel:NULL];
    }];
}


// 确认收衣
- (void)clickRcetOrderClothesWithCell:(OrderCommonCell *)cell order:(OrderModel *)order
{
    ShowProgressHUD(YES, self.view);
    // 这里要区分是未响应的收衣 还是去收衣的收以
    
    if (order.status == 12) {
        
        [OrderTools confirmOrderClothesWithWating:order.orderid success:^(AFHTTPRequestOperation *operation, id responsObject) {
            
            ShowProgressHUD(NO, self.view);
            cell.acceptButton.enabled = NO;
#pragma mark - 只是暂时写为1 , 具体的再改

            order.collectedByMerchant = 1;

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            ShowProgressHUD(NO, self.view);
            [ErrorHandleTool handleErrorWithCode:error toShowView:nil didFinshi:^{
                
            } cancel:NULL];

        }];
        
    }
    else
    {
    
    [OrderTools confirmOrderClothes:order.orderid success:^(AFHTTPRequestOperation *operation, id responsObject) {
        
        ShowProgressHUD(NO, self.view);
        cell.acceptButton.enabled = NO;
#pragma mark - 只是暂时写为1 , 具体的再改

        order.collectedByMerchant = 1;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        ShowProgressHUD(NO, self.view);
        [ErrorHandleTool handleErrorWithCode:error toShowView:nil didFinshi:^{
            
        } cancel:NULL];
        
    }];
    }
    
}


#pragma mark assist
- (NSMutableArray *)getCurrentOrders {
   // NSLog(@"%ld",self.type - 1);
    return [self.allOrders objectAtIndex:(self.type - 1)];
}

- (UIView *)getCurrentLoadingBgView {
   // NSLog(@"%ld",self.type - 1);
    return [self.loadingBgViews objectAtIndex:(self.type - 1)];
}

- (Paging *)getCurrentPageInfo {
   // NSLog(@"%ld",self.type - 1);
    return [self.pageInfos objectAtIndex:(self.type - 1)];
}

- (UITableView *)getCurrrentTableView {
   // NSLog(@"%ld",self.type - 1);
    return [self.tableViews objectAtIndex:(self.type - 1)];
}

- (void)handleEntry:(OrderType)type {
    self.type = type;

    if ([self getCurrentOrders].count == 0) {
//        [self fetchCurrentOrdersFromLocal];
    }
    
    if ([self getCurrentOrders].count != 0) {
        [[self getCurrrentTableView] reloadData];
    }
    
    if ([self getCurrentPageInfo].onceToken == NO) {
         [[self getCurrrentTableView].header beginRefreshing];
        [self getCurrentPageInfo].onceToken = YES;
    }
}
//拨打电话
- (void)makeCall:(OrderModel *)order {
    [JXDevice callNumber:order.customerTelephone];
}
//其中的取消订单 功能已经失效
- (OrderCommonCell *)getReClothesOrderCellTabale:(UITableView *)tableView withType:(OrderType)type order:(OrderModel *)order
{
    OrderCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderCommonCell identifier]];
    [cell configOrder:order type:type];
    [cell setupButtonPressedBlock:^(UIButton *button, OrderModel *order, NSInteger cancelable) {
        if (0 == button.tag) {
            [self makeCall:order];
            
        }else if (1 == button.tag) {
            self.order = order;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请添加拒绝理由" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert show];
        }else {
            
            [self clickRcetOrderClothesWithCell:cell order:order];
        }
    }];
    return cell;

}

#pragma mark - Accessor methods
- (NSArray *)allOrders {
    if (!_allOrders) {
        _allOrders = @[[NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array],[NSMutableArray array]];
    }
    return _allOrders;
}
//背景图吗?
- (NSMutableArray *)loadingBgViews {
    if (!_loadingBgViews) {
        _loadingBgViews = [NSMutableArray array];
        for (int i = 0; i < 4; ++i) {
            UIView *view = [UIView new];
            view.backgroundColor = JXColorHex(0xF4F4F4);
            view.frame = CGRectMake(0, 0, kJXMetricScreenWidth, self.tableHeight);
            [_loadingBgViews addObject:view];
        }
    }
    return _loadingBgViews;
}

- (NSMutableArray *)pageInfos {
    if (!_pageInfos) {
        _pageInfos = [NSMutableArray array];
        for (int i = 0; i < 4; ++i) {
            Paging *pi = [Paging new];
            pi.onceToken = NO;
            pi.currentPage = 1;
            pi.pageSize = 10;
            [_pageInfos addObject:pi];
        }
    }
    return _pageInfos;
}

#pragma mark - Action methods
//- (void)detailItemPressed:(id)sender {
//    IncomeDetailsViewController *detail = [[IncomeDetailsViewController alloc] init];
//    [self.navigationController pushViewController:detail animated:YES];
//}



#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger currentTag = tableView.tag - 1000;
    if (currentTag == self.type) {
        return [self getCurrentOrders].count;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger currentTag = tableView.tag - 1000;
    if (currentTag == OrderTypeFinished) {
        return [OrderFinishCell heightForOrder:[self getCurrentOrders][indexPath.row]];
    }else if (currentTag == OrderTypeRejected) {
        return [OrderRejectCell heightForOrder:[self getCurrentOrders][indexPath.row]];
    }else {
        return [OrderCommonCell heightForOrder:[self getCurrentOrders][indexPath.row]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger currentTag = tableView.tag - 1000;
    //已完成
    if (currentTag == 3 /*OrderTypeFinished*/) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderFinishCell identifier]];
        [(OrderFinishCell *)cell configOrder:[self getCurrentOrders][indexPath.row]];
        [(OrderFinishCell *)cell setupButtonPressedBlock:^(UIButton *button) {
            [self makeCall:[self getCurrentOrders][indexPath.row]];
        }];
        return cell;
        //已取消
    }else if (currentTag == 4 /*OrderTypeRejected*/) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderRejectCell identifier]];
        [(OrderRejectCell *)cell configOrder:[self getCurrentOrders][indexPath.row]];
        [(OrderRejectCell *)cell setupButtonPressedBlock:^(UIButton *button) {
            [self makeCall:[self getCurrentOrders][indexPath.row]];
        }];
        return cell;
    }
    //服务中
    else if (currentTag == 2 /*OrderTypeRectClothes*/)
    {
        OrderCommonCell *cell = [self getReClothesOrderCellTabale:tableView withType:OrderTypehandled order:[self getCurrentOrders][indexPath.row]];
        return cell;
    }
    
    // 未响应和新增
    else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderCommonCell identifier]];
        OrderModel *order = [self getCurrentOrders][indexPath.row];
        
            [(OrderCommonCell *)cell configOrder:order type:self.type];
            
            [(OrderCommonCell *)cell setupButtonPressedBlock:^(UIButton *button, OrderModel *order, NSInteger cancelable) {
                //根据 button的tag判断 点击的是 收衣还是 打电话
                if (0 == button.tag) {
                    [self makeCall:[self getCurrentOrders][indexPath.row]];
                }else {
                   #pragma mark - 此处调用确认收衣的 方法
                    self.order = order;
                    order.collectedByMerchant = 1;
                    order.cancelable = cancelable;
                    [self requestAccept:[self getCurrentOrders][indexPath.row] WithIndex:indexPath];
                    
                }
            }];
            return cell;
    }
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    __weak __typeof(self)weakSelf = self;
    OrderDetailViewController *detail = [[OrderDetailViewController alloc] initWithOrder:[self getCurrentOrders][indexPath.row] withOrderType:_type];
    detail.hidesBottomBarWhenPushed = YES;

    
    detail.leftActionBlcok = ^(OrderModel *order,OrderType type){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        strongSelf.type = type;
        [[strongSelf getCurrentOrders] removeObject:order];
        [[OrderTools sharedOrderTools] storeOrders:[self getCurrentOrders] type:self.type];
        [[self getCurrrentTableView] reloadData];

    };
    
    detail.rightActionBlcok = ^(OrderModel *order,OrderType type){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        self.type = type;
        [[strongSelf getCurrentOrders] removeObject:order];
        [[OrderTools sharedOrderTools] storeOrders:[strongSelf getCurrentOrders] type:strongSelf.type];
        [[self getCurrrentTableView] reloadData];
        
    };
    
    [self.navigationController pushViewController:detail animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.cancelButtonIndex == buttonIndex || !self.order) {
        return;
    }
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    if (textField.text.length == 0) {
        JXToast(@"必须填写拒绝理由");
        return;
    }
    


}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x != 0 && scrollView.contentOffset.y == 0) {
        self.isHScrolling = YES;
    }else {
        self.isHScrolling = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!self.isHScrolling) {
        return;
    }
    
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES notify:YES];
}

#pragma mark - Public methods 
- (instancetype)initWithType:(OrderType)type {
    if (self = [self init]) {
        _type = type;
    }
    return self;
}
@end








