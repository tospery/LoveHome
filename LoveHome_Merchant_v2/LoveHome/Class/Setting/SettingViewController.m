//
//  SettingViewController.m
//  LoveHome
//
//  Created by 杨建祥 on 15/8/28.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "SettingViewController.h"
#import "CustomButton.h"
#import "NotificationViewController.h"
#import "ShareShopViewController.h"
#import "UMSocial.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#define kUMAppkey                       (@"564957b8e0f55aa261000ca1")

@interface SettingViewController () <UMSocialUIDelegate, UMSocialDataDelegate>

@property (nonatomic, weak) IBOutlet UILabel *versionLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;

@property (nonatomic, weak) IBOutlet CustomButton *closeButton;
@property (nonatomic, weak) IBOutlet CornerRadiusButton *exitButton;

@property (nonatomic, strong) NSString *once;

@property (nonatomic, strong) NSString *sleepingState;
@end

@implementation SettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
    
    [self checkoutNotifacationCount];
}

- (void)initView {
    self.navigationItem.title = @"设置";
    self.versionLabel.text = [NSString stringWithFormat:@"当前版本 %@", [JXApp version]];
    
    [self.countLabel exCircleWithColor:[UIColor clearColor] border:0];
    self.closeButton.layer.cornerRadius = 4;
    self.closeButton.clipsToBounds = YES;
    self.exitButton.clipsToBounds = YES;
    
    //[self.closeButton setTitle:@"开张店铺" forState:UIControlStateSelected];  // 关店状态

//    [self.closeButton setTitle:@"休息店铺" forState:UIControlStateNormal];   // 开张状态
    [self.closeButton setBackgroundImage:[UIImage exImageWithColor:JXColorHex(0xED812F)] forState:UIControlStateNormal];
    [self.closeButton setBackgroundImage:[UIImage exImageWithColor:JXColorHex(0xf79137)] forState:UIControlStateHighlighted];
    [self.exitButton setBackgroundImage:[UIImage exImageWithColor:JXColorHex(0xEB0E1B)] forState:UIControlStateNormal];
    [self.exitButton setBackgroundImage:[UIImage exImageWithColor:JXColorHex(0xbe2625)] forState:UIControlStateHighlighted];
    
    [self.closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([UserTools sharedUserTools].userModel) {
        [self.exitButton setTitle:@"注销" forState:UIControlStateNormal];
    }else {
        [self.exitButton setTitle:@"登录" forState:UIControlStateNormal];
    }
    
   #pragma mark - 之前的5是 关 6是开 现在的 1 是开 ,2 是关
    UserDataModel *user = [UserTools sharedUserTools].userModel;
    NSLog(@"user.sleeping ==  %ld",user.sleeping);
    _sleepingState = [NSString stringWithFormat:@"%ld", user.sleeping];
    if ([_sleepingState isEqualToString:@"1"]) {
        [self.closeButton setTitle:@"休息店铺" forState:UIControlStateNormal];   // 开张状态
        self.once = @"open";
    } else if ([_sleepingState isEqualToString:@"2"]){
        [self.closeButton setTitle:@"开张店铺" forState:UIControlStateNormal];
        self.once = @"sleep";
    
    }
     NSLog(@"self.once %@, 店铺状态 %@", self.once,_sleepingState);

}


#pragma mark - 获取订单消息未读总数
- (void)checkoutNotifacationCount
{
    [HttpServiceManageObject sendPostRequestWithPathUrl:@"general/getOrderMsgUnreadTotal" andToken:YES andParameterDic:nil andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:^(AFHTTPRequestOperation *operation, id responsObject) {
        
        //NSLog(@"123");
        NSLog(@"%ld",(long)[responsObject integerValue]);
        if ([responsObject integerValue] < 1) {
            //_countLabel.hidden = YES;
        }
        else
        {
            _countLabel.hidden = NO;
            _countLabel.text = [NSString stringWithFormat:@"%@",responsObject];
        }
        
        
    } andFailedCallback:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}


#pragma mark - Action methods

- (IBAction)messageButtonPressed:(id)sender {
 
    NotificationViewController *vc = [[NotificationViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 分享店铺按钮点击事件
- (IBAction)shareButtonAction:(UIButton *)sender {
    
    NSLog(@"点点点点点");
    
    UserDataModel *user = [UserTools sharedUserTools].userModel;
    NSInteger shopId = user.shopId == 0 ? 378 : user.shopId;
    
    NSString *shopLogo = user.shopLogo;
    NSString *str = [NSString stringWithFormat:@"https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx9f0d2574e4dfa412&redirect_uri=http%%3A%%2F%%2Fwechat.appvworks.com%%2FoAuthServlet%%3FrealURL%%3Dwashclothes/shopdetail.html?id=%ld&tag=1&response_type=code&scope=snsapi_userinfo&state=100#wechat_redirect", (long)shopId];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"全城优质洗衣店8折，商家特惠价";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"全城优质洗衣店8折，商家特惠价";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = str;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = str;
    if (user.shopLogo.length > 0) {
        JXHUDProcessing(nil);
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:user.shopLogo] options:SDWebImageDownloaderHighPriority | SDWebImageDownloaderUseNSURLCache progress:NULL completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            JXHUDHide();
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:kUMAppkey
                                              shareText:@"【爱为家】一键下单，周边洗衣店免费上门收送"
                                             shareImage:image ? image : [UIImage imageNamed:@"myappIcon"]
                                        shareToSnsNames:@[UMShareToWechatSession, UMShareToWechatTimeline]
                                               delegate:self];        }];
    }else {
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:kUMAppkey
                                          shareText:@"【爱为家】一键下单，周边洗衣店免费上门收送"
                                         shareImage:[UIImage imageNamed:@"myappIcon"]
                                    shareToSnsNames:@[UMShareToWechatSession, UMShareToWechatTimeline]
                                           delegate:self];
    }
}

- (void)closeButtonPressed:(UIButton *)sender {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    // @{@"state":@()}.
    NSNumber *state;
    if ([self.once isEqualToString:@"sleep"]) {
        dic = @{@"state": @(1)}.mutableCopy;
        state = @1;
    } else if ([self.once isEqualToString:@"open"]) {
        dic = @{@"state": @(2)}.mutableCopy;
        state = @2;
    }
    
    
    ShowProgressHUD(YES, nil);
    [HttpServiceManageObject sendPostRequestWithPathUrl:@"accountMerchant/modifyShopState" andToken:YES andParameterDic:dic andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:^(AFHTTPRequestOperation *operation, id responsObject) {
        ShowProgressHUD(NO, nil);
        
         if ([state isEqual:@2]) {
            _sleepingState = @"2";
        } else if ([state isEqual:@1]){
            _sleepingState = @"1";
        }
       
        if ([_sleepingState isEqualToString:@"1"]) {
            [self.closeButton setTitle:@"休息店铺" forState:UIControlStateNormal];   // 开张状态
            self.once = @"open";
        } else if ([_sleepingState isEqualToString:@"2"]){
            [self.closeButton setTitle:@"开张店铺" forState:UIControlStateNormal];
            self.once = @"sleep";
            
        }

    } andFailedCallback:^(AFHTTPRequestOperation *operation, NSError *error) {
        ShowProgressHUD(NO, nil);
        ShowWaringAlertHUD(error.localizedDescription, self.view);
    }];
}

- (IBAction)exitButtonPressed:(id)sender {
    [UserTools sharedUserTools].userModel = nil;
    //NSString *stateId = [[NSUserDefaults standardUserDefaults] objectForKey:@"shopId"];

    //[[NSUserDefaults standardUserDefaults] setObject:@3 forKey:AWKS_GET_ShopStatu];
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:stateId];
    [[UserTools sharedUserTools] loginIfNeedWithTarget:self error:nil didFinished:^{
    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
