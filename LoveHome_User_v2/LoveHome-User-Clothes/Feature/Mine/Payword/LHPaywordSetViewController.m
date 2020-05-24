//
//  LHPaywordSetViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/26.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHPaywordSetViewController.h"

@interface LHPaywordSetViewController ()
@property (nonatomic, weak) IBOutlet UITextField *paywordTextField1;
@property (nonatomic, weak) IBOutlet UITextField *paywordTextField2;
@property (nonatomic, weak) IBOutlet UIButton *okButton;
@end

@implementation LHPaywordSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"设置支付密码";
    
    ConfigButtonStyle(self.okButton);
    [self.paywordTextField1 exSetupLimit:6];
    [self.paywordTextField2 exSetupLimit:6];
}

- (BOOL)verifyInput {
    NSString *verify = [JXInputManager verifyInput:self.paywordTextField1.text least:6 original:nil ltSpaces:NO symbols:kJXCharsetNumbers title:@"支付密码" message:@"咦，请保持正确姿势输入支付密码"];
    if (verify) {
        Toast(verify);
        return NO;
    }
    
    verify = [JXInputManager verifyInput:self.paywordTextField2.text least:6 original:nil ltSpaces:NO symbols:kJXCharsetNumbers title:@"确认密码" message:@"请输入有效的确认密码"];
    if (verify) {
        Toast(verify);
        return NO;
    }
    
    if (![self.paywordTextField1.text isEqualToString:self.paywordTextField2.text]) {
        Toast(@"两次输入的支付密码不一致");
        return NO;
    }
    
    return YES;
}

- (IBAction)okButtonPressed:(id)sender {
    if (![self verifyInput]) {
        return;
    }
    
    HUDProcessing(nil);
    [self.operaters exAddObject:
    [LHHTTPClient setPayword:self.paywordTextField1.text success:^(AFHTTPRequestOperation *operation, id response) {
        JXHUDHide();
        Toast(@"设置成功");
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:JXWebLaunchModeHUD way:JXWebHandleWayToast error:error callback:^{
            [self okButtonPressed:sender];
        }];
    }]];
}
@end
