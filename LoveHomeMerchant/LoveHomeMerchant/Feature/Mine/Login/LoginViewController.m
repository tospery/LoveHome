//
//  LoginViewController.m
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/16.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"

@interface LoginViewController ()
@property (nonatomic, strong, readonly) LoginViewModel *viewModel;

@property (nonatomic, weak) IBOutlet UITextField *phoneField;
@property (nonatomic, weak) IBOutlet UITextField *captchaField;
@property (nonatomic, weak) IBOutlet JXCaptchaButton *captchaButton;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@end

@implementation LoginViewController
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 配置文本框
    UIFont *font = [UIFont exDeviceFontOfSize:16.0f];
    self.phoneField.font = font;
    self.captchaField.font = font;
    
    // 配置登录按钮
    ConfigButtonStyle1(self.loginButton);
    
    // 配置获取验证码按钮
    [self.captchaButton setupWithEnableTextColor:kColorRed enableBgColor:[UIColor clearColor] enableBorderColor:kColorRed disableTextColor:JXColorHex(0x333333) disableBgColor:JXColorHex(0xA0A0A0) disableBorderColor:[UIColor clearColor] duration:kTimeCaptcha];
    @weakify(self)
    [self.captchaButton setStartBlock:^BOOL(){
        @strongify(self)
        NSString *result = [JXInputManager verifyPhone:self.viewModel.phone original:nil];
        if (result.length != 0) {
            JXHUDInfo(result, YES);
            return NO;
        }
        [self.viewModel.captchaCommand execute:nil];
        
        return YES;
    }];
}

- (void)bindViewModel {
    [super bindViewModel];
    
     @weakify(self)
    self.phoneField.text = @"13678013283";
    self.captchaField.text = @"123456";
    
    RAC(self.viewModel, phone) = self.phoneField.rac_textSignal;
    RAC(self.viewModel, captcha) = self.captchaField.rac_textSignal;

    [self.phoneField.rac_textSignal subscribeNext:^(NSString *input) {
        @strongify(self)
        if (input.length > 11) {
            self.phoneField.text = [input substringToIndex:11];
            self.viewModel.phone = self.phoneField.text;
        }
    }];
    
    [self.captchaField.rac_textSignal subscribeNext:^(NSString *input) {
        @strongify(self)
        if (input.length > 6) {
            self.captchaField.text = [input substringToIndex:6];
            self.viewModel.captcha = self.captchaField.text;
        }
    }];
    
    [self.viewModel.captchaCommand.errors subscribeNext:^(NSError *error) {
        @strongify(self)
        JXHUDError(error.localizedDescription, YES);
        [self.captchaButton stopTiming];
    }];
    
    self.loginButton.rac_command = self.viewModel.loginCommand;
    
    [self.viewModel.loginCommand.executing subscribeNext:^(NSNumber *executing) {
       @strongify(self)
        if (executing.boolValue) {
            [self.view endEditing:YES];
            JXHUDProcessing(@"正在登录");
        }
//        else {
//            JXHUDHide();
//        }
    }];
}


@end







