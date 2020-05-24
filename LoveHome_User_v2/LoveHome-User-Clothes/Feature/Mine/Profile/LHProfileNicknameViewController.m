//
//  LHProfileNicknameViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/24.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHProfileNicknameViewController.h"

@interface LHProfileNicknameViewController ()
@property (nonatomic, weak) IBOutlet UITextField *nicknameTextField;
@property (nonatomic, weak) IBOutlet UIButton *modifyButton;
@end

@implementation LHProfileNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"修改昵称";
    self.nicknameTextField.text = gLH.user.info.nickName;
    ConfigButtonStyle(self.modifyButton);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.nicknameTextField becomeFirstResponder];
}

- (IBAction)modifyButtonPressed:(id)sender {
    NSString *result = [JXInputManager verifyInput:self.nicknameTextField.text least:1 original:gLH.user.info.nickName ltSpaces:NO symbols:nil title:@"昵称" message:@"请输入有效的昵称"];
    if (result) {
        JXToast(result);
        return;
    }
    
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient modifyNickname:self.nicknameTextField.text success:^(AFHTTPRequestOperation *operation, id response) {
        JXHUDHide();
        gLH.user.info.nickName = self.nicknameTextField.text;
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:JXWebLaunchModeHUD way:JXWebHandleWayToast error:error callback:^{
            [self modifyButtonPressed:sender];
        }];
    }]];
}

@end
