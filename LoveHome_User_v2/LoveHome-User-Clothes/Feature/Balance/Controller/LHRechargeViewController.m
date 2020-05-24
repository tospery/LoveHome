//
//  LHRechargeViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/2.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHRechargeViewController.h"
#import "LHRechargeSuccessViewController.h"
#import "LHPayPasswordViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "LHWXPayResponse.h"

@interface LHRechargeViewController ()
@property (nonatomic, strong) NSString *alipayOrder;
@property (nonatomic, weak) IBOutlet UITextField *moneyTextField;
@property (nonatomic, weak) IBOutlet UIButton *okButton;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *wayButtons;
@end

@implementation LHRechargeViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupView {
    self.navigationItem.title = @"账户充值";
    
    ConfigButtonRedStyle(self.okButton);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyAlipayRecharge:) name:kNotifyAlipayRecharge object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyWxpayPayment:) name:kNotifyWxpayPayment object:nil];
}

#pragma mark request
- (void)requestRecharge {
    NSInteger way;
    for (NSInteger i = 0; i < self.wayButtons.count; ++i) {
        UIButton *btn = self.wayButtons[i];
        if (btn.selected) {
            way = i + 1;
            break;
        }
    }

    if (way == 2) {
        way = 3;
    }else if (way == 3) {
        way = 2;
    }

    [self.operaters exAddObject:
     [LHHTTPClient rechargeWithMoney:[self.moneyTextField.text exFloatValue] way:way success:^(AFHTTPRequestOperation *operation, NSString *alipayOrder) {
        if (alipayOrder.length == 0) {
            JXToast(kStringServerException);
        }else {
            if (LHOnlinePayWayAlipay == way) {
                self.alipayOrder = alipayOrder;
                [self sendAlipay];
            }else if (LHOnlinePayWayWxpay == way) {
                LHWXPayResponse *wx = [LHWXPayResponse objectWithKeyValues:alipayOrder];
                if (wx.appid.length == 0) {
                    JXToast(kStringServerException);
                }else if (wx.retcode != 0) {
                    JXToast(wx.retmsg);
                }else {
                    PayReq *req = [[PayReq alloc] init];
                    req.partnerId = wx.partnerid;
                    req.prepayId = wx.prepayid;
                    req.nonceStr = wx.noncestr;
                    req.timeStamp = (UInt32)wx.timestamp;
                    req.package = wx.packages;
                    req.sign = wx.sign;
                    [WXApi sendReq:req];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        JXToast(error.localizedDescription);
    }]];
}

#pragma mark assist
- (BOOL)verifyInput {
    NSString *result = [JXInputManager verifyInput:self.moneyTextField.text
                                             least:0
                                          original:nil
                                          ltSpaces:NO
                                           symbols:[NSString stringWithFormat:@".%@", kJXCharsetNumbers]
                                             title:@"金额"
                                           message:@"主人，请输入有效金额"];
    if (result) {
        JXToast(result);
        return NO;
    }
    
    CGFloat value = [self.moneyTextField.text floatValue];
    if (value == 0) {
        JXToast(@"主人，请输入有效金额");
        return NO;
    }
    
    return YES;
}

- (void)sendAlipay {
    [[AlipaySDK defaultService] payOrder:self.alipayOrder fromScheme:kSchemeAlipay callback:^(NSDictionary *resultDic) {
        [self parseAlipayWithResult:resultDic];
    }];
}

- (void)parseAlipayWithResult:(NSDictionary *)result {
    NSString *status = [result objectForKey:@"resultStatus"];
    if ([status isEqualToString:@"9000"]) {
        gLH.user.info.accountBalance += [self.moneyTextField.text exFloatValue];
        
        if (self.reason == LHRechargeReasonPay) {
            [self.navigationController pushViewController:[[LHPayPasswordViewController alloc] init] animated:YES];
        }else {
            [self.navigationController pushViewController:[[LHRechargeSuccessViewController alloc] init] animated:YES];
        }
    }else if ([status isEqualToString:@"6001"] || [status isEqualToString:@"4000"]) {
        JXAlertParams(@"温馨提示", @"未完成充值，是否继续？", @"取消", @"继续充值");
    }else {
        JXToast(@"偶买噶，充值失败呃");
    }
}

#pragma mark - Accessor methods
#pragma mark - Action methods
- (IBAction)okButtonPressed:(id)sender {
    if (![self verifyInput]) {
        return;
    }
    
    [self requestRecharge];
}

- (IBAction)wayButtonPressed:(UIButton *)btn {
    UIButton *wayButton = [self.wayButtons objectAtIndex:btn.tag];
    if (wayButton.selected) {
        return;
    }
    
    if (btn.tag != 0 && btn.tag != 1) {
        JXToast(@"怪我咯，敬请期待 ");
        return;
    }
    
    for (UIButton *obj in self.wayButtons) {
        obj.selected = NO;
    }
    wayButton.selected = YES;
}

- (IBAction)moneyEditChanged:(UITextField *)textField {
    NSString *original = textField.text;
    if (original.length == 0) {
        return;
    }
    
    // 排除非法字符的输入
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@".%@", kJXCharsetNumbers]] invertedSet];
    NSRange range = [original rangeOfCharacterFromSet:allowedCharacters];
    if (range.location != NSNotFound) {
        textField.text = [original substringToIndex:(original.length - 1)];
        return;
    }
    
    // 排除第个"."
    NSString *input = [original substringFromIndex:original.length - 1];
    if ([input isEqualToString:@"."]) {
        NSRange range = [original rangeOfString:@"."];
        if (range.location != (original.length - 1)) {
            textField.text = [original substringToIndex:(original.length - 1)];
            return;
        }
    }
    
    // 排除小数点第三位
    range = [original rangeOfString:@"." options:NSBackwardsSearch];
    if (range.location == NSNotFound) {
        return;
    }
    
    if (original.length <= (range.location + 3)) {
        return;
    }
    
    textField.text = [original substringToIndex:(range.location + 3)];
}

#pragma mark - Notification methods
- (void)notifyAlipayRecharge:(NSNotification *)notification {
    [self parseAlipayWithResult:notification.userInfo];
}

- (void)notifyWxpayPayment:(NSNotification *)notification {
    PayResp *resp = notification.object;
    switch (resp.errCode) {
        case WXSuccess: {
            gLH.user.info.accountBalance += [self.moneyTextField.text exFloatValue];
            
            if (self.reason == LHRechargeReasonPay) {
                [self.navigationController pushViewController:[[LHPayPasswordViewController alloc] init] animated:YES];
            }else {
                [self.navigationController pushViewController:[[LHRechargeSuccessViewController alloc] init] animated:YES];
            }
        }
            break;
        default: {
            JXToast(@"偶买噶，充值失败呃");
        }
            break;
    }
}

#pragma mark - Delegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self sendAlipay];
    }
}
@end
