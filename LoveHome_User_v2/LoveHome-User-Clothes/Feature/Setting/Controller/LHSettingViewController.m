//
//  LHSettingViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/26.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHSettingViewController.h"
#import "LHFeedbackViewController.h"
#import "LHAboutViewController.h"

@interface LHSettingViewController ()
@property (nonatomic, weak) IBOutlet UILabel *versionLabel;
@property (nonatomic, weak) IBOutlet UIButton *exitButton;
@end

@implementation LHSettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    gLH.sharedFlag = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    gLH.sharedFlag = NO;
}

- (void)initVar {
}

- (void)initView {
    self.navigationItem.title = @"设置";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem exBarItemWithImage:[UIImage imageNamed:@"ic_share_gray"] size:CGSizeMake(20, 20) target:self action:@selector(shareItemPressed:)];
    
    [self.exitButton setBackgroundImage:ImageWithColor(ColorHex(0xE41F36)) forState:UIControlStateHighlighted];
    [self.exitButton exSetBorder:[UIColor clearColor] width:0 radius:4];
    
    self.versionLabel.text = [JXApp version];
}

- (void)shareItemPressed:(id)sender {
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"我在用爱为家手机客户端";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"我在用爱为家手机客户端";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = kWebDownloadSite;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = kWebDownloadSite;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:kUMAppkey
                                      shareText:@"【爱为家】您身边高品质的一站式社区生活服务平台，点击了解更多"
                                     shareImage:kImageAppIcon
                                shareToSnsNames:@[UMShareToWechatSession, UMShareToWechatTimeline]
                                       delegate:self];
}


- (IBAction)exitButtonPressed:(id)sender {
    [self.operaters exAddObject:
     [LHHTTPClient requestExitWithSuccess:NULL failure:NULL]];
    
    [gLH cleanForLogout];
    [MobClick profileSignOff];
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [[LHLoginViewController sharedController] loginIfNeedWithTarget:self.navigationController error:nil willPresent:NULL didPresented:^{
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    } willCancel:NULL didCancelled:NULL willFinish:NULL didFinished:NULL hasLoginned:NULL];
}

- (IBAction)feedbackButtonPressed:(id)sender {
    LHFeedbackViewController *feedbackVC = [[LHFeedbackViewController alloc] init];
    [self.navigationController pushViewController:feedbackVC animated:YES];
}

- (IBAction)aboutButtonPressed:(id)sender {
    [self.navigationController pushViewController:[[LHAboutViewController alloc] init] animated:YES];
}

- (IBAction)kefuButtonPressed:(id)sender {
    [JXDevice callNumber:@"400-0096-259"];
}

- (IBAction)guanwangButtonPressed:(id)sender {
    [JXDevice browseWeb:@"http://www.appvworks.com"];
}

#pragma mark UMSocialUIDelegate
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType {
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    if (response.responseCode == UMSResponseCodeSuccess) {
        if (gLH.logined) {
            [self.operaters exAddObject:
             [LHHTTPClient requestGetLovebeanWhenSharedWithTaskid:LHShareTaskClient success:^(AFHTTPRequestOperation *operation, NSNumber *response) {
                gLH.user.info.loveBean += response.integerValue;
            } failure:NULL]];
        }
    }
}
@end





