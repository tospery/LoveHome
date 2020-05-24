//
//  LHPaySuccessViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/7.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHOperationSuccessViewController.h"
#import "LHOrderMineViewController.h"
#import "LHCommentViewController.h"

@interface LHOperationSuccessViewController ()
@property (nonatomic, weak) IBOutlet UILabel *tipsLabel;
@property (nonatomic, weak) IBOutlet UIButton *leftButton;
@property (nonatomic, weak) IBOutlet UIButton *rightButton;
@property (nonatomic, weak) IBOutlet UILabel *shareForLovebeanLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *offsetConstraint;
@end

@implementation LHOperationSuccessViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupDB];
    [self setupNet];
}


#pragma mark - Private methods
#pragma mark setup
- (void)setupView {
    self.navigationItem.leftBarButtonItem = CreateBackBarItem(self);
    
    if (LHOperationSuccessTypePay == self.type) {
        self.navigationItem.title = @"支付成功";
        self.tipsLabel.text = @"订单支付成功！";
        [self.leftButton setTitle:@"查看订单" forState:UIControlStateNormal];
        [self.rightButton setTitle:@"继续购物" forState:UIControlStateNormal];
    }else if (LHOperationSuccessTypeReceive == self.type) {
        self.navigationItem.title = @"收货成功";
        self.tipsLabel.text = @"您已成功收货！";
        [self.leftButton setTitle:@"继续购物" forState:UIControlStateNormal];
        [self.rightButton setTitle:@"去评价" forState:UIControlStateNormal];
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem exBarItemWithImage:[UIImage imageNamed:@"ic_share_gray"] size:CGSizeMake(20, 20) target:self action:@selector(shareItemPressed:)];
        [_shareForLovebeanLabel setHidden:NO];
        _offsetConstraint.constant = 8;
    }else if (LHOperationSuccessTypeSubmit == self.type) {
        self.navigationItem.title = @"提交成功";
        self.tipsLabel.text = @"订单提交成功！";
        [self.leftButton setTitle:@"查看订单" forState:UIControlStateNormal];
        [self.rightButton setTitle:@"继续购物" forState:UIControlStateNormal];
    }else {
        
    }
    
    [self.leftButton setBackgroundImage:[UIImage exImageWithColor:JXColorHex(0xF4F4F4)] forState:UIControlStateHighlighted];
    [self.leftButton exSetBorder:JXColorHex(0x666666) width:1.0 radius:4.0];
    ConfigButtonStyle(self.rightButton);
}

- (void)setupDB {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
#pragma mark assist

#pragma mark - Accessor methods
#pragma mark - Action methods
- (void)shareItemPressed:(id)sender {
    NSString *str = [NSString stringWithFormat:@"https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx9f0d2574e4dfa412&redirect_uri=http%%3A%%2F%%2Fwechat.appvworks.com%%2FoAuthServlet%%3FrealURL%%3Dwashclothes/shopdetail.html?id=%@&tag=1&response_type=code&scope=snsapi_userinfo&state=100#wechat_redirect", _order.shopId];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"爱为家洗衣太棒了！猛戳就可以免费洗衣啦";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"爱为家洗衣太棒了！猛戳就可以免费洗衣啦";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = str;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = str;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:kUMAppkey
                                      shareText:@"【爱为家】无需办卡即可享受会员价，更多优惠活动等你来"
                                     shareImage:kImageAppIcon
                                shareToSnsNames:@[UMShareToWechatSession, UMShareToWechatTimeline]
                                       delegate:self];
}

- (void)leftBarItemPressed:(id)sender {
    if (self.from == LHEntryFromNone/*LHEntryFromCart*/) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        if (LHEntryFromFavorite == _from) {
            if (JXiOSVersionGreaterThanOrEqual(8.0)) {
                LHOrderMineViewController *vc = [[LHOrderMineViewController alloc] init];
                vc.type = LHOrderRequestTypeHandle;
                vc.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                [(LHNavigationController *)[AppDelegate appDelegate].tabBarController.selectedViewController pushViewController:vc animated:YES];
            }else {
                LHOrderMineViewController *vc = [[LHOrderMineViewController alloc] init];
                vc.type = LHOrderRequestTypeHandle;
                vc.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController popToRootViewControllerAnimated:NO];
                UINavigationController *nav = (LHNavigationController *)[AppDelegate appDelegate].tabBarController.selectedViewController;
                [nav pushViewController:vc animated:YES];
            }
        }else {
            NSMutableArray *childs = [NSMutableArray array];
            [childs addObject:[self.navigationController.childViewControllers objectAtIndex:0]];
            [childs addObject:[self.navigationController.childViewControllers objectAtIndex:1]];
            [childs addObject:self];
            [self.navigationController setViewControllers:childs];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)leftButtonPressed:(id)sender {
    if (LHOperationSuccessTypePay == self.type || LHOperationSuccessTypeSubmit == self.type) {
        // 进入我的订单
        if (_from == LHEntryFromNone ||
            (_from >= LHEntryFromHomeClothes && _from <= LHEntryFromHomeOther)) {
            LHOrderMineViewController *vc = [[LHOrderMineViewController alloc] init];
            vc.type = LHOrderRequestTypeHandle;
            vc.hidesBottomBarWhenPushed = YES;
            
            self.tabBarController.selectedIndex = 2;
            [self.navigationController popToRootViewControllerAnimated:NO];
            [(LHNavigationController *)[AppDelegate appDelegate].tabBarController.selectedViewController pushViewController:vc animated:YES];
            
        }else if (_from >= LHEntryFromActivity && _from <= LHEntryFromMap) {
            [self dismissViewControllerAnimated:YES completion:^{
                LHOrderMineViewController *vc = [[LHOrderMineViewController alloc] init];
                vc.type = LHOrderRequestTypeHandle;
                vc.hidesBottomBarWhenPushed = YES;
                
                self.tabBarController.selectedIndex = 2;
                [self.navigationController popToRootViewControllerAnimated:NO];
                [(LHNavigationController *)[AppDelegate appDelegate].tabBarController.selectedViewController pushViewController:vc animated:YES];
            }];
        } else {
            [self leftBarItemPressed:nil];
        }
    }else if (LHOperationSuccessTypeReceive == self.type) {
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }else {
        
    }
}

- (IBAction)rightButtonPressed:(id)sender {
    if (LHOperationSuccessTypePay == self.type || LHOperationSuccessTypeSubmit == self.type) {
        //if (self.fromCart) {
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:NO];
        //}else {
        //[self leftBarItemPressed:nil];
        //}
    }else if (LHOperationSuccessTypeReceive == self.type) {
        LHCommentViewController *vc = [[LHCommentViewController alloc] init];
        vc.order = self.order;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        
    }
}

#pragma mark - Notification methods

#pragma mark UMSocialUIDelegate
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType {
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    if (response.responseCode == UMSResponseCodeSuccess) {
        if (gLH.logined) {
            [self.operaters exAddObject:
             [LHHTTPClient requestGetLovebeanWhenSharedWithTaskid:LHShareTaskOrder success:^(AFHTTPRequestOperation *operation, NSNumber *response) {
                gLH.user.info.loveBean += response.integerValue;
            } failure:NULL]];
        }
    }
}
@end





