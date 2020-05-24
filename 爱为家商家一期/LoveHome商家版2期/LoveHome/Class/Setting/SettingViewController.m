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
@interface SettingViewController ()
@property (nonatomic, weak) IBOutlet UILabel *versionLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;

@property (nonatomic, weak) IBOutlet CustomButton *closeButton;
@property (nonatomic, weak) IBOutlet CornerRadiusButton *exitButton;
@end

@implementation SettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initVar];
    [self initView];
    [self initDB];
    [self initNet];
    [self checkoutNotifacationCount];
}

- (void)initVar {
}

- (void)initView {
    self.navigationItem.title = @"设置";
    self.versionLabel.text = [NSString stringWithFormat:@"当前版本 %@", [JXApp version]];
    
    [self.countLabel exCircleWithColor:[UIColor clearColor] border:0];
    self.closeButton.layer.cornerRadius = 4;
    self.closeButton.clipsToBounds = YES;
    self.exitButton.clipsToBounds = YES;
    [self.closeButton setTitle:@"休息店铺" forState:UIControlStateNormal];   // 开张状态
    [self.closeButton setTitle:@"开张店铺" forState:UIControlStateSelected];  // 关店状态
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
    
    NSNumber *state = [[NSUserDefaults standardUserDefaults] objectForKey:AWKS_GET_ShopStatu];
    _closeButton.selected = [state isEqualToNumber:@6];

}

- (void)initDB {
}

- (void)initNet {
}

- (void)checkoutNotifacationCount
{
    [HttpServiceManageObject sendPostRequestWithPathUrl:@"general/getOrderMsgUnreadTotal" andToken:YES andParameterDic:nil andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:^(AFHTTPRequestOperation *operation, id responsObject) {
        
        //NSLog(@"123");
        if ([responsObject integerValue] < 1) {
            _countLabel.hidden = YES;
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

- (void)closeButtonPressed:(UIButton *)sender {

    
    NSInteger status = 0;
    if (_closeButton.selected) {
        
        status = 6;
    }
    else
    {
        status = 5;
    }
    
    NSDictionary *dic = @{@"state":@(status)};

    
    ShowProgressHUD(YES, nil);
    [HttpServiceManageObject sendPostRequestWithPathUrl:@"accountMerchant/modifyShopState" andToken:YES andParameterDic:dic andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:^(AFHTTPRequestOperation *operation, id responsObject) {
        ShowProgressHUD(NO, nil);
        _closeButton.selected = !_closeButton.selected;
        
        NSNumber *state = _closeButton.selected ? @6 :@5;
        
        [[NSUserDefaults standardUserDefaults] setObject:state forKey:AWKS_GET_ShopStatu];
        [[NSUserDefaults standardUserDefaults] synchronize];

        
        
                
    } andFailedCallback:^(AFHTTPRequestOperation *operation, NSError *error) {
        ShowProgressHUD(NO, nil);
        ShowWaringAlertHUD(error.localizedDescription, self.view);
    }];
    
    
    
}

- (IBAction)exitButtonPressed:(id)sender {
    [UserTools sharedUserTools].userModel = nil;
    [[NSUserDefaults standardUserDefaults] setObject:@3 forKey:AWKS_GET_ShopStatu];
    [[UserTools sharedUserTools] loginIfNeedWithTarget:self error:nil didFinished:^{
    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
