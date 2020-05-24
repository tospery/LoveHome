//
//  LHCouponCenterViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/2.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHCouponCenterViewController.h"
#import "LHCouponCell.h"

#define LHCouponCenterShopTag           (101)

@interface LHCouponCenterViewController ()
@property (nonatomic, assign) BOOL isHScrolling;
@property (nonatomic, assign) CGRect tableRect;

@property (nonatomic, strong) NSMutableArray *platformCoupons;
@property (nonatomic, strong) NSMutableArray *shopCoupons;
@property (nonatomic, strong) NSMutableArray *signleShopCoupons;

@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UITableView *platformTableView;
@property (nonatomic, weak) IBOutlet UITableView *shopTableView;
@property (nonatomic, weak) IBOutlet UITableView *signleShopTableView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@end

@implementation LHCouponCenterViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [JXLoadViewManager setBackgroundColor:JXColorHex(0xF4F4F4)];
    [self setupView];
    [self setupDB];
    [self setupNet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [JXLoadViewManager setBackgroundColor:JXColorHex(0xF4F4F4)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [JXLoadViewManager setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupView {
    self.navigationItem.title = @"领券中心";
    
    UINib *cellNib = [UINib nibWithNibName:@"LHCouponCell" bundle:nil];
    [self.platformTableView registerNib:cellNib forCellReuseIdentifier:[LHCouponCell identifier]];
    [self.shopTableView registerNib:cellNib forCellReuseIdentifier:[LHCouponCell identifier]];
    [self.signleShopTableView registerNib:cellNib forCellReuseIdentifier:[LHCouponCell identifier]];
    
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:JXColorHex(0x666666),NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    
    self.platformTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestCouponsWithMode:JXWebLaunchModeRefresh];
    }];
    self.shopTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestCouponsWithMode:JXWebLaunchModeRefresh];
    }];
    self.signleShopTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestCouponsWithMode:JXWebLaunchModeRefresh];
    }];
}

- (void)setupDB {
    
}

- (void)setupNet {
    [self requestCouponsWithMode:JXWebLaunchModeHUD];
}

#pragma mark fetch

#pragma mark request
- (void)requestCouponsWithMode:(JXWebLaunchMode)mode {
    switch (mode) {
        case JXWebLaunchModeHUD: {
            JXHUDProcessing(nil);
            [self.operaters exAddObject:
             [LHHTTPClient getSuppliedCouponsWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *coupons) {
                JXHUDHide();
                
                [self.platformCoupons removeAllObjects];
                [self.shopCoupons removeAllObjects];
                [self.signleShopCoupons removeAllObjects];
                
                for (LHCoupon *obj in coupons) {
                    if (LHCouponTypePlatform == obj.kind) {
                        [self.platformCoupons addObject:obj];
                    }else if (LHCouponTypeShop == obj.kind) {
                        [self.shopCoupons addObject:obj];
                    }else if (LHCouponTypeChannel == obj.kind) {
                        [self.signleShopCoupons addObject:obj];
                    }else {
                        JXLogError(@"未处理的优惠券类型");
                    }
                }
                
                if (self.platformCoupons.count == 0) {
                    [JXLoadView showResultAddedTo:self.platformTableView rect:self.tableRect image:[UIImage imageNamed:@"ic_coupon_empty"] message:@"敬请期待" functitle:nil callback:NULL];
                }else {
                    [JXLoadView hideForView:self.platformTableView];
                }
                
                if (self.shopCoupons.count == 0) {
                    [JXLoadView showResultAddedTo:self.shopTableView rect:self.tableRect image:[UIImage imageNamed:@"ic_coupon_empty"] message:@"敬请期待" functitle:nil callback:NULL];
                }else {
                    [JXLoadView hideForView:self.shopTableView];
                }
                
                if (self.signleShopCoupons.count == 0) {
                    [JXLoadView showResultAddedTo:self.signleShopTableView rect:self.tableRect image:[UIImage imageNamed:@"ic_coupon_empty"] message:@"敬请期待" functitle:nil callback:NULL];
                }else {
                    [JXLoadView hideForView:self.signleShopTableView];
                }
                
                
                [self.platformTableView reloadData];
                [self.shopTableView reloadData];
                [self.signleShopTableView reloadData];
                
                [self.platformTableView setScrollEnabled:YES];
                [self.shopTableView setScrollEnabled:YES];
                [self.signleShopTableView setScrollEnabled:YES];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
                    [self requestCouponsWithMode:mode];
                }];
            }]];
            break;
        }
        case JXWebLaunchModeRefresh: {
            [self.operaters exAddObject:
             [LHHTTPClient getSuppliedCouponsWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *coupons) {
                [self.platformCoupons removeAllObjects];
                [self.shopCoupons removeAllObjects];
                [self.signleShopCoupons removeAllObjects];
                
                for (LHCoupon *obj in coupons) {
                    if (LHCouponTypePlatform == obj.kind) {
                        [self.platformCoupons addObject:obj];
                    }else if (LHCouponTypeShop == obj.kind) {
                        [self.shopCoupons addObject:obj];
                    }else if (LHCouponTypeChannel == obj.kind) {
                        [self.signleShopCoupons addObject:obj];
                    }else {
                        JXLogError(@"未处理的优惠券类型");
                    }
                }
                
                if (self.platformCoupons.count == 0) {
                    [JXLoadView showResultAddedTo:self.platformTableView rect:self.tableRect image:[UIImage imageNamed:@"ic_coupon_empty"] message:@"敬请期待" functitle:nil callback:NULL];
                }else {
                    [JXLoadView hideForView:self.platformTableView];
                }
                
                if (self.shopCoupons.count == 0) {
                    [JXLoadView showResultAddedTo:self.shopTableView rect:self.tableRect image:[UIImage imageNamed:@"ic_coupon_empty"] message:@"敬请期待" functitle:nil callback:NULL];
                }else {
                    [JXLoadView hideForView:self.shopTableView];
                }
                
                if (self.signleShopCoupons.count == 0) {
                    [JXLoadView showResultAddedTo:self.signleShopTableView rect:self.tableRect image:[UIImage imageNamed:@"ic_coupon_empty"] message:@"敬请期待" functitle:nil callback:NULL];
                }else {
                    [JXLoadView hideForView:self.signleShopTableView];
                }
                
                [self.platformTableView reloadData];
                [self.shopTableView reloadData];
                [self.signleShopTableView reloadData];
                
                [self.platformTableView.header endRefreshing];
                [self.shopTableView.header endRefreshing];
                [self.signleShopTableView.header endRefreshing];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
                    [self requestCouponsWithMode:mode];
                }];
                
                [self.platformTableView.header endRefreshing];
                [self.shopTableView.header endRefreshing];
                [self.signleShopTableView.header endRefreshing];
            }]];
            break;
        }
        default:
            break;
    }
}

- (void)requestReceiveWithMode:(JXWebLaunchMode)mode coupon:(LHCoupon *)coupon {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient receiveCounponWithCounponid:coupon.couponId success:^(AFHTTPRequestOperation *operation, NSNumber *response) {
        [self.platformCoupons removeObject:coupon];
        [self.platformTableView reloadData];
        
        [self.shopCoupons removeObject:coupon];
        [self.shopTableView reloadData];
        
        [self.signleShopCoupons removeObject:coupon];
        [self.signleShopTableView reloadData];
        
        coupon.status = LHCouponStatusNormal;
        LHCoupon *c = [[LHCoupon alloc] init];
        c.accountId = coupon.accountId;
        c.couponId = coupon.couponId;
        c.couponScope = coupon.couponScope;
        c.shopId = coupon.shopId;
        c.couponType = coupon.couponType;
        c.effectiveDate = coupon.effectiveDate;
        c.expiryDate = coupon.expiryDate;
        c.status = coupon.status;
        c.price = coupon.price;
        c.fullPrice = coupon.fullPrice;
        c.useScope = coupon.useScope;
        c.kind = coupon.kind;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCouponReceived object:coupon];
        JXHUDHide();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestReceiveWithMode:mode coupon:coupon];
        }];
    }]];
}

#pragma mark assist

#pragma mark - Accessor methods
- (NSMutableArray *)platformCoupons {
    if (!_platformCoupons) {
        _platformCoupons = [NSMutableArray array];
    }
    return _platformCoupons;
}

- (NSMutableArray *)shopCoupons {
    if (!_shopCoupons) {
        _shopCoupons = [NSMutableArray array];
    }
    return _shopCoupons;
}

- (NSMutableArray *)signleShopCoupons {
    if (!_signleShopCoupons) {
        _signleShopCoupons = [NSMutableArray array];
    }
    return _signleShopCoupons;
}

- (CGRect)tableRect {
    if (CGRectEqualToRect(_tableRect, CGRectZero)) {
        _tableRect = CGRectMake(0, 0, kJXScreenWidth, kJXScreenHeight - 64 - 50);
    }
    return _tableRect;
}

#pragma mark - Action methods
- (IBAction)segmentedControlChanged:(UISegmentedControl *)seg {
    [self.scrollView scrollRectToVisible:CGRectMake(seg.selectedSegmentIndex * kJXScreenWidth, 0, kJXScreenWidth, self.tableRect.size.height) animated:YES];
}


#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (LHCouponCenterShopTag + 1 == tableView.tag) {
        return self.signleShopCoupons.count;
    }else if(LHCouponCenterShopTag == tableView.tag) {
        return self.shopCoupons.count;
    }else {
        return self.platformCoupons.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LHCouponCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHCouponCell identifier]];
    if (LHCouponCenterShopTag + 1 == tableView.tag) {   // 单店
        [(LHCouponCell *)cell setCoupon:self.signleShopCoupons[indexPath.row]];
        [(LHCouponCell *)cell setCallback:^{
            [self requestReceiveWithMode:JXWebLaunchModeHUD coupon:self.signleShopCoupons[indexPath.row]];
        }];
    }else if (LHCouponCenterShopTag == tableView.tag) { // 多店
        [(LHCouponCell *)cell setCoupon:self.shopCoupons[indexPath.row]];
        [(LHCouponCell *)cell setCallback:^{
            [self requestReceiveWithMode:JXWebLaunchModeHUD coupon:self.shopCoupons[indexPath.row]];
        }];
    }else {
        [(LHCouponCell *)cell setCoupon:self.platformCoupons[indexPath.row]];
        [(LHCouponCell *)cell setCallback:^{
            [self requestReceiveWithMode:JXWebLaunchModeHUD coupon:self.platformCoupons[indexPath.row]];
        }];
    }
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x != 0 && scrollView.contentOffset.y == 0) {
        self.isHScrolling = YES;
    }else {
        self.isHScrolling = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!self.isHScrolling) {
        return;
    }
    
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.scrollView scrollRectToVisible:CGRectMake(page * kJXScreenWidth, 0, kJXScreenWidth, self.tableRect.size.height) animated:YES];
    [self.segmentedControl setSelectedSegmentIndex:page];
}

#pragma mark - Public methods
#pragma mark - Class methods
@end
