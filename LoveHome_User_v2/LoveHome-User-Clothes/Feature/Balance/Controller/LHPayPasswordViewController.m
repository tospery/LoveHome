//
//  LHPayPasswordViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/7.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHPayPasswordViewController.h"
#import "LHPhoneVerifyViewController.h"
#import "LHOperationSuccessViewController.h"

@interface LHPayPasswordViewController ()
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIButton *okButton;
@end

@implementation LHPayPasswordViewController
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
    self.navigationItem.title = @"电子钱包支付";
    
    ConfigButtonRedStyle(self.okButton);
    
    [self.textField exSetupLimit:6];
}

- (void)setupDB {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
- (void)requestVerifyPaywordWithMode:(JXWebLaunchMode)mode {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient requestVerifyPayword:self.textField.text success:^(AFHTTPRequestOperation *operation, NSNumber *response) {
        [self requestPayWithMode:mode];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestVerifyPaywordWithMode:mode];
        }];
    }]];
}

- (void)requestPayWithMode:(JXWebLaunchMode)mode {
    [self.operaters exAddObject:
     [LHHTTPClient requestPayWithWay:LHOnlinePayWayBalance payId:self.pay.payId cash:self.pay.cash success:^(AFHTTPRequestOperation *operation, NSNumber *response) {
        JXHUDHide();
        
        if (!response.boolValue) {
            JXToast(kStringServerException);
        }else {
            gLH.user.info.accountBalance -= self.pay.cash;
            
            if (self.from == LHEntryFromOrder) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyOrderPayed object:self.order];
            }
            
            LHOperationSuccessViewController *vc = [[LHOperationSuccessViewController alloc] init];
            vc.from = self.from;
            vc.type = LHOperationSuccessTypePay;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestVerifyPaywordWithMode:mode];
        }];
    }]];
}

#pragma mark assist
- (BOOL)verifyInput {
    NSString *result = [JXInputManager verifyInput:self.textField.text least:6 original:nil ltSpaces:NO symbols:kJXCharsetNumbers title:@"支付密码" message:@"咦，请保持正确姿势输入支付密码"];
    if (result) {
        JXToast(result);
        return NO;
    }
    
    return YES;
}

#pragma mark - Accessor methods
- (void)setOrder:(LHOrder *)order {
    _order = order;
    _pay = order.pay;
}

#pragma mark - Action methods
- (IBAction)payButtonPressed:(id)sender {
    if (![self verifyInput]) {
        return;
    }
    
    [self requestVerifyPaywordWithMode:JXWebLaunchModeHUD];
}

- (IBAction)forgotButtonPressed:(id)sender {
    static LHPhoneVerifyViewController *paywordVC;
    if (!paywordVC) {
        paywordVC = [[LHPhoneVerifyViewController alloc] initWithMode:LHAccountModeVerifySetPayword];
    }
    [self.navigationController pushViewController:paywordVC animated:YES];
}

#pragma mark - Notification methods

@end
