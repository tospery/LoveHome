//
//  LHLoginViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/16.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "LHLoginViewController.h"
#import "LHSigninViewController.h"


static LHNavigationController *loginNav;

@interface LHLoginViewController ()
@property (nonatomic, assign) BOOL isAutoSignin;
@property (nonatomic, assign) BOOL isNotify;
@property (nonatomic, weak) IBOutlet LHCaptchaButton *codeButton;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UITextField *codeTextField;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;

@property (nonatomic, copy) LHLoginWillCancelBlock      willCancel;
@property (nonatomic, copy) LHLoginDidCancelledBlock    didCancelled;
@property (nonatomic, copy) LHLoginWillFinishBlock      willFinish;
@property (nonatomic, copy) LHLoginDidFinishedBlock     didFinished;
@end

@implementation LHLoginViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initVar];
    [self initView];
    [self initDB];
    [self initNet];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.codeButton.timer) {
        if (!_isNotify) {
            _codeTextField.text = @"";
            [self.codeButton resetCodeState:NO];
        }else {
            _isNotify = NO;
        }
    }
}

#pragma mark - Private methods
#pragma mark init
- (void)initVar {
    self.codeButton.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyAutoLogin:) name:kNotifyAutoLogin object:nil];
}

- (void)notifyAutoLogin:(NSNotification *)notification {
    _isNotify = YES;
    
    NSArray *obj = notification.object;
    _phoneTextField.text = [obj firstObject];
    _codeTextField.text = [obj lastObject];
    [self loginButtonPressed:nil];
}

- (void)initView {
    self.navigationItem.title = @"登录";
    self.navigationItem.leftBarButtonItem = CreateBackBarItem(self);
    
    ConfigButtonStyle(_loginButton);
    [_phoneTextField exSetupLimit:11];
    [_codeTextField exSetupLimit:6];
}

- (void)initDB {
}

- (void)initNet {
}

- (void)requestSignin {
    if (_isAutoSignin) {
        HUDProcessing(nil);
    }
    [LHHTTPClient signinWithPhone:_phoneTextField.text code:_codeTextField.text success:^(AFHTTPRequestOperation *operation, id response) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyAutoLogin object:@[_phoneTextField.text, _codeTextField.text]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isAutoSignin = NO;
        HUDHide();
        Toast(error.localizedDescription);
        [self.codeButton resetCodeState:YES];
    }];
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

#pragma mark - Public methods
- (BOOL)loginIfNeedWithTarget:(UIViewController *)target
                        error:(NSError *)error
                  willPresent:(LHLoginWillPresentBlock)willPresent
                 didPresented:(LHLoginDidPresentedBlock)didPresented
                   willCancel:(LHLoginWillCancelBlock)willCancel
                 didCancelled:(LHLoginDidCancelledBlock)didCancelled
                   willFinish:(LHLoginWillFinishBlock)willFinish
                  didFinished:(LHLoginDidFinishedBlock)didFinished
                  hasLoginned:(LHLoginHasLoginnedBlock)hasLoginned {
    if (error) {
        if (JXErrorCodeTokenInvalid == error.code) {
            gLH.logined = NO;
        }else {
            if (hasLoginned) {
                hasLoginned();
            }
            return NO;
        }
    }
    
    if (gLH.logined) {
        if (hasLoginned) {
            hasLoginned();
        }
        return NO;
    }
    
    if(self.isPresented) {
        return NO;
    }
    
    if (!loginNav) {
        loginNav = [[LHNavigationController alloc] initWithRootViewController:self];
    }
    if (loginNav.isBeingPresented || loginNav.isBeingDismissed) {
        return NO;
    }
    
    _willCancel = willCancel;
    _didCancelled = didCancelled;
    _willFinish = willFinish;
    _didFinished = didFinished;
    
    if (willPresent) {
        willPresent();
    }
    
    self.isPresented = YES;
    [target presentViewController:loginNav animated:YES completion:^{
        //[loginNav.view makeToast:error.localizedDescription duration:1.5f position:CSToastPositionCenter];
        if (didPresented) {
            didPresented();
        }
    }];
    
    return YES;
}

- (void)postPushCode {
    NSString *code = [APService registrationID];
    if (code.length != 0) {
        [LHHTTPClient postPushCodeWithCode:code success:NULL failure:NULL];
    }
}

#pragma mark - Action methods
- (IBAction)loginButtonPressed:(id)sender {
    if (![self verifyInput]) {
        return;
    }
    [self.view endEditing:YES];
    
    if (_isAutoSignin) {
        HUDProcessing(nil);
    }else {
        HUDProcessing(@"正在登录");
    }
    
    [LHHTTPClient loginWithPhone:_phoneTextField.text code:_codeTextField.text device:[JXDevice brief] success:^(AFHTTPRequestOperation *operation, LHUser *user) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            HUDHide();
            [_codeButton resetCodeState:NO];
            
            gLH.logined = YES;
            gLH.account = _phoneTextField.text;
            gLH.user = user;
            
            //        _isPresented = NO;
            //        ExecuteLoginFinishedBlock();
            //        [self dismissViewControllerAnimated:YES completion:^{
            //            [self.codeButton resetCodeState:NO];
            //        }];
            [self postPushCode];
            [MobClick profileSignInWithPUID:gLH.user.info.phoneNumber];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyLoginSuccess object:nil];
            //[[NSNotificationCenter defaultCenter] postNotificationName:kNotifyReceiptChanged object:nil];
            
            if (_willFinish) {
                _willFinish();
            }
            [self dismissViewControllerAnimated:YES completion:^{
                self.isPresented = NO;
                if (_didFinished) {
                    _didFinished();
                }
            }];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isAutoSignin = NO;
        if ([error.localizedDescription isEqualToString:@"手机号未注册,请先注册"]) {
            HUDHide();
            JXAlertParams(@"登录", @"验证成功，您目前暂未注册，请确认是否注册并登录！", @"取消", @"确认");
        }else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                HUDHide();
                Toast(error.localizedDescription);
                [self.codeButton resetCodeState:YES];
            });
        }
    }];
}

- (IBAction)signupButtonPressed:(id)sender {
    static LHSigninViewController *signupVC;
    if (!signupVC) {
        signupVC = [[LHSigninViewController alloc] init];
    }
    [self.navigationController pushViewController:signupVC animated:YES];
}

- (void)leftBarItemPressed:(id)sender {
    //    _isPresented = NO;
    //    ExecuteLoginCancelledBlock();
    //    [self dismissViewControllerAnimated:YES completion:^{
    //    }];
    
    if (_willCancel) {
        _willCancel();
    }
    [self dismissViewControllerAnimated:YES completion:^{
        self.isPresented = NO;
        if (_didCancelled) {
            _didCancelled();
        }
    }];
}

#pragma mark - Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        _isAutoSignin = YES;
        [self requestSignin];
    }
}

- (BOOL)LHCaptchaButtonShouldStartCountDown {
    if (![self verifyInputForCode]) {
        return NO;
    }
    
    [LHHTTPClient getcodeWithPhone:self.phoneTextField.text success:^(AFHTTPRequestOperation *operation, NSString *code) {
        if (code.length == 0) {
            Toast(kStringServerException);
        }else {
            // YJX_TODO 测试验证码
            //            Toast(code);
            //            self.codeTextField.text = code;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.codeButton resetCodeState:YES];
        Toast(error.localizedDescription);
    }];
    
    return YES;
}

- (void)LHCaptchaButtonDidStartCountDown {
}

- (void)LHCaptchaButtonDidEndCountDown {
}

#pragma mark - Class methods
+ (LHLoginViewController *)sharedController {
    static LHLoginViewController *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LHLoginViewController alloc] init];
    });
    return instance;
}
@end
