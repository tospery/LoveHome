//
//  LHPaywordViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/26.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHPhoneVerifyViewController.h"
#import "LHPaywordSetViewController.h"

@interface LHPhoneVerifyViewController ()
@property (nonatomic, assign) LHAccountMode mode;
@property (nonatomic, weak) IBOutlet LHCaptchaButton *codeButton;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UITextField *codeTextField;
@end

@implementation LHPhoneVerifyViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initVar];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.mode == LHAccountModeChangePhone) {
        self.navigationItem.title = @"修改绑定手机";
        self.phoneTextField.placeholder = @"请输入新手机号";
        [self.submitButton setTitle:@"修改" forState:UIControlStateNormal];
    }else {
        self.navigationItem.title = @"验证";
        self.phoneTextField.placeholder = @"请输入手机号";
        [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
    }
    
    if (!self.codeButton.timer) {
        _codeTextField.text = @"";
        [self.codeButton resetCodeState:NO];
    }
}

#pragma mark - Private methods
#pragma mark init
- (void)initVar {
    self.codeButton.delegate = self;
}

- (void)initView {
    // self.navigationItem.leftBarButtonItem = CreateBackBarItem(self);
    
    ConfigButtonStyle(self.submitButton);
    [_phoneTextField exSetupLimit:11];
    [_codeTextField exSetupLimit:6];
}

#pragma mark - assist
- (BOOL)verifyInputForCode {
    NSString *verify = [JXInputManager verifyPhoneNumber:self.phoneTextField.text original:nil];
    if (verify) {
        Toast(verify);
        return NO;
    }
    return YES;
}

- (BOOL)verifyInput {
    if (![self verifyInputForCode]) {
        return NO;
    }
    
    NSString *verify = [JXInputManager verifyInput:_codeTextField.text least:6 original:nil spacesAllowed:NO pureChars:NO pureNums:YES name:@"验证码"];
    if (verify) {
        Toast(verify);
        return NO;
    }
    
    return YES;
}

- (void)requestVerifyMobile {
    HUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient validateMobileWithCode:self.codeTextField.text phone:self.phoneTextField.text success:^(AFHTTPRequestOperation *operation, NSNumber *result) {
        JXHUDHide();
        [self.codeButton resetCodeState:NO];
        
        if (self.mode == LHAccountModeVerifySetPayword) {
            [self.navigationController pushViewController:[[LHPaywordSetViewController alloc] init] animated:YES];
        }else if (self.mode == LHAccountModeVerifyChangePhone) {
            static LHPhoneVerifyViewController *changeMobileVC;
            if (!changeMobileVC) {
                changeMobileVC = [[LHPhoneVerifyViewController alloc] initWithMode:LHAccountModeChangePhone];
            }
            [self.navigationController pushViewController:changeMobileVC animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:JXWebLaunchModeHUD way:JXWebHandleWayToast error:error callback:^{
            [self requestVerifyMobile];
        }];
        [self.codeButton resetCodeState:YES];
    }]];
}

- (void)requestChangeMobile {
    HUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient modifyMobileWithPhonenumber:self.phoneTextField.text code:self.codeTextField.text success:^(AFHTTPRequestOperation *operation, id response) {
        JXHUDHide();
        [self.codeButton resetCodeState:NO];
        gLH.user.info.phoneNumber = self.phoneTextField.text;
        Toast(@"修改成功!");
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:JXWebLaunchModeHUD way:JXWebHandleWayToast error:error callback:^{
            [self requestChangeMobile];
        }];
        [self.codeButton resetCodeState:YES];
    }]];
}

#pragma mark - Action methods
- (IBAction)submitButtonPressed {
    if (![self verifyInput]) {
        return;
    }
    
    switch (self.mode) {
        case LHAccountModeChangePhone: {
            [self requestChangeMobile];
            break;
        }
        default: {
            [self requestVerifyMobile];
            break;
        }
    }
}

#pragma mark - Delegate methods
- (BOOL)LHCaptchaButtonShouldStartCountDown {
    if (![self verifyInputForCode]) {
        return NO;
    }
    
    [self.operaters exAddObject:
     [LHHTTPClient getcodeWithPhone:self.phoneTextField.text success:^(AFHTTPRequestOperation *operation, NSString *code) {
//        Toast(code);
//        self.codeTextField.text = code;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.codeButton resetCodeState:YES];
        Toast(error.localizedDescription);
    }]];
    
    return YES;
}

#pragma mark - Public methods
- (instancetype)initWithMode:(LHAccountMode)mode {
    if (self = [self init]) {
        _mode = mode;
    }
    return self;
}
@end






