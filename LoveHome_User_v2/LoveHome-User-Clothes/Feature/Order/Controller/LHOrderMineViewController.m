//
//  LHOrderMineViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/7.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHOrderMineViewController.h"
#import "LHOrderCashierViewController.h"
#import "LHOrderDetailViewController.h"
#import "LHOperationSuccessViewController.h"
#import "LHCommentViewController.h"
#import "LHShopHeader.h"
#import "LHSpecifyCell.h"
#import "LHOrderFooter.h"
#import "LHShopDetailViewController.h"

@interface LHOrderMineViewController ()
@property (nonatomic, assign) BOOL onceToken;

@property (nonatomic, assign) BOOL isHScrolling;

@property (nonatomic, assign) BOOL onceTokenPay;
@property (nonatomic, assign) BOOL onceTokenHandle;
@property (nonatomic, assign) BOOL onceTokenCollect;
@property (nonatomic, assign) BOOL onceTokenService;
@property (nonatomic, assign) BOOL onceTokenFinish;
@property (nonatomic, assign) BOOL onceTokenCancel;

@property (nonatomic, strong) NSArray *pages;
@property (nonatomic, strong) NSArray *orders;

@property (nonatomic, assign) CGRect tableRect;
@property (nonatomic, assign) CGFloat scrollViewHeight;

//@property (nonatomic, strong) NSArray *items;
//@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet HMSegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutletCollection(UITableView) NSArray *tableViews;

@property (nonatomic, assign) LHOrderActionType actionTypeForConfirm;
@property (nonatomic, strong) LHOrder *actionOrderForConfirm;
@end

@implementation LHOrderMineViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [JXLoadViewManager setBackgroundColor:JXColorHex(0xF4F4F4)];
    [self setupView];
    [self setupDB];
    [self setupNet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [JXLoadViewManager setBackgroundColor:JXColorHex(0xF4F4F4)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [JXLoadViewManager setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupView {
    self.navigationItem.title = @"我的订单";
    self.navigationItem.leftBarButtonItem = CreateBackBarItem(self);
    
    // @[@"待支付", @"待受理", @"收衣中", @"服务中", @"已完成", @"已取消"]; // 不用再请求3个数据，2的数据会包含3的数据
    self.segmentedControl.sectionTitles = @[@"待支付", @"待服务", @"服务中", @"已完成", @"已取消"];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : ColorHex(0x333333), NSFontAttributeName: [UIFont systemFontOfSize:14]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : ColorHex(0x25BAB9), NSFontAttributeName: [UIFont systemFontOfSize:14]};
    self.segmentedControl.selectionIndicatorColor = ColorHex(0x25BAB9);
    //self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 7, 0, 7);
    self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.selectionIndicatorHeight = 1.5f;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
//        if (index >= self.type) {
//            if (index >= 2) {
//                self.type = (index + 2);
//            }else {
//               self.type = (index + 1);
//            }
//        }else {
////            if (index == 2) {
////                self.type = (index + 2);
////            }else {
////                self.type = (index + 1);
////            }
//            
//            self.type = (index + 1);
//        }
        
//        if (index >= 2) {
//            self.type = (index + 2);
//        }else {
//            self.type = (index + 1);
//        }
        
        self.type = (index + 1);
        
        [self.scrollView scrollRectToVisible:CGRectMake(kScreenWidth * index, 0, kScreenWidth, self.scrollViewHeight) animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (![self launchLoadRequestIfNeed]) {
                [self requestOrdersWithMode:JXWebLaunchModeSilent];
            }
        });
    }];
    
    UINib *cellNib = [UINib nibWithNibName:@"LHSpecifyCell" bundle:nil];
    UINib *headerNib = [UINib nibWithNibName:@"LHShopHeader" bundle:nil];
    UINib *footerNib = [UINib nibWithNibName:@"LHOrderFooter" bundle:nil];
    for (UITableView *tableView in self.tableViews) {
        [tableView registerNib:cellNib forCellReuseIdentifier:[LHSpecifyCell identifier]];
        [tableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:[LHShopHeader identifier]];
        [tableView registerNib:footerNib forHeaderFooterViewReuseIdentifier:[LHOrderFooter identifier]];
        
        tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestOrdersWithMode:JXWebLaunchModeRefresh];
        }];
        tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self requestOrdersWithMode:JXWebLaunchModeMore];
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyOrderPayed:) name:kNotifyOrderPayed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyOrderCanceled:) name:kNotifyOrderCanceled object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyOrderReceived:) name:kNotifyOrderReceived object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyOrderDeleted:) name:kNotifyOrderDeleted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyOrderCommented:) name:kNotifyOrderCommented object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyOrderConfirm:) name:kNotifyOrderConfirm object:nil];
}

- (void)setupDB {
}

- (void)setupNet {
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //[self launchLoadRequestIfNeed];
    //});
    //[self launchLoadRequestIfNeed];
    
    if (self.type == LHOrderRequestTypePay) {
        [self launchLoadRequestIfNeed];
    }else {
        [self.segmentedControl setSelectedSegmentIndex:(self.type - 1) animated:NO];
        self.scrollView.contentOffset = CGPointMake(kScreenWidth * (self.type - 1), 0);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.scrollView scrollRectToVisible:CGRectMake(kScreenWidth * (self.type - 1), 0, kScreenWidth, self.scrollViewHeight) animated:NO];
            [self launchLoadRequestIfNeed];
        });
    }
}

#pragma mark fetch

#pragma mark request
- (BOOL)launchLoadRequestIfNeed {
    if (LHOrderRequestTypePay == self.type) {
        if (!self.onceTokenPay) {
            self.onceTokenPay = YES;
            [self requestOrdersWithMode:JXWebLaunchModeLoad];
            return YES;
        }
    }else if (LHOrderRequestTypeHandle == self.type) {
        if (!self.onceTokenHandle) {
            self.onceTokenHandle = YES;
            [self requestOrdersWithMode:JXWebLaunchModeLoad];
            return YES;
        }
    }else if (LHOrderRequestTypeCollect == self.type) {
        if (!self.onceTokenCollect) {
            self.onceTokenCollect = YES;
            [self requestOrdersWithMode:JXWebLaunchModeLoad];
            return YES;
        }
    }else if (LHOrderRequestTypeService == self.type) {
        if (!self.onceTokenService) {
            self.onceTokenService = YES;
            [self requestOrdersWithMode:JXWebLaunchModeLoad];
            return YES;
        }
    }else if (LHOrderRequestTypeFinish == self.type) {
        if (!self.onceTokenFinish) {
            self.onceTokenFinish = YES;
            [self requestOrdersWithMode:JXWebLaunchModeLoad];
            return YES;
        }
    }else if (LHOrderRequestTypeCancel == self.type) {
        if (!self.onceTokenCancel) {
            self.onceTokenCancel = YES;
            [self requestOrdersWithMode:JXWebLaunchModeLoad];
            return YES;
        }
    }
    
    return NO;
}

- (void)requestOrdersWithMode:(JXWebLaunchMode)mode {
    switch (mode) {
        case JXWebLaunchModeSilent: {
            [self.operaters exAddObject:
             [self getUserOrdersWithType:self.type page:1 size:[self curPage].pageSize success:^(AFHTTPRequestOperation *operation, LHOrderCollection *orderCollection, LHOrderRequestType type) {
                NSMutableArray *orders = [self.orders objectAtIndex:(type - 1)];
                UITableView *tableView = [self.tableViews objectAtIndex:(type - 1)];
                JXPage *page = [self.pages objectAtIndex:(type - 1)];
                [self handleSuccessForTableView:tableView tableRect:self.tableRect mode:mode items:orders page:page results:orderCollection.orders current:orderCollection.currentPage total:orderCollection.totalRows image:[UIImage imageNamed:@"ic_order_empty"] message:@"没有相关订单" functitle:nil callback:NULL];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error, LHOrderRequestType type) {
                UITableView *tableView = [self.tableViews objectAtIndex:(type - 1)];
                [self handleFailureForView:tableView rect:self.tableRect mode:mode way:JXWebHandleWayToast error:error callback:^{
                    [self requestOrdersWithMode:mode];
                }];
            }]];
            break;
        }
        case JXWebLaunchModeLoad: {
            [JXLoadView showProcessingAddedTo:[self curTableView] rect:self.tableRect];
            [self.operaters exAddObject:
             [self getUserOrdersWithType:self.type page:1 size:[self curPage].pageSize success:^(AFHTTPRequestOperation *operation, LHOrderCollection *orderCollection, LHOrderRequestType type) {
                NSMutableArray *orders = [self.orders objectAtIndex:(type - 1)];
                UITableView *tableView = [self.tableViews objectAtIndex:(type - 1)];
                JXPage *page = [self.pages objectAtIndex:(type - 1)];
                [self handleSuccessForTableView:tableView tableRect:self.tableRect mode:mode items:orders page:page results:orderCollection.orders current:orderCollection.currentPage total:orderCollection.totalRows image:[UIImage imageNamed:@"ic_order_empty"] message:@"没有相关订单" functitle:nil callback:NULL];
                //[[JXLoadView loadForView:tableView] setBackgroundColor:[UIColor whiteColor]];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error, LHOrderRequestType type) {
                UITableView *tableView = [self.tableViews objectAtIndex:(type - 1)];
                [self handleFailureForView:tableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestOrdersWithMode:mode];
                }];
            }]];
            break;
        }
        case JXWebLaunchModeRefresh: {
            [self.operaters exAddObject:
             [self getUserOrdersWithType:self.type page:1 size:[self curPage].pageSize success:^(AFHTTPRequestOperation *operation, LHOrderCollection *orderCollection, LHOrderRequestType type) {
                NSMutableArray *orders = [self.orders objectAtIndex:(type - 1)];
                UITableView *tableView = [self.tableViews objectAtIndex:(type - 1)];
                JXPage *page = [self.pages objectAtIndex:(type - 1)];
                [self handleSuccessForTableView:tableView tableRect:self.tableRect mode:mode items:orders page:page results:orderCollection.orders current:orderCollection.currentPage total:orderCollection.totalRows image:[UIImage imageNamed:@"ic_order_empty"] message:@"没有相关订单" functitle:nil callback:NULL];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error, LHOrderRequestType type) {
                UITableView *tableView = [self.tableViews objectAtIndex:(type - 1)];
                [self handleFailureForView:tableView rect:self.tableRect mode:mode way:JXWebHandleWayToast error:error callback:^{
                    [self requestOrdersWithMode:mode];
                }];
            }]];
            break;
        }
        case JXWebLaunchModeMore: {
            [self.operaters exAddObject:
             [self getUserOrdersWithType:self.type page:([self curPage].currentPage + 1) size:[self curPage].pageSize success:^(AFHTTPRequestOperation *operation, LHOrderCollection *orderCollection, LHOrderRequestType type) {
                NSMutableArray *orders = [self.orders objectAtIndex:(type - 1)];
                UITableView *tableView = [self.tableViews objectAtIndex:(type - 1)];
                JXPage *page = [self.pages objectAtIndex:(type - 1)];
                [self handleSuccessForTableView:tableView tableRect:self.tableRect mode:mode items:orders page:page results:orderCollection.orders current:orderCollection.currentPage total:orderCollection.totalRows image:[UIImage imageNamed:@"ic_order_empty"] message:@"没有相关订单" functitle:nil callback:NULL];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error, LHOrderRequestType type) {
                UITableView *tableView = [self.tableViews objectAtIndex:(type - 1)];
                [self handleFailureForView:tableView rect:self.tableRect mode:mode way:JXWebHandleWayToast error:error callback:^{
                    [self requestOrdersWithMode:mode];
                }];
            }]];
            break;
        }
            
        default:
            break;
    }
}

- (AFHTTPRequestOperation *)getUserOrdersWithType:(LHOrderRequestType)type
                                             page:(NSInteger)page
                                             size:(NSInteger)size
                                          success:(LHOrderReqeustSuccessBlock)success
                                          failure:(LHOrderReqeustFailureBlock)failure {
    return [LHHTTPClient requestGetUserOrdersWithType:type page:page size:size success:^(AFHTTPRequestOperation *operation, LHOrderCollection *orderCollection) {
        if (success) {
            success(operation, orderCollection, type);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error, type);
        }
    }];
}

- (void)requestCancelNopayedOrderWithMode:(JXWebLaunchMode)mode order:(LHOrder *)order {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient requestCancelNopayedOrderWithOrderid:order.uid success:^(AFHTTPRequestOperation *operation, id response) {
        JXHUDHide();
        JXToast(@"取消成功啦");
        [self removeAndReload:order];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestCancelNopayedOrderWithMode:mode order:order];
        }];
    }]];
}

- (void)requestCancelPayedOrderWithMode:(JXWebLaunchMode)mode order:(LHOrder *)order {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient requestCancelPayedOrderWithOrderid:order.uid success:^(AFHTTPRequestOperation *operation, id response) {
        JXHUDHide();
        JXToast(@"取消成功啦");
        [self removeAndReload:order];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestCancelPayedOrderWithMode:mode order:order];
        }];
    }]];
}

- (void)requestCancelCollectingOrderWithMode:(JXWebLaunchMode)mode order:(LHOrder *)order {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient requestCancelCollectingOrderWithOrderid:order.uid success:^(AFHTTPRequestOperation *operation, id response) {
        JXHUDHide();
        JXToast(@"取消成功啦");
        [self removeAndReload:order];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestCancelPayedOrderWithMode:mode order:order];
        }];
    }]];
}

- (void)requestConfirmCollectedWithMode:(JXWebLaunchMode)mode order:(LHOrder *)order {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient requestConfirmCollectedWithOrderid:order.uid success:^(AFHTTPRequestOperation *operation, id response) {
        JXHUDHide();
        JXToast(@"哇，确认成功~");
        [self removeAndReload:order];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestReceiveWithMode:mode order:order];
        }];
    }]];
}

- (void)requestReceiveWithMode:(JXWebLaunchMode)mode order:(LHOrder *)order {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient requestReceiveWithOrderid:order.uid success:^(AFHTTPRequestOperation *operation, id response) {
        JXHUDHide();
        [self removeAndReload:order];
        
        LHOperationSuccessViewController *vc = [[LHOperationSuccessViewController alloc] init];
        vc.from = LHEntryFromOrder;
        vc.type = LHOperationSuccessTypeReceive;
        vc.order = order;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestReceiveWithMode:mode order:order];
        }];
    }]];
}

- (void)requestDeleteWithMode:(JXWebLaunchMode)mode order:(LHOrder *)order {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient requestDeleteOrderWithOrderid:order.uid success:^(AFHTTPRequestOperation *operation, id response) {
        JXHUDHide();
        JXToast(@"删除成功啦");
        [self removeAndReload:order];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestDeleteWithMode:mode order:order];
        }];
    }]];
}

- (void)requestNewPayidWithMode:(JXWebLaunchMode)mode order:(LHOrder *)order {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient requestNewPayidWithOrderid:order.uid success:^(AFHTTPRequestOperation *operation, NSString *response) {
        JXHUDHide();
        LHOrderPay *pay = [[LHOrderPay alloc] init];
        pay.cash = order.pay.cash;
        pay.payId = response;
        
        LHOrderCashierViewController *vc = [[LHOrderCashierViewController alloc] init];
        vc.from = LHEntryFromOrder;
        vc.order = order;
        vc.pay = pay;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestNewPayidWithMode:mode order:order];
        }];
    }]];
}

- (void)requestAddProductWithMode:(JXWebLaunchMode)mode param:(NSDictionary *)param {
    JXHUDProcessing(nil);
    [LHHTTPClient addShopCartProduct:param success:^(AFHTTPRequestOperation *operation, NSNumber *response) {
        JXHUDHide();
        JXToast(@"已加入购物车，妥妥的");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:NULL];
    }];
}

#pragma mark assist
- (NSMutableArray *)curOrders {
    return [self.orders objectAtIndex:(self.type - 1)];
}

- (JXPage *)curPage {
    return [self.pages objectAtIndex:(self.type - 1)];
}

- (UITableView *)curTableView {
    return [self.tableViews objectAtIndex:(self.type - 1)];
}

- (void)buyAgainOnLineWithOrder:(LHOrder *)order {
    NSMutableArray *products = [NSMutableArray arrayWithCapacity:order.products.count];
    for (LHOrderProduct *p in order.products) {
        LHAddProductRequestProduct *pdt = [LHAddProductRequestProduct new];
        pdt.shopId = order.shopId.integerValue;
        pdt.productId = p.productId.integerValue;
        pdt.specifieId = p.uid.integerValue;
        pdt.activityId = order.activityId;
        pdt.buyCount = 1;
        [products addObject:pdt];
    }
    LHAddProductRequest *request = [LHAddProductRequest new];
    request.addressId = gLH.receipt.receiptID.integerValue;
    request.productIds = products;
    
    [self showLoginIfNotLoginedWithFinish:^{
        [self requestAddProductWithMode:JXWebLaunchModeHUD param:[request JSONObject]];
    }];
}

#pragma mark - Accessor methods
- (NSArray *)orders {
    if (!_orders) {
        _orders = @[[NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array]];
    }
    return _orders;
}

- (NSArray *)pages {
    if (!_pages) {
        _pages = @[[JXPage new], [JXPage new], [JXPage new], [JXPage new], [JXPage new], [JXPage new]];
    }
    return _pages;
}

- (LHOrderRequestType)type {
    if (0 == _type) {
        _type = LHOrderRequestTypePay;
    }
    return _type;
}

- (CGFloat)scrollViewHeight {
    if (0 == _scrollViewHeight) {
        _scrollViewHeight = kScreenHeight - 64 - 44;
    }
    return _scrollViewHeight;
}

- (CGRect)tableRect {
    if (CGRectEqualToRect(_tableRect, CGRectZero)) {
        _tableRect = CGRectMake(0, 0, kJXScreenWidth, kJXScreenHeight - 64 - 44);
    }
    return _tableRect;
}

#pragma mark - Action methods
- (void)leftBarItemPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Notification methods
- (void)notifyOrderPayed:(NSNotification *)notification {
    [self removeAndReload:notification.object];
}

- (void)notifyOrderCanceled:(NSNotification *)notification {
    [self removeAndReload:notification.object];
}

- (void)notifyOrderReceived:(NSNotification *)notification {
    [self removeAndReload:notification.object];
}

- (void)notifyOrderDeleted:(NSNotification *)notification {
    [self removeAndReload:notification.object];
}

- (void)notifyOrderCommented:(NSNotification *)notification {
    [[self curTableView] reloadData];
}

- (void)notifyOrderConfirm:(NSNotification *)notification {
    [self removeAndReload:notification.object];
}


- (void)removeAndReload:(LHOrder *)order {
    [[self curOrders] removeObject:order];
    
    if (0 == [[self curOrders] count]) {
        [JXLoadView showResultAddedTo:[self curTableView] rect:self.tableRect image:[UIImage imageNamed:@"ic_order_empty"] message:@"没有相关订单" functitle:nil callback:NULL];
    }else {
        [JXLoadView hideForView:[self curTableView]];
    }
    
    [[self curTableView] reloadData];
}

//#pragma mark - Delegate methods
//#pragma mark UITableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [[self.orders objectAtIndex:tableView.tag] count];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    LHOrder *order = [[self.orders objectAtIndex:tableView.tag] objectAtIndex:indexPath.row];
//    return [LHOrderMineCell heightForOrder:order];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    LHOrder *order = [[self.orders objectAtIndex:tableView.tag] objectAtIndex:indexPath.row];
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHOrderMineCell identifier]];
//    [(LHOrderMineCell *)cell configOrder:order type:(tableView.tag + 1)];
//    [(LHOrderMineCell *)cell setCallback:^(LHOrder *order, LHOrderActionType type) {
//        if (LHOrderActionTypeCancel == type) {
//
//            if (self.type == LHOrderRequestTypePay) {
//                [self requestCancelNopayedOrderWithMode:JXWebLaunchModeHUD order:order];
//            }else if (self.type == LHOrderRequestTypeHandle) {
//                [self requestCancelPayedOrderWithMode:JXWebLaunchModeHUD order:order];
//            }
//
//        }else if (LHOrderActionTypePay == type) {
//            LHOrderCashierViewController *vc = [[LHOrderCashierViewController alloc] init];
//            vc.fromCart = NO;
//            vc.order = order;
//            [self.navigationController pushViewController:vc animated:YES];
//        }else if (LHOrderActionTypeReceive == type) {
//            [self requestReceiveWithMode:JXWebLaunchModeHUD order:order];
//        }else if (LHOrderActionTypeDelete == type) {
//            [self requestDeleteWithMode:JXWebLaunchModeHUD order:order];
//        }else if (LHOrderActionTypeAgain == type) {
//            [LHCartShop addProductWithOrder:order];
//            JXToast(@"已加入购物车");
//        }else if (LHOrderActionTypeComment == type) {
//            LHCommentViewController *vc = [[LHCommentViewController alloc] init];
//            vc.order = order;
//            vc.indexPath = indexPath;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }];
//
//    return cell;
//}
//
//#pragma mark UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    LHOrderDetailViewController *vc = [[LHOrderDetailViewController alloc] init];
//    vc.type = self.type;
//    vc.order = [[self.orders objectAtIndex:tableView.tag] objectAtIndex:indexPath.row];
//    vc.indexPath = indexPath;
//    [self.navigationController pushViewController:vc animated:YES];
//}


#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger number = [[self.orders objectAtIndex:tableView.tag] count];
    if (0 != number) {
        [JXLoadView hideForView:tableView];
    }
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LHOrder *order = [[self.orders objectAtIndex:tableView.tag] objectAtIndex:section];
    return order.products.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LHSpecifyCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHSpecifyCell identifier]];
    
    LHSpecifyCell *specifyCell = (LHSpecifyCell *)cell;
    [specifyCell.checkButton setEnabled:NO];
    [specifyCell.checkButton setImage:nil forState:UIControlStateNormal];
    specifyCell.widthConstraint.constant = 12.0f;
    
    LHOrder *order = [[self.orders objectAtIndex:tableView.tag] objectAtIndex:indexPath.section];
    LHOrderProduct *product = [order.products objectAtIndex:indexPath.row];
    
    product.activityId = order.activityId;
    product.activityTitle = order.activityName;
    product.actProductImgUrl = order.activityIcon;
    
    [specifyCell configSpecify:product inCart:NO];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [LHShopHeader height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [LHOrderFooter height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[LHShopHeader identifier]];
    LHShopHeader *shopHeader = (LHShopHeader *)header;
    [shopHeader.checkButton setEnabled:NO];
    [shopHeader.checkButton setImage:nil forState:UIControlStateNormal];
    shopHeader.widthConstraint.constant = 8.0f;
    [shopHeader.editButton setHidden:YES];
    
    LHOrder *order = [[self.orders objectAtIndex:tableView.tag] objectAtIndex:section];
    [shopHeader configOrder:order type:(tableView.tag + 1)];
    
    [(LHShopHeader *)header setPressCallback:^(NSInteger shopId) {
        LHShopDetailViewController *detailVC = [[LHShopDetailViewController alloc] initWithShopid:shopId];
        detailVC.from = LHEntryFromNone;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }];
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[LHOrderFooter identifier]];
    LHOrder *order = [[self.orders objectAtIndex:tableView.tag] objectAtIndex:section];
    [(LHOrderFooter *)footer configOrder:order type:(tableView.tag + 1)];
    [(LHOrderFooter *)footer setCallback:^(LHOrder *order, LHOrderActionType type) {
        _actionTypeForConfirm = type;
        _actionOrderForConfirm = order;
        
        if (LHOrderActionTypeCancel == type) {
            JXAlertParams(@"提示", @"是否确认取消？", @"取消", @"确认取消");
        }else if (LHOrderActionTypePay == type) {
            [self requestNewPayidWithMode:JXWebLaunchModeHUD order:order];
        }else if (LHOrderActionTypeReceive == type) {
            [self requestReceiveWithMode:JXWebLaunchModeHUD order:order];
        }else if (LHOrderActionTypeDelete == type) {
            JXAlertParams(@"提示", @"是否确认删除？", @"取消", @"确认删除");
        }else if (LHOrderActionTypeAgain == type) {
            if (order.orderType == 2) {
                JXToast(@"主人，活动商品不能重复购买哦`");
            }else {
                if (kIsLocalCart) {
                    [LHCartShop addProductWithOrder:order];
                    JXToast(@"已加入购物车，妥妥的");
                }else {
                    [self buyAgainOnLineWithOrder:order];
                }
            }
        }else if (LHOrderActionTypeComment == type) {
            LHCommentViewController *vc = [[LHCommentViewController alloc] init];
            vc.order = order;
            vc.section = section;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (LHOrderActionTypeConfirm == type) {
            [self requestConfirmCollectedWithMode:JXWebLaunchModeHUD order:order];
        }
    }];
    
    
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LHOrderDetailViewController *vc = [[LHOrderDetailViewController alloc] init];
    vc.type = self.type >= LHOrderRequestTypeCollect ? (self.type + 1) : self.type;
    vc.order = [[self.orders objectAtIndex:tableView.tag] objectAtIndex:indexPath.section];
    vc.indexPath = indexPath;
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        if (LHOrderActionTypeCancel == _actionTypeForConfirm) {
            if (self.type == LHOrderRequestTypePay) {
                [self requestCancelNopayedOrderWithMode:JXWebLaunchModeHUD order:_actionOrderForConfirm];
            }else if (self.type == LHOrderRequestTypeHandle) {
                [self requestCancelPayedOrderWithMode:JXWebLaunchModeHUD order:_actionOrderForConfirm];
            }else if (self.type == LHOrderRequestTypeCollect) {
                [self requestCancelCollectingOrderWithMode:JXWebLaunchModeHUD order:_actionOrderForConfirm];
            }
        }else if (LHOrderActionTypeDelete == _actionTypeForConfirm) {
            [self requestDeleteWithMode:JXWebLaunchModeHUD order:_actionOrderForConfirm];
        }
    }
}

#pragma mark - Public methods
#pragma mark - Class methods
@end



