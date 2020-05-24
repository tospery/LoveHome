//
//  LHOrderDetailViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/8.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHOrderDetailViewController.h"
#import "LHOrderCashierViewController.h"
#import "LHOperationSuccessViewController.h"
#import "LHCommentViewController.h"
#import "LHShopHeader.h"
#import "LHSpecifyCell.h"
#import "LHLeaveFooter.h"
#import "LHShopDetailViewController.h"

@interface LHOrderDetailViewController ()
@property (nonatomic, assign) BOOL cancelFlag;

@property (nonatomic, strong) LHOrder *orderDetail;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, assign) CGRect tableRect;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

// header
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UILabel *orderidLabel;
@property (nonatomic, weak) IBOutlet UILabel *ordertimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *receiptNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *receiptPhoneLabel;
@property (nonatomic, weak) IBOutlet UILabel *receiptAddressLabel;
@property (nonatomic, weak) IBOutlet UIView *headerView;

@property (nonatomic, weak) IBOutlet UILabel *cancelTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *cancelReasonLabel;

// footer
@property (nonatomic, weak) IBOutlet UIButton *commentButton;
@property (nonatomic, weak) IBOutlet UIButton *confirmButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

@property (nonatomic, weak) IBOutlet UILabel *paywayLabel;
@property (nonatomic, weak) IBOutlet UILabel *appointTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *receiveLabel;

@property (nonatomic, weak) IBOutlet UILabel *priceTotalLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceCouponLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLovebeanLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceActualLabel;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *paywayTopConstrant;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *normalButtons;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *importButtons;
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *actionViews;
@property (nonatomic, weak) IBOutlet UIView *footerView;

@end

@implementation LHOrderDetailViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupDB];
    [self setupNet];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupView {
    self.navigationItem.title = @"订单详情";
    
    for (UIButton *btn in self.importButtons) {
        ConfigButtonStyle(btn);
    }
    
    for (UIButton *btn in self.normalButtons) {
        [btn setBackgroundImage:[UIImage exImageWithColor:JXColorHex(0xF4F4F4)] forState:UIControlStateHighlighted];
        [btn exSetBorder:JXColorHex(0x666666) width:1.0 radius:4.0];
    }
    
    for (int i = 0; i < self.actionViews.count; ++i) {
        if (i == (self.type - 1)) {
            [self.actionViews[i] setHidden:NO];
        }else {
            [self.actionViews[i] setHidden:YES];
        }
    }
    
    if (LHOrderRequestTypePay == self.type) {
        self.typeLabel.text = @"待支付";
    }else if (LHOrderRequestTypeHandle == self.type) {
        self.typeLabel.text = @"待服务";
    }else if (LHOrderRequestTypeCollect == self.type) {
        self.typeLabel.text = @"收衣中";
        
        if (self.order.collectedByMerchant) {
            ConfigButtonStyle(_confirmButton);
            [_confirmButton setEnabled:YES];
        }else {
            [_confirmButton setBackgroundImage:[UIImage exImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
            [_confirmButton exSetBorder:[UIColor clearColor] width:0.1 radius:4];
            [_confirmButton setEnabled:NO];
        }
    }else if (LHOrderRequestTypeService == self.type) {
        self.typeLabel.text = @"服务中";
    }else if (LHOrderRequestTypeFinish == self.type) {
        self.typeLabel.text = @"已完成";
        
        self.footerView.frame = CGRectMake(0, 0, kJXScreenWidth, 250);
        if (self.order.status == LHOrderResponseTypeToComment) {
            [self.commentButton setHidden:NO];
        }else {
            [self.commentButton setHidden:YES];
        }
    }
    
    if (_type == LHOrderRequestTypeCancel) {
        self.typeLabel.text = @"已取消";
        
        if (_order.cancelFlag == LHOrderCancelReasonCustomerPayed) {
            self.cancelReasonLabel.text = @"用户取消(未支付)";
            self.headerView.bounds = CGRectMake(0, 0, kJXScreenWidth, 194);
        }else if(_order.cancelFlag == LHOrderCancelReasonCustomerNoPay) {
            self.cancelReasonLabel.text = @"用户取消(已支付)";
            self.headerView.bounds = CGRectMake(0, 0, kJXScreenWidth, 194);
        }else if(_order.cancelFlag == LHOrderCancelReasonCustomerCollecting) {
            self.cancelReasonLabel.text = @"用户取消(收衣中)";
            self.headerView.bounds = CGRectMake(0, 0, kJXScreenWidth, 194);
        }else if(_order.cancelFlag == LHOrderCancelReasonAppvworks) {
            self.cancelReasonLabel.text = @"爱为家管理员拒绝";
            self.headerView.bounds = CGRectMake(0, 0, kJXScreenWidth, 230);
        }else if(_order.cancelFlag == LHOrderCancelReasonMerchant) {
            self.cancelReasonLabel.text = @"商家拒绝(新增)";
            self.headerView.bounds = CGRectMake(0, 0, kJXScreenWidth, 230);
        }else if(_order.cancelFlag == LHOrderCancelReasonMerchantCollecting) {
            self.cancelReasonLabel.text = @"商家拒绝(收衣)";
            self.headerView.bounds = CGRectMake(0, 0, kJXScreenWidth, 230);
        }else {
            self.cancelReasonLabel.text = nil;
        }
    }else {
        self.cancelReasonLabel.text = nil;
    }
    
    UINib *nib = [UINib nibWithNibName:@"LHSpecifyCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:[LHSpecifyCell identifier]];
    nib = [UINib nibWithNibName:@"LHShopHeader" bundle:nil];
    [_tableView registerNib:nib forHeaderFooterViewReuseIdentifier:[LHShopHeader identifier]];
    nib = [UINib nibWithNibName:@"LHLeaveFooter" bundle:nil];
    [_tableView registerNib:nib forHeaderFooterViewReuseIdentifier:[LHLeaveFooter identifier]];
}

- (void)setupDB {
}

- (void)setupNet {
    [self requestOrderDetailWithMode:JXWebLaunchModeLoad];
}

#pragma mark fetch

#pragma mark request
- (void)requestOrderDetailWithMode:(JXWebLaunchMode)mode {
    //[JXLoadView showProcessingAddedTo:self.tableView rect:self.tableRect];
    [JXLoadView showProcessingAddedTo:self.view rect:CGRectZero];
    [self.operaters exAddObject:
     [LHHTTPClient requestGetOrderDetailWithOrderid:self.order.uid success:^(AFHTTPRequestOperation *operation, LHOrder *response) {
        self.orderDetail = response;
        [self.tableView reloadData];
        [self configInfo];
        [JXLoadView hideForView:self.view];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
            [self requestOrderDetailWithMode:mode];
        }];
    }]];
}

- (void)requestCancelOrderWithMode:(JXWebLaunchMode)mode {
    JXHUDProcessing(nil);
    if (LHOrderRequestTypePay == self.type) {
        [self.operaters exAddObject:
         [LHHTTPClient requestCancelNopayedOrderWithOrderid:self.orderDetail.uid success:^(AFHTTPRequestOperation *operation, id response) {
            JXHUDHide();
            JXToast(@"取消成功啦");
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyOrderCanceled object:self.order];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
                [self requestCancelOrderWithMode:mode];
            }];
        }]];
    }else if (LHOrderRequestTypeHandle == self.type) {
        [self.operaters exAddObject:
         [LHHTTPClient requestCancelPayedOrderWithOrderid:self.orderDetail.uid success:^(AFHTTPRequestOperation *operation, id response) {
            JXHUDHide();
            JXToast(@"取消成功啦");
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyOrderCanceled object:self.order];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
                [self requestCancelOrderWithMode:mode];
            }];
        }]];
    }else if (LHOrderRequestTypeCollect == self.type) {
        [self.operaters exAddObject:
         [LHHTTPClient requestCancelCollectingOrderWithOrderid:self.orderDetail.uid success:^(AFHTTPRequestOperation *operation, id response) {
            JXHUDHide();
            JXToast(@"取消成功啦");
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyOrderCanceled object:self.order];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
                [self requestCancelOrderWithMode:mode];
            }];
        }]];
    }
}

- (void)requestReceiveWithMode:(JXWebLaunchMode)mode{
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient requestReceiveWithOrderid:self.order.uid success:^(AFHTTPRequestOperation *operation, id response) {
        JXHUDHide();
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyOrderReceived object:self.order];
        
        LHOperationSuccessViewController *vc = [[LHOperationSuccessViewController alloc] init];
        vc.from = LHEntryFromOrder;
        vc.type = LHOperationSuccessTypeReceive;
        vc.order = self.order;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestReceiveWithMode:mode];
        }];
    }]];
}

- (void)requestDeleteWithMode:(JXWebLaunchMode)mode {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient requestDeleteOrderWithOrderid:self.order.uid success:^(AFHTTPRequestOperation *operation, id response) {
        JXHUDHide();
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyOrderDeleted object:self.order];
        
        JXToast(@"删除成功啦");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestDeleteWithMode:mode];
        }];
    }]];
}

- (void)requestConfirmCollectedWithMode:(JXWebLaunchMode)mode {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient requestConfirmCollectedWithOrderid:self.order.uid success:^(AFHTTPRequestOperation *operation, id response) {
        JXHUDHide();
        JXToast(@"哇，确认成功~");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyOrderConfirm object:self.order];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestConfirmCollectedWithMode:mode];
        }];
    }]];
}

- (void)requestNewPayidWithMode:(JXWebLaunchMode)mode {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient requestNewPayidWithOrderid:self.order.uid success:^(AFHTTPRequestOperation *operation, NSString *response) {
        JXHUDHide();
        LHOrderPay *pay = [[LHOrderPay alloc] init];
        pay.cash = self.order.pay.cash;
        pay.payId = response;
        
        LHOrderCashierViewController *vc = [[LHOrderCashierViewController alloc] init];
        vc.from = LHEntryFromOrder;
        vc.order = self.order;
        vc.pay = pay;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestNewPayidWithMode:mode];
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
- (void)configInfo {
    self.orderidLabel.text = [NSString stringWithFormat:@"订单编号：%@", self.orderDetail.uid];
    self.ordertimeLabel.text = [NSString stringWithFormat:@"下单时间：%@", self.orderDetail.orderTime];
    self.receiptNameLabel.text = [NSString stringWithFormat:@"收货人：%@", self.orderDetail.customerName];
    self.receiptPhoneLabel.text = self.orderDetail.customerTelephone;
    self.receiptAddressLabel.text = [NSString stringWithFormat:@"收货地址：%@", self.orderDetail.customerAddress];
    
    if (self.orderDetail.cancelFlag == LHOrderCancelReasonCustomerPayed
        || self.orderDetail.cancelFlag == LHOrderCancelReasonCustomerNoPay
        || self.orderDetail.cancelFlag == LHOrderCancelReasonCustomerCollecting) {
        self.cancelTimeLabel.text = [NSString stringWithFormat:@"取消时间：%@", self.orderDetail.rejectTime];
    }else if (self.orderDetail.cancelFlag == LHOrderCancelReasonAppvworks
              || self.orderDetail.cancelFlag == LHOrderCancelReasonMerchant
              || self.orderDetail.cancelFlag == LHOrderCancelReasonMerchantCollecting) {
        self.cancelTimeLabel.text = [NSString stringWithFormat:@"拒绝时间：%@", self.orderDetail.rejectTime];
        self.cancelReasonLabel.text =  [NSString stringWithFormat:@"拒绝理由：%@", self.orderDetail.servingRemark];
    }else {
        self.cancelTimeLabel.text = nil;
        self.cancelReasonLabel.text = nil;
    }
    
    
    self.paywayLabel.text = [NSString stringWithFormat:@"支付方式：%@", ((self.orderDetail.pay.payment == LHPayWayByCard) ? @"店铺会员卡支付（以会员卡金额为准）" : @"线上支付")];
    self.appointTimeLabel.text = [NSString stringWithFormat:@"预约上门时间：%@", self.orderDetail.appointTime];
    self.receiveLabel.text = [NSString stringWithFormat:@"收货时间：%@", self.orderDetail.receiptTime];
    
    
    self.priceTotalLabel.text = [NSString stringWithFormat:@"￥%.2f", self.orderDetail.pay.totalPrice];
    self.priceCouponLabel.text = [NSString stringWithFormat:@"￥%.2f", self.orderDetail.pay.couponPrice];
    self.priceLovebeanLabel.text = [NSString stringWithFormat:@"￥%.2f", self.orderDetail.pay.creditsPrice];
    self.priceActualLabel.text = [NSString stringWithFormat:@"￥%.2f", self.orderDetail.pay.payPrice];
    
    if (LHOrderRequestTypeHandle == self.type) {
        if (self.orderDetail.cancelable) {
            [self.cancelButton setHidden:NO];
        }else {
            [self.cancelButton setHidden:YES];
        }
        
        if (self.orderDetail.collectedByMerchant) {
            [self.confirmButton setEnabled:YES];
        }else {
            [self.confirmButton setEnabled:NO];
        }
    }
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
- (CGRect)tableRect {
    if (CGRectEqualToRect(_tableRect, CGRectZero)) {
        _tableRect = CGRectMake(0, 0, kJXScreenWidth, kJXScreenHeight - 64);
    }
    return _tableRect;
}

#pragma mark - Action methods
- (IBAction)cancelButtonPressed:(id)sender {
    self.cancelFlag = YES;
    JXAlertParams(@"提示", @"是否确认取消？", @"取消", @"确认取消");
    // [self requestCancelOrderWithMode:JXWebLaunchModeHUD];
}

- (IBAction)payButtonPressed:(id)sender {
    [self requestNewPayidWithMode:JXWebLaunchModeHUD];
}

- (IBAction)receiveButtonPressed:(id)sender {
    [self requestReceiveWithMode:JXWebLaunchModeHUD];
}

- (IBAction)deleteButtonPressed:(id)sender {
    self.cancelFlag = NO;
    JXAlertParams(@"提示", @"是否确认删除？", @"取消", @"确认删除");
    // [self requestDeleteWithMode:JXWebLaunchModeHUD];
}

- (IBAction)commentButtonPressed:(id)sender {
    LHCommentViewController *vc = [[LHCommentViewController alloc] init];
    vc.order = self.order;
    vc.section = self.indexPath.section;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)againButtonPressed:(id)sender {
    if (self.order.orderType == 2) {
        JXToast(@"主人，活动商品不能重复购买哦`");
    }else {
//        [LHCartShop addProductWithOrder:self.order];
//        JXToast(@"已加入购物车，妥妥的");
        
        if (kIsLocalCart) {
            [LHCartShop addProductWithOrder:self.order];
            JXToast(@"已加入购物车，妥妥的");
        }else {
            [self buyAgainOnLineWithOrder:self.order];
        }
    }
}

- (IBAction)confirmButtonPressed:(id)sender {
    //    [LHCartShop addProductWithOrder:self.order];
    //    JXToast(@"已加入购物车");
    [self requestConfirmCollectedWithMode:JXWebLaunchModeHUD];
}

#pragma mark - Notification methods

//#pragma mark - Delegate methods
//#pragma mark UITableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [LHOrderDetailCell heightForOrder:self.orderDetail];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHOrderDetailCell identifier]];
//    [(LHOrderDetailCell *)cell setOrder:self.orderDetail];
//    return cell;
//}
//
//#pragma mark UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//}


#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _order.products.count;
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
    
    LHOrderProduct *product = [_order.products objectAtIndex:indexPath.row];
    [specifyCell configSpecify:product inCart:NO];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [LHShopHeader height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [LHLeaveFooter heightNoTotal];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[LHShopHeader identifier]];
    LHShopHeader *shopHeader = (LHShopHeader *)header;
    [shopHeader.checkButton setEnabled:NO];
    [shopHeader.checkButton setImage:nil forState:UIControlStateNormal];
    shopHeader.widthConstraint.constant = 8.0f;
    
    [shopHeader configOrder:_order type:_type];
    
    [shopHeader.editButton setHidden:YES];
    [shopHeader.cancelReasonLabel setHidden:YES];
    
    [(LHShopHeader *)header setPressCallback:^(NSInteger shopId) {
        LHShopDetailViewController *detailVC = [[LHShopDetailViewController alloc] initWithShopid:shopId];
        detailVC.from = LHEntryFromNone;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }];
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[LHLeaveFooter identifier]];
    footer.frame = CGRectMake(footer.frame.origin.x,
                              footer.frame.origin.y,
                              footer.frame.size.width,
                              [LHLeaveFooter heightNoTotal]);
    [(LHLeaveFooter *)footer setOrder:_orderDetail];
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        if (self.cancelFlag) {
            [self requestCancelOrderWithMode:JXWebLaunchModeHUD];
        }else {
            [self requestDeleteWithMode:JXWebLaunchModeHUD];
        }
    }
}

#pragma mark - Public methods
#pragma mark - Class methods

@end
