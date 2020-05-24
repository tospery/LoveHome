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

@property (nonatomic, assign) OrderType type;
@property (nonatomic, strong) OrderModel *order;
@property (nonatomic, strong) NSArray *allOrders;

@property (nonatomic, assign) CGFloat tableHeight;
@property (nonatomic, strong) NSMutableArray *loadingBgViews;
@property (nonatomic, strong) NSMutableArray *pageInfos;

//@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutletCollection(UITableView) NSArray *tableViews;
@property (nonatomic, weak) IBOutlet HMSegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@end

@implementation OrderListViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initVar];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
//    // self.segmentedControl.sectionTitles = @[@"新增(0)", @"未响应(0)", @"已受理", @"已完成", @"已拒绝"];
//    
//    NSString *addStr = [NSString stringWithFormat:@""];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Private methods
#pragma mark init
- (void)initVar {
    self.tableHeight = kJXMetricScreenHeight - 64 - 44;
   
}

- (void)initView {
    self.navigationItem.title = @"订单列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"收入明细" style:UIBarButtonItemStylePlain target:self action:@selector(detailItemPressed:)];
    
    self.segmentedControl.sectionTitles = @[@"新增", @"未响应",@"去收衣",@"已受理",@"已完成", @"已拒绝"];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : COLOR_HEX(0x333333), NSFontAttributeName: [UIFont systemFontOfSize:14]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : COLOR_HEX(0xEB0E1B), NSFontAttributeName: [UIFont systemFontOfSize:14]};
    self.segmentedControl.selectionIndicatorColor = COLOR_HEX(0xEB0E1B);
    self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.selectionIndicatorHeight = 1.5f;
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, weakSelf.tableHeight) animated:YES];

        [weakSelf handleEntry:(index + 1)];


       
    }];
    
    UINib *cellNib = [UINib nibWithNibName:@"OrderCommonCell" bundle:nil];
    for (int i = 0; i < 4; ++i) {
        [self.tableViews[i] registerNib:cellNib forCellReuseIdentifier:[OrderCommonCell identifier]];
    }
    
    cellNib = [UINib nibWithNibName:@"OrderFinishCell" bundle:nil];
    [self.tableViews[4] registerNib:cellNib forCellReuseIdentifier:[OrderFinishCell identifier]];
    
    cellNib = [UINib nibWithNibName:@"OrderRejectCell" bundle:nil];
    [self.tableViews[5] registerNib:cellNib forCellReuseIdentifier:[OrderRejectCell identifier]];
    
    for (UITableView *tableView in self.tableViews) {
//        [tableView addLegendHeaderWithRefreshingBlock:^{
//
//        }];
        
            tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [self requestOrdersWithMode:JXRequestModeRefresh];
        }];
    }
    
    
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
- (void)fetchCurrentOrdersFromLocal {
    
    [[self getCurrentOrders] addObjectsFromArray:[[OrderTools sharedOrderTools] fetchOrdersWithType:self.type]];
}

#pragma mark web
- (void)requestOrdersWithMode:(JXRequestMode)mode {
    Paging *pageInfo = [self getCurrentPageInfo];
    UIView *loadingBgView = [self getCurrentLoadingBgView];
    NSMutableArray *orders = [self getCurrentOrders];
    
    switch (mode) {
        case JXRequestModeRefresh: {
            [OrderTools getListWithType:self.type page:1 size:(pageInfo.pageSize * pageInfo.currentPage) success:^(AFHTTPRequestOperation *operation, OrderCollectionModel *collect) {
                if (collect.totalRows == 0 || collect.orders.count == 0) {
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
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self getCurrrentTableView].tableHeaderView = loadingBgView;
                [[self getCurrrentTableView].header endRefreshing];
                 [ErrorHandleTool handleLoadViewWithCode:error toShowView:loadingBgView didFinshi:^{
                     [self requestOrdersWithMode:mode];
                 } cancel:NULL];
                    

            }];
            break;
        }
        case JXRequestModeMore: {
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
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                
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

#pragma mark 接受订单
- (void)requestAccept:(OrderModel *)order WithIndex:(NSIndexPath *)indexPath {
    JXHUDProcessing(nil);
    [OrderTools acceptWithOrderid:order.orderid success:^(AFHTTPRequestOperation *operation, NSNumber *result) {
        [self handleSuccessForHUD];
        [[self getCurrentOrders] removeObject:order];
        [[self getCurrrentTableView] reloadData];
//        [[self getCurrrentTableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        JXHUDHide()
        [ErrorHandleTool handleErrorWithCode:error toShowView:nil didFinshi:^{
            
        } cancel:NULL];
    }];
}

#pragma mark 拒绝Order
- (void)requestReject:(OrderModel *)order reason:(NSString *)reason {
    JXHUDProcessing(nil);
    [OrderTools rejectWithOrderid:order.orderid reason:reason success:^(AFHTTPRequestOperation *operation, NSNumber *result) {
        [self handleSuccessForHUD];
        [[self getCurrentOrders] removeObject:order];
        [[OrderTools sharedOrderTools] storeOrders:[self getCurrentOrders] type:self.type];
        [[self getCurrrentTableView] reloadData];
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
            order.collectedByMerchant = YES;

            
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
        order.collectedByMerchant = YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        ShowProgressHUD(NO, self.view);
        [ErrorHandleTool handleErrorWithCode:error toShowView:nil didFinshi:^{
            
        } cancel:NULL];
        
    }];
    }
    
}


#pragma mark assist
- (NSMutableArray *)getCurrentOrders {
    return [self.allOrders objectAtIndex:(self.type - 1)];
}

- (UIView *)getCurrentLoadingBgView {
    return [self.loadingBgViews objectAtIndex:(self.type - 1)];
}

- (Paging *)getCurrentPageInfo {
    return [self.pageInfos objectAtIndex:(self.type - 1)];
}

- (UITableView *)getCurrrentTableView {
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

- (void)makeCall:(OrderModel *)order {
    [JXDevice callNumber:order.customerTelephone];
}

- (OrderCommonCell *)getReClothesOrderCellTabale:(UITableView *)tableView withType:(OrderType)type order:(OrderModel *)order
{
    OrderCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderCommonCell identifier]];
    [cell configOrder:order type:type];
    [cell setupButtonPressedBlock:^(UIButton *button) {
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

- (NSMutableArray *)loadingBgViews {
    if (!_loadingBgViews) {
        _loadingBgViews = [NSMutableArray array];
        for (int i = 0; i < 6; ++i) {
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
        for (int i = 0; i < 6; ++i) {
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
- (void)detailItemPressed:(id)sender {
    IncomeDetailsViewController *detail = [[IncomeDetailsViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}



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
    if (currentTag == OrderTypeFinished) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderFinishCell identifier]];
        [(OrderFinishCell *)cell configOrder:[self getCurrentOrders][indexPath.row]];
        [(OrderFinishCell *)cell setupButtonPressedBlock:^(UIButton *button) {
            [self makeCall:[self getCurrentOrders][indexPath.row]];
        }];
        return cell;
    }else if (currentTag == OrderTypeRejected) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderRejectCell identifier]];
        [(OrderRejectCell *)cell configOrder:[self getCurrentOrders][indexPath.row]];
        [(OrderRejectCell *)cell setupButtonPressedBlock:^(UIButton *button) {
            [self makeCall:[self getCurrentOrders][indexPath.row]];
        }];
        return cell;
    }
    else if (currentTag == OrderTypeRectClothes)
    {
        OrderCommonCell *cell = [self getReClothesOrderCellTabale:tableView withType:OrderTypeRectClothes order:[self getCurrentOrders][indexPath.row]];
        return cell;
    }
    
    // 未响应和新增
    else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderCommonCell identifier]];
        OrderModel *order = [self getCurrentOrders][indexPath.row];
        
        // 收衣未响应 确认收衣
        if (order.status == 12) {
    
           OrderCommonCell *cell =  [self getReClothesOrderCellTabale:tableView withType:OrderTypeRectClothes order:order];
            return cell;
        }
        else
        {
            [(OrderCommonCell *)cell configOrder:order type:self.type];
            
            [(OrderCommonCell *)cell setupButtonPressedBlock:^(UIButton *button) {
                if (0 == button.tag) {
                    [self makeCall:[self getCurrentOrders][indexPath.row]];
                }else if (1 == button.tag) {
                    self.order = [self getCurrentOrders][indexPath.row];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请添加拒绝理由" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                    [alert show];
                }else {
                    [self requestAccept:[self getCurrentOrders][indexPath.row] WithIndex:indexPath];
                }
            }];
            return cell;

        }
        
        
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
    
   

    if (self.type == OrderTypeRectClothes || self.order.status == 12) {
        
        ShowProgressHUD(YES, nil);
        [OrderTools rejectClothesWithOrderid:self.order.orderid reason:textField.text success:^(AFHTTPRequestOperation *operation, id responsObject) {
            
            ShowProgressHUD(NO, nil);
            [[self getCurrentOrders] removeObject:self.order];
            [[self getCurrrentTableView] reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            ShowProgressHUD(NO, nil);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [ErrorHandleTool handleErrorWithCode:error toShowView:nil didFinshi:^{
                    
                } cancel:NULL];
            });
            
        }];
        
        
        return;
    }
    

    [self requestReject:self.order reason:textField.text];


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








