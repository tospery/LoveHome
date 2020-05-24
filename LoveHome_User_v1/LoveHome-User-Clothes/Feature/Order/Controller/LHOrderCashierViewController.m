//
//  LHOrderCashierViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/7.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHOrderCashierViewController.h"
#import "LHPhoneVerifyViewController.h"
#import "LHPayPasswordViewController.h"
#import "LHRechargeViewController.h"
#import "LHOperationSuccessViewController.h"

@interface LHOrderCashierViewController ()
@property (nonatomic, strong) NSString *alipayOrder;
@property (nonatomic, weak) IBOutlet UILabel *cashLabel;
@property (nonatomic, weak) IBOutlet UILabel *balanceLabel;
@end

@implementation LHOrderCashierViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupDB];
    [self setupNet];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.balanceLabel.text = [NSString stringWithFormat:@"￥%.2f", gLH.user.info.accountBalance];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupView {
    self.navigationItem.title = @"收银台";
    self.navigationItem.leftBarButtonItem = CreateBackBarItem(self);
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看订单" style:UIBarButtonItemStylePlain target:self action:@selector(showItemPressed:)];
    
    self.cashLabel.text = [NSString stringWithFormat:@"￥%.2f", self.pay.cash];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyAlipayRecharge:) name:kNotifyAlipayRecharge object:nil];
}

- (void)setupDB {
}

- (void)setupNet {
}

#pragma mark config
- (void)configBalance {
    self.balanceLabel.text = [NSString stringWithFormat:@"￥%.2f", gLH.user.info.accountBalance];
}

#pragma mark fetch
#pragma mark request
- (void)requestPayWithMode:(JXWebLaunchMode)mode {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient requestPayWithWay:LHOnlinePayWayAlipay payId:self.pay.payId cash:self.pay.cash success:^(AFHTTPRequestOperation *operation, NSString *alipayOrder) {
        JXHUDHide();
        if (alipayOrder.length == 0) {
            JXToast(kStringServerException);
        }else {
            self.alipayOrder = alipayOrder;
            [self sendAlipay];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestPayWithMode:mode];
        }];
    }]];
}

#pragma mark assist
- (void)sendAlipay {
    [[AlipaySDK defaultService] payOrder:self.alipayOrder fromScheme:kSchemeAlipay callback:^(NSDictionary *resultDic) {
        [self parseAlipayWithResult:resultDic];
    }];
}

- (void)parseAlipayWithResult:(NSDictionary *)result {
    NSString *status = [result objectForKey:@"resultStatus"];
    if ([status isEqualToString:@"9000"]) {
        if (!self.from) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyOrderPayed object:self.order];
        }
        
        LHOperationSuccessViewController *vc = [[LHOperationSuccessViewController alloc] init];
        vc.from = self.from;
        vc.type = LHOperationSuccessTypePay;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([status isEqualToString:@"6001"] || [status isEqualToString:@"4000"]) {
        JXAlertParams(@"温馨提示", @"未完成支付，是否继续？", @"取消", @"继续支付");
    }else {
        JXToast(@"咦~支付失败了");
    }
}

#pragma mark - Accessor methods
//- (void)setOrder:(LHOrder *)order {
//    _order = order;
//    _pay = order.pay;
//}

#pragma mark - Action methods
- (void)leftBarItemPressed:(id)sender {
    if (self.from == LHEntryFromNone/*LHEntryFromCart*/) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        NSMutableArray *childs = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
        if (childs.count >= 2) {
            [childs removeObjectAtIndex:childs.count - 2];
        }
        [self.navigationController setViewControllers:childs];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)showItemPressed:(id)sender {
    
}

- (IBAction)balpayButtonPressed:(id)sender {
    if (gLH.user.info.isSetWalletPwdState == 2) {
        JXToast(@"主人，请移步个人中心页面—设置支付密码");
        return;
    }
    
    if (gLH.user.info.accountBalance >= self.pay.cash) {
        LHPayPasswordViewController *vc = [[LHPayPasswordViewController alloc] init];
        vc.from = self.from;
        if (self.from == LHEntryFromNone/*LHEntryFromCart*/) {
            vc.pay = self.pay;
        }else {
            vc.order = self.order;
            vc.pay = self.pay;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        LHRechargeViewController *vc = [[LHRechargeViewController alloc] init];
        vc.reason = LHRechargeReasonPay;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)alipayButtonPressed:(id)sender {
    [self requestPayWithMode:JXWebLaunchModeHUD];
}

- (IBAction)otherButtonPressed:(id)sender {
    JXToast(@"怪我咯，敬请期待 ");
}

#pragma mark - Notification methods
- (void)notifyAlipayRecharge:(NSNotification *)notification {
    [self parseAlipayWithResult:notification.userInfo];
}

#pragma mark - Delegate methods
#pragma mark - Delegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self sendAlipay];
    }
}

#pragma mark - Public methods
- (instancetype)initWithPay:(LHOrderPay *)pay {
    if (self = [self init]) {
        _pay = pay;
    }
    return self;
}

#pragma mark - Class methods

@end
