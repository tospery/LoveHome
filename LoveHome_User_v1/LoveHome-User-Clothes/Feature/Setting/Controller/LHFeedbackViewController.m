//
//  LHFeedbackViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/26.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHFeedbackViewController.h"

@interface LHFeedbackViewController ()
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIView *bgView;
@end

@implementation LHFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"意见反馈";
    [self.bgView exSetBorder:[UIColor clearColor] width:0 radius:4];
    ConfigButtonStyle(self.button);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        [self.label setHidden:NO];
    }else {
        [self.label setHidden:YES];
    }
}

- (BOOL)verifyInput {
    NSString *result = [JXInputManager verifyInput:_textView.text least:4 original:nil ltSpaces:NO symbols:nil title:@"反馈内容" message:@"请输入有效的反馈内容"];
    if (result) {
        JXToast(result);
        return NO;
    }
    
    return YES;
}

- (void)requestFeedbackWithMode:(JXWebLaunchMode)mode {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient requestFeedbackWithContent:_textView.text success:^(AFHTTPRequestOperation *operation, id response) {
        JXHUDHide();
        JXToast(@"主人，小爱收到您的反馈啦~");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestFeedbackWithMode:mode];
        }];
    }]];
}

- (IBAction)submitButtonPressed:(id)sender {
    if (![self verifyInput]) {
        return;
    }
    
    [self requestFeedbackWithMode:JXWebLaunchModeHUD];
}

@end




