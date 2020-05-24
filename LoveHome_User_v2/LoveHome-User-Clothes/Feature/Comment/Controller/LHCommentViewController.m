//
//  LHCommentShopViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/9.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHCommentViewController.h"
#import "LHStarView.h"

@interface LHCommentViewController ()
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIView *bgView;

@property (nonatomic, weak) IBOutlet LHStarView *actualStarView;
@property (nonatomic, weak) IBOutlet LHStarView *serviceStarView;
@property (nonatomic, weak) IBOutlet LHStarView *speedStarView;
@end

@implementation LHCommentViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"商铺服务评价";
    self.navigationItem.leftBarButtonItem = CreateBackBarItem(self);
    
    [self.bgView exSetBorder:[UIColor clearColor] width:0 radius:4];
    ConfigButtonStyle(self.button);
    
    self.actualStarView.enabled = YES;
    self.actualStarView.level = 5;
    [self.actualStarView loadData];
    
    self.serviceStarView.enabled = YES;
    self.serviceStarView.level = 5;
    [self.serviceStarView loadData];
    
    self.speedStarView.enabled = YES;
    self.speedStarView.level = 5;
    [self.speedStarView loadData];
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

- (void)leftBarItemPressed:(id)sender {
    NSMutableArray *childs = [NSMutableArray array];
    [childs addObject:[self.navigationController.childViewControllers objectAtIndex:0]];
    [childs addObject:[self.navigationController.childViewControllers objectAtIndex:1]];
    [childs addObject:self];
    [self.navigationController setViewControllers:childs];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitButtonPressed:(id)sender {
    NSString *result = [JXInputManager verifyInput:self.textView.text least:2 original:nil ltSpaces:NO symbols:nil title:@"评价" message:@"主人，给我写点评语吧MUMA~"];
    if (result) {
        JXToast(result);
        return;
    }
    
    [_button setEnabled:NO];
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
    [LHHTTPClient requestCommentShopWithContent:self.textView.text shopId:self.order.shopId orderId:self.order.uid descriptLevel:self.actualStarView.level serviceLevel:self.serviceStarView.level speedLevel:self.speedStarView.level success:^(AFHTTPRequestOperation *operation, id response) {
        JXHUDHide();
        JXToast(@"棒棒哒~，主人期待更好的我吧~");
        
        self.order.status = LHOrderResponseTypeFinished;
        if (_section >= 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyOrderCommented object:[NSNumber numberWithInteger:_section]];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self leftBarItemPressed:nil];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_button setEnabled:YES];
        [self handleFailureForView:nil rect:CGRectZero mode:JXWebLaunchModeHUD way:JXWebHandleWayToast error:error callback:^{
            [self submitButtonPressed:sender];
        }];
    }]];
}

- (instancetype)init {
    if (self = [super init]) {
        _section = -1;
    }
    return self;
}

@end
