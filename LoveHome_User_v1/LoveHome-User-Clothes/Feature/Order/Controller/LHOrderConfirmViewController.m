//
//  LHOrderConfirmViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/6.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHOrderConfirmViewController.h"
#import "LHReceiptViewController.h"
#import "LHCouponMineViewController.h"
#import "LHOrderSubmit.h"
#import "LHOrderCashierViewController.h"
#import "LHOperationSuccessViewController.h"
#import "LHShopHeader.h"
#import "LHSpecifyCell.h"
#import "LHLeaveFooter.h"

@interface LHOrderConfirmViewController ()
@property (nonatomic, strong) NSArray *shopids;
@property (nonatomic, assign) NSInteger responseCount;
@property (nonatomic, assign) BOOL onceTokenForTime;
@property (nonatomic, assign) CGFloat totalMoney;
@property (nonatomic, assign) CGFloat couponMoney;
@property (nonatomic, assign) CGFloat lovebeanMoney;
@property (nonatomic, assign) NSInteger maxLovebean;
@property (nonatomic, assign) NSInteger canLovebean;

@property (nonatomic, strong) JXPickerView *pickerView;

@property (nonatomic, strong) LHCoupon *coupon;
@property (nonatomic, strong) NSArray *cartShops;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UIButton *submit2Button;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *footerView;

// 收货地址
@property (nonatomic, weak) IBOutlet UILabel *receiptNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *receiptPhoneLabel;
@property (nonatomic, weak) IBOutlet UILabel *receiptAddressLabel;
@property (nonatomic, weak) IBOutlet UIView *receiptView;
@property (nonatomic, weak) IBOutlet UIView *tipsView;

// 预约上门时间
@property (nonatomic, weak) IBOutlet UILabel *appointTimeLabel;

// 支付方式
@property (nonatomic, weak) IBOutlet UIButton *payOnLineButton;
@property (nonatomic, weak) IBOutlet UIButton *payByCardButton;
@property (nonatomic, weak) IBOutlet UITextField *paywayCartTextField;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *payTopSplitConstraint;

// 优惠券
@property (nonatomic, weak) IBOutlet UILabel *couponHavedLabel;
@property (nonatomic, weak) IBOutlet UILabel *couponUsedLabel;

// 爱豆
@property (nonatomic, weak) IBOutlet UITextField *lovebeanTextField;
@property (nonatomic, weak) IBOutlet UILabel *lovebeanSummaryLabel;
@property (nonatomic, weak) IBOutlet UILabel *lovebeanUsedLabel;
@property (nonatomic, weak) IBOutlet UIImageView *lovebeanSplitImageView;
@property (nonatomic, weak) IBOutlet UIView *lovebeanUsedView;
@property (nonatomic, weak) IBOutlet UIView *lovebeanUnusedView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lovebeanTop1Constraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lovebeanTop2Constraint;

// 金额
@property (nonatomic, weak) IBOutlet UILabel *moneyTotalLabel;
@property (nonatomic, weak) IBOutlet UILabel *moneyCouponLabel;
@property (nonatomic, weak) IBOutlet UILabel *moneyLovebeanLabel;
@property (nonatomic, weak) IBOutlet UILabel *moneyActualLabel;

// 活动
@property (nonatomic, weak) IBOutlet UIImageView *activityImageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *activityConstraint;

@property (nonatomic, weak) IBOutlet UILabel *totalMoney2Label;
@property (nonatomic, weak) IBOutlet UIView *vipView;

@property (nonatomic, weak) IBOutlet UISwitch *lovebeanSwitch;
@end

@implementation LHOrderConfirmViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVar];
    [self setupView];
    [self setupDB];
    [self setupNet];
}

- (void)dealloc {
    for (LHCartShop *cs in self.cartShops) {
        cs.remark = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
    NSMutableArray *arr = [NSMutableArray array];
    for (LHCartShop *obj in _cartShops) {
        [arr addObject:obj.shopID];
    }
    _shopids = arr;
}

- (void)setupView {
    self.navigationItem.title = @"确认订单";
    
    ConfigButtonRedStyle(self.submitButton);
    ConfigButtonRedStyle(self.submit2Button);
    
    UINib *nib = [UINib nibWithNibName:@"LHSpecifyCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:[LHSpecifyCell identifier]];
    nib = [UINib nibWithNibName:@"LHShopHeader" bundle:nil];
    [_tableView registerNib:nib forHeaderFooterViewReuseIdentifier:[LHShopHeader identifier]];
    nib = [UINib nibWithNibName:@"LHLeaveFooter" bundle:nil];
    [_tableView registerNib:nib forHeaderFooterViewReuseIdentifier:[LHLeaveFooter identifier]];
    
    self.totalMoney = 0.0f;
    for (LHCartShop *c in self.cartShops) {
        for (LHSpecify *s in c.specifies) {
            self.totalMoney += (s.price.floatValue * s.pieces);
        }
    }
    _totalMoney2Label.text = [NSString stringWithFormat:@"￥%.2f", self.totalMoney];
    
    //self.appointTimeLabel.text = [[NSDate date] stringWithFormat:kJXFormatDatetimeNormal];
    
    CGFloat height = kJXScreenHeight - kJXStsBarHeight - kJXNavBarHeight;
    self.pickerView = [[JXPickerView alloc] initWithFrame:CGRectMake(0, height, kJXScreenWidth, height)];
    [self.pickerView loadDataWithDft:[self getLatestDate]];
//    self.pickerView.datePicker.minuteInterval = 15;
//    self.pickerView.datePicker.minimumDate = [self getLatestDate];
//    self.pickerView.datePicker.date = self.pickerView.datePicker.minimumDate;
//    [self.pickerView loadData:nil];
    [self.view addSubview:self.pickerView];
    
    __weak __typeof(self) weakSelf = self;
    [self.pickerView setWillCloseBlock:^(NSDate *date) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
//        strongSelf.appointTimeLabel.text = [strongSelf.pickerView.datePicker.date stringWithFormat:kJXFormatDatetimeStyle2];
//        int a1 = [strongSelf.pickerView.pickerView selectedRowInComponent:0];
//        int a2 = [strongSelf.pickerView.pickerView selectedRowInComponent:1];
//        int a3 = [strongSelf.pickerView.pickerView selectedRowInComponent:2];
//        int a = 0;
        
        //NSLog(@"aaaa: %@", [date exStringWithFormat:kJXFormatDatetimeStyle2]);
        
        NSDate *date2 = [NSDate dateWithTimeInterval:(1 * 60 * 60) sinceDate:[NSDate date]];
        NSDate *date3 = [date earlierDate:date2];
        if (date3 == date2) { // 有效选择
            strongSelf.appointTimeLabel.text = [date stringWithFormat:kJXFormatDatetimeStyle2];
        }else {
            strongSelf.appointTimeLabel.text = @"亲，请提前一小时预约哟！";
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyCouponSelected:) name:kNotifyCouponSelected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyReceiptSelected:) name:kNotifyReceiptSelected object:nil];
    
    // 480
    if (LHEntryFromActivity == _from) {
        _footerView.bounds = CGRectMake(0, 0, 320, 480 - 126 - 40);
        _activityConstraint.constant = -126;
    }else {
        [_activityImageView setHidden:YES];
    }
    
    [self configReceipt:nil];
    [self configDataWithCouponCount:0 lovebeanNum:0];
    [self configMoneyWithCoupon:0 lovebean:0];
}

- (void)setupDB {
}

- (void)setupNet {
    //[self requestUsableCouponCountWithMode:JXWebLaunchModeSilent];
    [self requestDefaultReciptWithMode:JXWebLaunchModeHUD];
}

#pragma mark config
- (void)configMoneyWithCoupon:(CGFloat)coupon lovebean:(CGFloat)lovebean {
    CGFloat ac = (self.totalMoney - coupon - lovebean);
    
    self.moneyTotalLabel.text = [NSString stringWithFormat:@"￥%.2f", self.totalMoney];
    self.moneyCouponLabel.text = [NSString stringWithFormat:@"￥%.2f", coupon];
    self.moneyLovebeanLabel.text = [NSString stringWithFormat:@"￥%.2f", lovebean];
    self.moneyActualLabel.text = [NSString stringWithFormat:@"￥%.2f", ac > 0.0 ? ac : 0.0];
}

- (void)configDataWithCouponCount:(NSInteger)coupon lovebeanNum:(NSInteger)lovebean {
    if (lovebean > ceil(self.totalMoney * 100)) {
        self.maxLovebean = ceil(self.totalMoney * 100);
    }else {
        self.maxLovebean = lovebean;
    }
    
    self.couponHavedLabel.text = [NSString stringWithFormat:@"优惠券（%ld张可用）", (long)coupon];
    self.lovebeanSummaryLabel.text = [NSString stringWithFormat:@"爱豆（%ld颗，可抵用%.2f元）", (long)lovebean, (CGFloat)lovebean / 100.0f];
}


- (void)configReceipt:(LHReceipt *)receipt {
    if (receipt.receiptID.length == 0) {
        [self.tipsView setHidden:NO];
        [self.receiptView setHidden:YES];
        self.receiptAddressLabel.text = nil;
        return;
    }
    
    [self.tipsView setHidden:YES];
    [self.receiptView setHidden:NO];
    
    self.receiptNameLabel.text = [NSString stringWithFormat:@"收货人：%@", receipt.name];
    self.receiptPhoneLabel.text = receipt.mobile;
    self.receiptAddressLabel.text = [NSString stringWithFormat:@"%@%@%@%@", receipt.provinceName, receipt.cityName, receipt.areaName, receipt.address];
}

//- (void)configCouponWithCount:(NSInteger)count {
//    self.couponHavedLabel.text = [NSString stringWithFormat:@"优惠券（%ld张可用）", (long)count];
//    //self.couponUsedLabel.text = @"未使用";
//}

#pragma mark fetch

#pragma mark request
//- (void)requestUsableCouponCountWithMode:(JXWebLaunchMode)mode {
//    [self.operaters exAddObject:
//     [LHHTTPClient requestGetUsableCouponCountWithShopids:_shopids success:^(AFHTTPRequestOperation *operation, NSNumber *response) {
//        [self configCouponWithCount:response.integerValue];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:NULL];
//    }]];
//}

- (void)requestBasicDataWithMode:(JXWebLaunchMode)mode {
    [self.operaters exAddObject:
     [LHHTTPClient requestGetBasicDataForOrderConfirmWithSuccess:^(AFHTTPRequestOperation *operation, LHBasicData *response) {
        gLH.user.info.loveBean = response.loveBeansNumber;
        [self configDataWithCouponCount:response.couponsNumber lovebeanNum:response.loveBeansNumber];
        JXHUDHide();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestDefaultReciptWithMode:mode];
        }];
    }]];
}

- (void)requestDefaultReciptWithMode:(JXWebLaunchMode)mode {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient requestGetDefaultReceiptWithSuccess:^(AFHTTPRequestOperation *operation, LHReceipt *receipt) {
        [self configReceipt:receipt];
        [self requestBasicDataWithMode:JXWebLaunchModeHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestDefaultReciptWithMode:mode];
        }];
    }]];
}


- (void)requestSubmitWithMode:(JXWebLaunchMode)mode model:(LHOrderSubmit *)model {
    JXHUDProcessing(nil);
    [LHHTTPClient requestSubmitOrderWithModel:model success:^(AFHTTPRequestOperation *operation, LHOrderPay *pay) {
        JXHUDHide();
        [self removeCartShops];
        
        if (model.payment == LHPayWayByCard) {
            LHOperationSuccessViewController *vc = [[LHOperationSuccessViewController alloc] init];
            vc.type = LHOperationSuccessTypeSubmit;
            vc.from = _from;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            if (pay.cash == 0.0f) {
                LHOperationSuccessViewController *vc = [[LHOperationSuccessViewController alloc] init];
                vc.type = LHOperationSuccessTypePay;
                vc.from = _from;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                LHOrderCashierViewController *vc = [[LHOrderCashierViewController alloc] init];
                vc.from = _from;
                vc.pay = pay;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestSubmitWithMode:mode model:model];
        }];
    }];
}

#pragma mark assist
- (void)removeCartShops {
    // 规格ID是唯一的，与商品与店铺无关。
    NSMutableArray *specifies = [NSMutableArray array];
    for (LHCartShop *c in self.cartShops) {
        [specifies addObjectsFromArray:c.specifies];
    }
    
    for (LHSpecify *s1 in specifies) {
        for (int i = 0; i < gLH.cartShops.count; ++i) {
            LHCartShop *c = gLH.cartShops[i];
            for (int j = 0; j < c.specifies.count; ++j) {
                LHSpecify *s2 = c.specifies[j];
                
                if ([s1.uid isEqualToString:s2.uid]) {
                    [c.specifies removeObject:s2];
                    --j;
                }else if (!s1.uid && !s2.uid && [s1.productId isEqualToString:s2.productId]) {
                    [c.specifies removeObject:s2];
                    --j;
                }
            }
            
            if (c.specifies.count == 0) {
                [gLH.cartShops removeObject:c];
                --i;
            }
        }
    }
}

#pragma mark - Accessor methods

#pragma mark - Action methods
- (IBAction)receiptButtonPressed:(id)sender {
    LHReceiptViewController *vc = [[LHReceiptViewController alloc] init];
    vc.from = LHReceiptFromChoose;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)payOnLineButtonPressed:(UIButton *)btn {
    if (btn.selected) {
        return;
    }
    
    btn.selected = YES;
    self.payByCardButton.selected = NO;
    [self.paywayCartTextField setHidden:YES];
    
    _vipView.alpha = 1.0f;
    [UIView animateWithDuration:0.6 animations:^{
        _vipView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [_vipView setHidden:YES];
    }];
    
    self.payTopSplitConstraint.constant = 108.0f;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)payByCardButtonPressed:(UIButton *)btn {
    if (self.cartShops.count != 1) {
        JXToast(@"主人，您的会员卡只享有单店下单特权");
        return;
    }
    
    if (btn.selected) {
        return;
    }
    
    btn.selected = YES;
    self.payOnLineButton.selected = NO;
    
    _vipView.alpha = 0.0f;
    [_vipView setHidden:NO];
    [UIView animateWithDuration:0.6 animations:^{
        _vipView.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
    
    self.payTopSplitConstraint.constant = 140.0f;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.paywayCartTextField setHidden:NO];
    }];
}

- (IBAction)couponButtonPressed:(id)sender {
    if (_cartShops.count >= 2) {
        JXToast(@"主人，优惠券不能在多家店合并订单中使用哦");
        return;
    }
    
    CGFloat actualPrice = _totalMoney - _lovebeanMoney;
    if (actualPrice <= 0) {
        JXToast(@"主人，实付金额为0，不要浪费优惠劵券~");
        return;
    }
    
    LHCouponMineViewController *vc = [[LHCouponMineViewController alloc] init];
    vc.totalPrice = _totalMoney;
    vc.actualPrice = actualPrice;
    vc.canSelected = YES;
    vc.shopids = _shopids;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)lovebeanSwitchChanged:(UISwitch *)s {
    if (_cartShops.count >= 2) {
        [s setOn:NO animated:YES];
        JXToast(@"主人，爱豆不能在多家店合并订单中使用哦");
        return;
    }
    
    if (s.on) {
        self.lovebeanTop1Constraint.constant = 89.0f;
        self.lovebeanTop2Constraint.constant = 45.0f;
        
        float count = (_totalMoney - _couponMoney) * 100;
        NSInteger maxUse = (int)count;
        NSInteger maxCan = maxUse > _maxLovebean ? _maxLovebean : maxUse;
        _canLovebean = (maxCan > 0 ? maxCan : 0);
        _lovebeanTextField.placeholder = [NSString stringWithFormat:@"最多%ld", (long)_canLovebean];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.lovebeanSplitImageView setHidden:NO];
            [self.lovebeanUsedView setHidden:NO];
        }];
        
        self.lovebeanMoney = self.lovebeanTextField.text.floatValue / 100.0f;
    }else {
        [self.lovebeanSplitImageView setHidden:YES];
        [self.lovebeanUsedView setHidden:YES];
        self.lovebeanTop1Constraint.constant = 44.0f;
        self.lovebeanTop2Constraint.constant = 0.0f;
        //_footerView.bounds = CGRectMake(0, 0, kJXScreenWidth, _footerView.bounds.size.height - 45.0f);
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        } completion:NULL];
        
        self.lovebeanMoney = 0.0f;
    }
    
    [self configMoneyWithCoupon:self.couponMoney lovebean:self.lovebeanMoney];
}

- (IBAction)lovebeanEditChanged:(UITextField *)textField {
    if (textField.text.length == 0) {
        NSInteger maxUse = ceil((_totalMoney - _couponMoney) * 100);
        NSInteger maxCan = maxUse > _maxLovebean ? _maxLovebean : maxUse;
        _canLovebean = (maxCan > 0 ? maxCan : 0);
        _lovebeanTextField.placeholder = [NSString stringWithFormat:@"最多%ld", (long)_canLovebean];
    }
    
    NSString *original = textField.text;
    if (original.integerValue > _canLovebean) {
        textField.text = [original substringToIndex:original.length - 1];
    }
    
    CGFloat used = textField.text.floatValue / 100.0f;
    NSString *usedString = [NSString stringWithFormat:@"爱豆，抵￥%.2f", used];
    NSRange range = [usedString rangeOfString:@"抵"];
    self.lovebeanUsedLabel.attributedText = [NSAttributedString exAttributedStringWithString:usedString color:[UIColor orangeColor] font:[UIFont boldSystemFontOfSize:14.0f] range:NSMakeRange(range.location + range.length, usedString.length - range.location - range.length)];
    
    self.lovebeanMoney = used;
    [self configMoneyWithCoupon:self.couponMoney lovebean:self.lovebeanMoney];
}

- (IBAction)submitButtonPressed:(id)sender {
    if (self.receiptAddressLabel.text.length == 0) {
        JXToast(@"主人，请选收货地址吧~");
        return;
    }
    
    if ([self.appointTimeLabel.text isEqualToString:@"请选择"] ||
        [self.appointTimeLabel.text isEqualToString:@"亲，请提前一小时预约哟！"]) {
        JXToast(@"主人，请选择上门时间");
        return;
    }
    
    if ((!self.payOnLineButton.selected) && (self.paywayCartTextField.text.length == 0)) {
        JXToast(@"咦，会员卡号不对哦~");
        return;
    }
    
    NSMutableArray *lists = [NSMutableArray array];
    for (LHCartShop *c in self.cartShops) {
        LHOrderSubmitOrderList *list = [[LHOrderSubmitOrderList alloc] init];
        list.shopId = c.shopID;
        list.remark = c.remark;
        
        NSMutableArray *details = [NSMutableArray array];
        for (LHSpecify *s in c.specifies) {
            LHOrderSubmitOrderDetail *detail = [[LHOrderSubmitOrderDetail alloc] init];
            detail.productId = s.productId;
            
            if (LHEntryFromNone/*LHEntryFromCart*/ == _from) {
                detail.specId = s.uid;
            }
            
            detail.specPrice = s.price.floatValue;
            detail.specName = s.name;
            detail.count = s.pieces;
            [details addObject:detail];
        }
        list.orderDetailList = details;
        
        [lists addObject:list];
    }
    
    LHOrderSubmit *orderSubmit = [[LHOrderSubmit alloc] init];
    orderSubmit.customerName = [self.receiptNameLabel.text substringFromIndex:4];
    orderSubmit.customerTelephone = self.receiptPhoneLabel.text;
    orderSubmit.customerAddress = self.receiptAddressLabel.text;
    orderSubmit.orderTotalPrice = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f", self.totalMoney]];
    orderSubmit.payment = self.payOnLineButton.selected ? LHPayWayOnLine : LHPayWayByCard;
    orderSubmit.appointTime = self.appointTimeLabel.text;
    orderSubmit.orderList = lists;
    
    if (self.payOnLineButton.selected) {
        float count = (_lovebeanMoney) * 100;
        orderSubmit.creditsCount = (int)count;
        orderSubmit.couponId = self.coupon.couponId;
    }else {
        orderSubmit.cardNo = self.paywayCartTextField.text;
    }
    
    if (LHEntryFromActivity == _from) {
        orderSubmit.orderType = 2;
    }else {
        orderSubmit.orderType = 1;
    }
    
    [self requestSubmitWithMode:JXWebLaunchModeHUD model:orderSubmit];
}

- (NSDate *)getLatestDate {
    NSDate *date = [NSDate dateWithTimeInterval:(1 * 60 * 60 + 30 * 60) sinceDate:[NSDate date]];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps = [cal components:unitFlags fromDate:date];
    NSInteger minute = [comps minute];
//    if (minute >= 0 && minute < 15) {
//        minute = 0;
//    }else if (minute >= 15 && minute < 30) {
//        minute = 15;
//    }else if (minute >= 30 && minute < 45) {
//        minute = 30;
//    }else {
//        minute = 45;
//    }
    
    if (minute >= 0 && minute < 30) {
        minute = 0;
    }else {
        minute = 30;
    }
    
    NSDateComponents *comps2 = [[NSDateComponents alloc]init];
    [comps2 setYear:[comps year]];
    [comps2 setMonth:[comps month]];
    [comps2 setDay:[comps day]];
    [comps2 setHour:[comps hour]];
    [comps2 setMinute:minute];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    return [calendar dateFromComponents:comps2];
}

- (IBAction)timeButtonPressed:(id)sender {
    self.pickerView.datePicker.minimumDate = [self getLatestDate];
    self.pickerView.datePicker.date = [self.pickerView.datePicker.date laterDate:self.pickerView.datePicker.minimumDate];
    [self.pickerView show:YES];
}

#pragma mark - Notification methods
- (void)notifyCouponSelected:(NSNotification *)notification {
    self.coupon = notification.object;
    if (!self.coupon) {
        self.couponMoney = 0.0f;
        self.couponUsedLabel.textColor = [UIColor blackColor];
        self.couponUsedLabel.text = @"未使用";
        [self configMoneyWithCoupon:self.couponMoney lovebean:self.lovebeanMoney];
        return;
    }
    
    self.couponMoney = self.coupon.price;
    self.couponUsedLabel.textColor = [UIColor orangeColor];
    self.couponUsedLabel.text = [NSString stringWithFormat:@"￥%.2f", self.coupon.price];
    [self configMoneyWithCoupon:self.couponMoney lovebean:self.lovebeanMoney];
    
    if (self.couponMoney >= self.totalMoney) {
        [_lovebeanSwitch setOn:NO animated:YES];
        [self lovebeanSwitchChanged:_lovebeanSwitch];
    }
}


- (void)notifyReceiptSelected:(NSNotification *)notification {
    [self configReceipt:notification.object];
    //    [self.tipsView setHidden:YES];
    //    [self.receiptView setHidden:NO];
    //
    //    self.receiptNameLabel.text = [NSString stringWithFormat:@"收货人：%@", receipt.name];
    //    self.receiptPhoneLabel.text = receipt.mobile;
    //    self.receiptAddressLabel.text = [NSString stringWithFormat:@"%@%@%@%@", receipt.provinceName, receipt.cityName, receipt.areaName, receipt.address];
}

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _cartShops.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LHCartShop *cs = [_cartShops objectAtIndex:section];
    return cs.specifies.count;
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
    
    LHCartShop *cs = [_cartShops objectAtIndex:indexPath.section];
    [specifyCell configSpecify:cs.specifies[indexPath.row] inCart:NO];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [LHShopHeader height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [LHLeaveFooter height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[LHShopHeader identifier]];
    LHShopHeader *shopHeader = (LHShopHeader *)header;
    [shopHeader.checkButton setEnabled:NO];
    [shopHeader.checkButton setImage:nil forState:UIControlStateNormal];
    shopHeader.widthConstraint.constant = 8.0f;
    
    shopHeader.cartShop = _cartShops[section];
    [shopHeader.editButton setHidden:YES];
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[LHLeaveFooter identifier]];
    [(LHLeaveFooter *)footer setCartShop:_cartShops[section]];
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Public methods


#pragma mark - Class methods
- (instancetype)initWithCartShops:(NSArray *)cartShops {
    if (self = [self init]) {
        _cartShops = cartShops;
    }
    return self;
}
@end




