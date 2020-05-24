//
//  LHRechargeSuccessViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/2.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHRechargeSuccessViewController.h"
#import "LHPhoneVerifyViewController.h"

@interface LHRechargeSuccessViewController ()
@property (nonatomic, weak) IBOutlet UILabel *moneyLabel;
@property (nonatomic, weak) IBOutlet UIButton *passwordButton;
@property (nonatomic, weak) IBOutlet UIButton *buyButton;

@property (nonatomic, weak) IBOutlet UILabel *passwordTipLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topConstraint;
@end

@implementation LHRechargeSuccessViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupView {
    self.navigationItem.title = @"账户充值";
    
    [self.passwordButton setBackgroundImage:[UIImage exImageWithColor:JXColorHex(0xE1E1E1)] forState:UIControlStateHighlighted];
    [self.passwordButton exSetBorder:JXColorHex(0x666666) width:1.0 radius:4.0];
    
    [self.buyButton setBackgroundImage:[UIImage exImageWithColor:JXColorHex(0x0CBDB9)] forState:UIControlStateHighlighted];
    [self.buyButton exSetBorder:[UIColor clearColor] width:0.0 radius:4.0];
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", gLH.user.info.accountBalance];
    
    
    if (gLH.user.info.isSetWalletPwdState == 1) {
        [_passwordTipLabel setHidden:YES];
        [_passwordButton setHidden:YES];
        self.topConstraint.constant = 30;
    }
}


#pragma mark - Action methods
- (IBAction)passwordButtonPressed:(id)sender {
    static LHPhoneVerifyViewController *paywordVC;
    if (!paywordVC) {
        paywordVC = [[LHPhoneVerifyViewController alloc] initWithMode:LHAccountModeVerifySetPayword];
    }
    [self.navigationController pushViewController:paywordVC animated:YES];
}

- (IBAction)buyButtonPressed:(id)sender {
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
