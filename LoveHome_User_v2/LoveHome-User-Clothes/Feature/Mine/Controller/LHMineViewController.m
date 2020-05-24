//
//  LHMineViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/24.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHMineViewController.h"
#import "LHMineHeaderView.h"
#import "LHMineOrderCell.h"
#import "LHMineWalletCell.h"
#import "LHMineCommonCell.h"
#import "LHProfileViewController.h"
#import "LHSettingViewController.h"
#import "LHPhoneVerifyViewController.h"
#import "LHFavoriteViewController.h"
#import "LHBalanceViewController.h"
#import "LHLovebeanViewController.h"
#import "LHBalanceViewController.h"
#import "LHCouponMineViewController.h"
#import "LHOrderMineViewController.h"
#import "LHMessageViewController.h"


@interface LHMineViewController ()
@property (nonatomic, strong) NSArray *items;
@property (strong, nonatomic) LHMineHeaderView *headView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation LHMineViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    if (!JXiOSVersionGreaterThanOrEqual(8.0)) {
//        [self.tabBarController.tabBar setHidden:NO];
//    }
    
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self configProfile];
    [self requestProfile:JXWebLaunchModeSilent];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

#pragma mark - Private methods
- (void)initView {
    UINib *cellNib = [UINib nibWithNibName:@"LHMineOrderCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:[LHMineOrderCell identifier]];
    cellNib = [UINib nibWithNibName:@"LHMineWalletCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:[LHMineWalletCell identifier]];
    cellNib = [UINib nibWithNibName:@"LHMineCommonCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:[LHMineCommonCell identifier]];
    
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"LHMineHeaderView" owner:nil options:nil] lastObject];
    self.tableView.tableHeaderView = self.headView;
    
    [self.headView setupSettingPressed:^{
        [self showLoginIfNotLoginedWithFinish:^(){
            LHSettingViewController *settingVC = [[LHSettingViewController alloc] init];
            settingVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:settingVC animated:YES];
        }];
    } profilePressed:^{
        [self showLoginIfNotLoginedWithFinish:NULL pass:^{
            LHProfileViewController *profileVC = [[LHProfileViewController alloc] init];
            profileVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:profileVC animated:YES];
        }];
    } favoritePressed:^{
        [self showLoginIfNotLoginedWithFinish:^(){
            LHFavoriteViewController *vc = [[LHFavoriteViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }];
}

- (void)requestProfile:(JXWebLaunchMode)mode {
    if (!gLH.logined) {
        return;
    }
    
    [LHHTTPClient getUserinfoWithSuccess:^(AFHTTPRequestOperation *operation, LHUserInfo *userinfo) {
        gLH.user.info = userinfo;
        [self configProfile];
        [self.tableView reloadData];
    } failure:NULL retryTimes:0];
}

- (void)configProfile {
    if (!gLH.user) {
        [self.headView.avatarButton setBackgroundImage:[UIImage imageNamed:@"ic_placeholder_avatar"] forState:UIControlStateNormal];
        self.headView.nameLabel.text = nil;
        self.headView.mobileLabel.text = nil;
        self.headView.areaLabel.text = nil;
        self.headView.addressLabel.text = nil;
        self.headView.favoriteLabel.text = @"关注店铺：";
        [self.headView.loginLabel setHidden:NO];
        
        [_tableView reloadData];
        return;
    }
    
    [self.headView.avatarButton sd_setBackgroundImageWithURL:[NSURL URLWithString:gLH.user.info.icon] forState:UIControlStateNormal placeholderImage:kImagePHUserAvatar];
    self.headView.nameLabel.text = gLH.user.info.nickName;
    self.headView.mobileLabel.text = gLH.user.info.phoneNumber;
    self.headView.areaLabel.text = gLH.user.info.provincialCity;
    self.headView.addressLabel.text = gLH.user.info.receiptAddr;
    self.headView.favoriteLabel.text = [NSString stringWithFormat:@"关注店铺：%@", @(gLH.user.info.shopCount)];
    [self.headView.loginLabel setHidden:YES];
}

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        return [LHMineOrderCell height];
    }else if (1 == indexPath.row) {
        return [LHMineWalletCell height];
    }else if (2 == indexPath.row || 3 == indexPath.row) {
        return [LHMineCommonCell height];
    }else {
        return 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHMineOrderCell identifier]];
        if (0 == gLH.user.info.orderToPayCount) {
            [[(LHMineOrderCell *)cell waitingToPayCountLabel] setHidden:YES];
        }else {
            [[(LHMineOrderCell *)cell waitingToPayCountLabel] setHidden:NO];
            NSInteger maxCount = gLH.user.info.orderToPayCount >= 99 ? 99 : gLH.user.info.orderToPayCount;
            [(LHMineOrderCell *)cell waitingToPayCountLabel].text = [NSString stringWithFormat:@"%@", @(maxCount)];
        }
        
        if (0 == gLH.user.info.orderToAcceptCount) {
            [[(LHMineOrderCell *)cell waitingToHandleCountLabel] setHidden:YES];
        }else {
            [[(LHMineOrderCell *)cell waitingToHandleCountLabel] setHidden:NO];
            NSInteger maxCount = gLH.user.info.orderToAcceptCount >= 99 ? 99 : gLH.user.info.orderToAcceptCount;
            [(LHMineOrderCell *)cell waitingToHandleCountLabel].text = [NSString stringWithFormat:@"%@", @(maxCount)];
        }
        
        if (0 == gLH.user.info.orderAcceptedCount) {
            [[(LHMineOrderCell *)cell collectingCountLabel] setHidden:YES];
        }else {
            [[(LHMineOrderCell *)cell collectingCountLabel] setHidden:NO];
            NSInteger maxCount = gLH.user.info.orderAcceptedCount >= 99 ? 99 : gLH.user.info.orderAcceptedCount;
            [(LHMineOrderCell *)cell collectingCountLabel].text = [NSString stringWithFormat:@"%@", @(maxCount)];
        }
        
        if (0 == gLH.user.info.orderFinishCount) {
            [[(LHMineOrderCell *)cell tradingCountLabel] setHidden:YES];
        }else {
            [[(LHMineOrderCell *)cell tradingCountLabel] setHidden:NO];
            NSInteger maxCount = gLH.user.info.orderFinishCount >= 99 ? 99 : gLH.user.info.orderFinishCount;
            [(LHMineOrderCell *)cell tradingCountLabel].text = [NSString stringWithFormat:@"%@", @(maxCount)];
        }
        
        [(LHMineOrderCell *)cell setupPressedBlock:^(NSUInteger index) {
            [self showLoginIfNotLoginedWithFinish:^(){
                LHOrderMineViewController *vc = [[LHOrderMineViewController alloc] init];
                vc.type = (index + 1);
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }];
        return cell;
    }else if (1 == indexPath.row) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHMineWalletCell identifier]];
        [(LHMineWalletCell *)cell balanceLabel].text = [NSString stringWithFormat:@"%.2f", gLH.user.info.accountBalance];
        [(LHMineWalletCell *)cell couponLabel].text = [NSString stringWithFormat:@"%@", @(gLH.user.info.saleRoll)];
        [(LHMineWalletCell *)cell pointsLabel].text = [NSString stringWithFormat:@"%@", @(gLH.user.info.loveBean)];
        [(LHMineWalletCell *)cell setupPressedBlock:^(NSUInteger index) {
            if (0 == index) {
                [self showLoginIfNotLoginedWithFinish:^{
                    LHBalanceViewController *vc = [[LHBalanceViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            }else if (1 == index) {
                [self showLoginIfNotLoginedWithFinish:^(){
                    LHCouponMineViewController *vc = [[LHCouponMineViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            }else {
                [self showLoginIfNotLoginedWithFinish:^(){
                    LHLovebeanViewController *lovebeanVC = [[LHLovebeanViewController alloc] init];
                    lovebeanVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:lovebeanVC animated:YES];
                }];
            }
        }];
        return cell;
    }else if (2 == indexPath.row) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHMineCommonCell identifier]];
        [(LHMineCommonCell *)cell myNameLabel].text = @"消息中心";
        [(LHMineCommonCell *)cell myIconLabel].image = [UIImage imageNamed:@"mine_imCenter"];
        return cell;
    }else if (3 == indexPath.row) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHMineCommonCell identifier]];
        if (gLH.user.info.isSetWalletPwdState == 1) {
            [(LHMineCommonCell *)cell myNameLabel].text = @"修改支付密码";
        }else {
            [(LHMineCommonCell *)cell myNameLabel].text = @"设置支付密码";
        }
        [(LHMineCommonCell *)cell myIconLabel].image = [UIImage imageNamed:@"mine_accountSafety"];
        return cell;
    }else {
        return nil;
    }
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (2 == indexPath.row) {
        [self showLoginIfNotLoginedWithFinish:^(){
            LHMessageViewController *vc = [[LHMessageViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }else if (3 == indexPath.row) {
        [self showLoginIfNotLoginedWithFinish:^(){
            static LHPhoneVerifyViewController *paywordVC;
            if (!paywordVC) {
                paywordVC = [[LHPhoneVerifyViewController alloc] initWithMode:LHAccountModeVerifySetPayword];
            }
            paywordVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:paywordVC animated:YES];
        }];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.headView.offsetY = scrollView.contentOffset.y;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _headView.touching = NO;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(decelerate == NO) {
        _headView.touching = NO;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _headView.touching = YES;
}
@end






