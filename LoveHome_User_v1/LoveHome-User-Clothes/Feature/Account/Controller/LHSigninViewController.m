//
//  LHSignupViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/16.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "LHSigninViewController.h"

@interface LHSigninViewController ()
@property (nonatomic, weak) IBOutlet LHCaptchaButton *codeButton;
@property (nonatomic, weak) IBOutlet UIButton *signupButton;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UITextField *codeTextField;
@end

@implementation LHSigninViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initVar];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.codeButton.timer) {
        _phoneTextField.text = @"";
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
    self.navigationItem.title = @"注册";
    // self.navigationItem.leftBarButtonItem = CreateBackBarItem(self);
    
    ConfigButtonStyle(_signupButton);
    [_phoneTextField exSetupLimit:11];
    [_codeTextField exSetupLimit:6];
}


#pragma mark - assist
- (BOOL)verifyInputForCode {
    NSString *verify = [JXInputManager verifyPhoneNumber:_phoneTextField.text original:nil];
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

#pragma mark - Action methods
- (IBAction)termButtonPressed:(id)sender {
    JXWebViewController *webVC = [[JXWebViewController alloc] initWithURLString:kHTTPTerm];
    [self.navigationController pushViewController:webVC animated:YES];
}

//- (void)postPushCode {
//    NSString *code = [APService registrationID];
//    if (code.length != 0) {
//        [LHHTTPClient postPushCodeWithCode:code success:NULL failure:NULL];
//    }
//}

- (IBAction)signinButtonPressed {
    if (![self verifyInput]) {
        return;
    }
    
    _signupButton.enabled = NO;
    HUDProcessing(@"正在注册");
    [LHHTTPClient signinWithPhone:_phoneTextField.text code:_codeTextField.text success:^(AFHTTPRequestOperation *operation, id response) {
        HUDHide();
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyAutoLogin object:@[_phoneTextField.text, _codeTextField.text]];
        
        [self.codeButton resetCodeState:NO];
        [self.navigationController popViewControllerAnimated:YES];
        
//        Toast(@"恭喜你，注册成功！");
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.codeButton resetCodeState:NO];
//            [self.navigationController popViewControllerAnimated:YES];
//        });
        
//        // 测试
//        [LHHTTPClient loginWithPhone:_phoneTextField.text code:_codeTextField.text device:[JXDevice brief] success:^(AFHTTPRequestOperation *operation, LHUser *user) {
//            HUDHide();
//            [_codeButton resetCodeState:NO];
//            
//            gLH.logined = YES;
//            gLH.account = _phoneTextField.text;
//            gLH.user = user;
//            
//            //        _isPresented = NO;
//            //        ExecuteLoginFinishedBlock();
//            //        [self dismissViewControllerAnimated:YES completion:^{
//            //            [self.codeButton resetCodeState:NO];
//            //        }];
//            [self postPushCode];
//            
//            if (_willFinish) {
//                _willFinish();
//            }
//            [self dismissViewControllerAnimated:YES completion:^{
//                self.isPresented = NO;
//                if (_didFinished) {
//                    _didFinished();
//                }
//            }];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            HUDHide();
//            Toast(error.localizedDescription);
//            [self.codeButton resetCodeState:YES];
//        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDHide();
        Toast(error.localizedDescription);
        [self.codeButton resetCodeState:YES];
        _signupButton.enabled = YES;
    }];
}

#pragma mark - Delegate methods
- (BOOL)LHCaptchaButtonShouldStartCountDown {
    if (![self verifyInputForCode]) {
        return NO;
    }
    
    [LHHTTPClient getcodeWithPhone:self.phoneTextField.text success:^(AFHTTPRequestOperation *operation, NSString *code) {
        if (code.length == 0) {
            Toast(kStringServerException);
        }else {
//            Toast(code);
//            self.codeTextField.text = code;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.codeButton resetCodeState:YES];
        Toast(error.localizedDescription);
    }];
    
    return YES;
}
@end
