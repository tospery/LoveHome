//
//  LHCouponMineViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/2.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHCouponMineViewController.h"
#import "LHCouponCell.h"
#import "LHCouponCenterViewController.h"
#import "LHShopListViewController.h"

@interface LHCouponMineViewController ()
@property (nonatomic, strong) LHCoupon *coupon;
@property (nonatomic, strong) NSMutableArray *coupons;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) CGRect tableRect;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation LHCouponMineViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupDB];
    [self setupNet];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupView {
    if (_canSelected) {
        self.navigationItem.title = @"选择优惠券";
    }else {
        self.navigationItem.title = @"我的优惠券";
    }
    
    if (self.canSelected) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"不使用" style:UIBarButtonItemStylePlain target:self action:@selector(nouseItemPressed:)];
    }else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"领券" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed:)];
    }
    
    UINib *cellNib = [UINib nibWithNibName:@"LHCouponCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:[LHCouponCell identifier]];
    
    if (_canSelected) {
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestCouponsForShopWithMode:JXWebLaunchModeRefresh];
        }];
    }else {
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestCouponsWithMode:JXWebLaunchModeRefresh];
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyCouponReceived:) name:kNotifyCouponReceived object:nil];
}

- (void)notifyCouponReceived:(NSNotification *)notification {
    LHCoupon *c = notification.object;
    [self.coupons addObject:c];
    [self.tableView reloadData];
}

- (void)setupDB {
}

- (void)setupNet {
    if (_canSelected) {
        [self requestCouponsForShopWithMode:JXWebLaunchModeLoad];
    }else {
        [self requestCouponsWithMode:JXWebLaunchModeLoad];
    }
}

#pragma mark request
- (void)requestCouponsForShopWithMode:(JXWebLaunchMode)mode {
    switch (mode) {
        case JXWebLaunchModeLoad:
        case JXWebLaunchModeRefresh: {
            if (self.shopParams.count == 0) {
                return;
            }
            
            if (mode == JXWebLaunchModeLoad) {
                [JXLoadView showProcessingAddedTo:self.tableView rect:self.tableRect];
            }
            
            [self.operaters exAddObject:
             [LHHTTPClient requestGetCouponsWithShopids:self.shopParams success:^(AFHTTPRequestOperation *operation, NSArray *coupons) {
                [self handleSuccessForTableView:self.tableView tableRect:self.tableRect mode:mode items:self.coupons page:nil results:coupons current:0 total:0 image:[UIImage imageNamed:@"ic_coupon_empty"] message:kStringNoMyCoupons functitle:nil callback:NULL];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (mode == JXWebLaunchModeLoad) {
                    [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                        [self requestCouponsForShopWithMode:mode];
                    }];
                }else if (mode == JXWebLaunchModeRefresh) {
                    [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                        [self.tableView.header beginRefreshing];
                    }];
                }
            }]];
            break;
        }
        default:
            break;
    }
}

- (void)requestCouponsWithMode:(JXWebLaunchMode)mode {
    switch (mode) {
        case JXWebLaunchModeLoad:
        case JXWebLaunchModeRefresh: {
            if (mode == JXWebLaunchModeLoad) {
                [JXLoadView showProcessingAddedTo:self.tableView rect:self.tableRect];
            }
            [self.operaters exAddObject:
             [LHHTTPClient getMyCouponsWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *coupons) {
                [self handleSuccessForTableView:self.tableView tableRect:self.tableRect mode:mode items:self.coupons page:nil results:coupons current:0 total:0 image:[UIImage imageNamed:@"ic_coupon_empty"] message:kStringNoMyCoupons functitle:@"去领券" callback:^{
                    [self.navigationController pushViewController:[[LHCouponCenterViewController alloc] init] animated:YES];
                }];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (mode == JXWebLaunchModeLoad) {
                    [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                        [self requestCouponsWithMode:mode];
                    }];
                }else if (mode == JXWebLaunchModeRefresh) {
                    [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                        [self.tableView.header beginRefreshing];
                    }];
                }
            }]];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Accessor methods
- (NSMutableArray *)coupons {
    if (!_coupons) {
        _coupons = [NSMutableArray array];
    }
    return _coupons;
}

- (CGRect)tableRect {
    if (CGRectEqualToRect(_tableRect, CGRectZero)) {
        _tableRect = CGRectMake(0, 0, kJXScreenWidth, kJXScreenHeight - 64);
    }
    return _tableRect;
}

#pragma mark - Action methods
- (void)rightItemPressed:(id)sender {
    [self.navigationController pushViewController:[[LHCouponCenterViewController alloc] init] animated:YES];
}

- (void)nouseItemPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCouponSelected object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.coupons.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LHCouponCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHCouponCell identifier]];
    if (self.canSelected) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [(LHCouponCell *)cell setCoupon:self.coupons[indexPath.row]];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.canSelected) {
        _coupon = self.coupons[indexPath.row];
        if (LHCouponStatusUsed == _coupon.status ||
            LHCouponStatusExpired == _coupon.status) {
            return;
        }
        
        LHShopListViewController *listVC = [[LHShopListViewController alloc] init];
        listVC.from = LHEntryFromCoupon;
        listVC.shopsForCoupon = self.coupon.shopId;
        [self.navigationController pushViewController:listVC animated:YES];
        
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _coupon = self.coupons[indexPath.row];
    if (_coupon.fullPrice == 0) {
        if (_coupon.price > self.actualPrice) {
            //JXToast(@"已超出实付金额，请重新选择");
            JXAlertParams(kStringTips, @"所选优惠券金额已超出实付金额，是否确认使用？", @"取消", @"确认使用");
            return;
        }
    }else {
        if (_coupon.fullPrice > self.totalPrice) {
            JXToast(_coupon.couponType);
            return;
        }
        else {
            if (_coupon.price > self.actualPrice) {
                //JXToast(@"已超出实付金额，请重新选择");
                JXAlertParams(kStringTips, @"所选优惠券金额已超出实付金额，是否确认使用？", @"取消", @"确认使用");
                return;
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCouponSelected object:_coupon];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCouponSelected object:_coupon];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end




