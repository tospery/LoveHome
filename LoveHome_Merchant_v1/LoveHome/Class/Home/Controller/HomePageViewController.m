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

@interface HomePageViewController ()<UITableViewDataSource,UITableViewDelegate,HomeHearViewDeleage>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *shopInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *shopLogo;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *shopCategory;
@property (weak, nonatomic) IBOutlet UILabel *shopServerTime;

@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, strong) HomeHearView *heardView;
@property (nonatomic, strong) Paging *paging;
@property (nonatomic, strong) OrderModel *order;
@property (nonatomic, strong) OrderCount *count;
@end

@implementation HomePageViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHomePageReload object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{

    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];

    [self requestOrdersCount];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _shopInfoView.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:_shopInfoView.bounds andColors:@[JXColorHex(0xff6565),JXColorHex(0xff0000),JXColorHex(0xff0000),JXColorHex(0xff0000),JXColorHex(0xff0000)]];
    _shopLogo.layer.cornerRadius = 4;
    _shopLogo.clipsToBounds = YES;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *cellNib = [UINib nibWithNibName:@"OrderAddedCell" bundle:nil];
    [_myTableView registerNib:cellNib forCellReuseIdentifier:[OrderAddedCell identifier]];
    [_myTableView registerNib:[UINib nibWithNibName:@"NoOneNewOrderCell" bundle:nil] forCellReuseIdentifier:@"NoOneNewOrderCell"];
    
    _myTableView.backgroundColor = [UIColor clearColor];
    
    _heardView = [[HomeHearView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 115)];
    _heardView.backgroundColor = self.view.backgroundColor;
    _heardView.delegate = self;
    _myTableView.tableHeaderView = _heardView;
    
    [self reloadShopInfo];
    
    self.myTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestOrdersWithMode:JXRequestModeRefresh];
    }];
    
   
    [self.myTableView.header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHomePage:) name:kHomePageReload object:nil];
    
    self.count = [[OrderTools sharedOrderTools] fetchOrderCount];
    self.heardView.waitingButton.messageCount = self.count.notResponseCount;
    
}

- (void)judgeOrderCont
{
    if (self.orders.count < 1) {
        self.heardView.allReciveOrderBtn.selected = NO;
    }
}



/*!
 *  @brief  获取订单数量
 */
- (void)requestOrdersCount
{
 
    
    [OrderTools getCountWithSuccess:^(AFHTTPRequestOperation *operation, OrderCount *count) {
        self.count = count;
        [[OrderTools sharedOrderTools] storeOrderCount:self.count];
        self.heardView.waitingButton.messageCount = self.count.notResponseCount;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [ErrorHandleTool handleErrorWithCode:error toShowView:self.view didFinshi:^{
            
        } cancel:NULL];
        
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

- (void)requestAccept:(OrderModel *)order {
    JXHUDProcessing(nil);
    [OrderTools acceptWithOrderid:order.orderid success:^(AFHTTPRequestOperation *operation, NSNumber *result) {
        [self handleSuccessForHUD];
        [self.orders removeObject:order];
        [self judgeOrderCont];
        JXToast(@"接单成功");
        
        [[OrderTools sharedOrderTools] storeOrders:self.orders type:OrderTypeAdded];
        [self.myTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        JXHUDHide()
        [ErrorHandleTool handleErrorWithCode:error toShowView:self.view didFinshi:^{
            
        } cancel:NULL];
    }];
}

- (void)requestRejectWithReason:(NSString *)reason {
    if (!self.order || reason.length == 0) {
        return;
    }
    JXHUDProcessing(nil);
    [OrderTools rejectWithOrderid:self.order.orderid reason:reason success:^(AFHTTPRequestOperation *operation, NSNumber *result) {
        [self handleSuccessForHUD];
        [self.orders removeObject:self.order];
        [self judgeOrderCont];
        [[OrderTools sharedOrderTools] storeOrders:self.orders type:OrderTypeAdded];
        [self.myTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        JXHUDHide()
        [ErrorHandleTool handleErrorWithCode:error toShowView:self.view didFinshi:^{
            
        } cancel:NULL];
    }];
}

- (void)requestAcceptOrders {
    NSMutableArray *arr = [NSMutableArray array];
    for (OrderModel *obj in self.orders) {
        if (obj.selected) {
            [arr addObject:obj];
        }
    }
    if (arr.count == 0) {
        JXToast(@"请至少选择一个订单");
        return;
    }
    
    JXHUDProcessing(nil);
    [OrderTools acceptWithOrderids:arr success:^(AFHTTPRequestOperation *operation, id responsObject) {
        [self handleSuccessForHUD];
        [self.orders removeObjectsInArray:arr];
        [[OrderTools sharedOrderTools] storeOrders:self.orders type:OrderTypeAdded];
        self.heardView.allReciveOrderBtn.selected = NO;
        [self.myTableView reloadData];

        JXToast(@"接单成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    [(OrderAddedCell *)cell setupFuncBlock:^(UIButton *button) {
        if (0 == button.tag) {
            [self requestAccept:self.orders[indexPath.row]];
        }else {
            self.order = self.orders[indexPath.row];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请添加拒绝理由" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert show];
        }
    }];
    [(OrderAddedCell *)cell setupSelectBlock:^(BOOL selected) {
        OrderModel *order = self.orders[indexPath.row];
        order.selected = selected;
        if (!selected) {
            self.heardView.allReciveOrderBtn.selected = NO;
            return ;
        }
        
        __block BOOL isAll = YES;
        [self.orders enumerateObjectsUsingBlock:^(OrderModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!obj.selected) {
                isAll = NO;
            }
        }];
        self.heardView.allReciveOrderBtn.selected = isAll;
        
    }];
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
        return self.myTableView.height - 80;
    }
    return [OrderAddedCell height];
}


#pragma mark -- homeHearViewDeleageOrderDetail

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
    OrderListViewController *orderVC = [[OrderListViewController alloc] initWithType:OrderTypeUnhandled];
    [self.navigationController pushViewController:orderVC animated:YES];
}


- (void)homeHearViewDeleageAcceptBatchOrders:(UIButton *)sender
{
    [self requestAcceptOrders];
}

- (void) homeHearViewDeleageSelectAll:(UIButton *)sender
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


- (IBAction)settingButonClick:(id)sender
{
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
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
    
    [self requestRejectWithReason:textField.text];
}

@end
