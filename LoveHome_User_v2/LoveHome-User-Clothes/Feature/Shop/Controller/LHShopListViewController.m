//
//  LHShopListViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/16.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHShopListViewController.h"
#import "LHShopMapViewController.h"
#import "LHShopDetailViewController.h"
#import "LHShopListCell.h"
#import "LHOrderConfirmViewController.h"
#import "LHFeedbackViewController.h"

@interface LHShopListViewController ()
//@property(assign, nonatomic) CLLocationCoordinate2D coordinate;
//@property (nonatomic, assign) NSInteger myType;
@property (nonatomic, strong) BMKLocationService *locateService;
@property (nonatomic, assign) BOOL requestedMapShops;
@property (nonatomic, assign) CGRect tableRect;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger totalShops;
@property (nonatomic, strong) JXPage *page;
@property (nonatomic, strong) NSMutableArray *shops;
@property (nonatomic, strong) NSArray *mapShops;

@property (nonatomic, strong ) NSArray              *firstDataArry;
@property (nonatomic, strong ) NSArray              *secondDataArry;
@property (nonatomic, strong) NSString               *firstTitle;
@property (nonatomic, strong) NSString               *secondTitle;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation LHShopListViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVar];
    [self setupView];
    [self setupDB];
    [self setupNet];
}

- (void)dealloc {
    if (_locateService) {
        [_locateService stopUserLocationService];
        _locateService = nil;
    }
}

- (BMKLocationService *)locateService {
    if (!_locateService) {
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        _locateService = [[BMKLocationService alloc] init];
        _locateService.delegate = self;
    }
    return _locateService;
}

#pragma mark BMKLocationServiceDelegate
- (void)willStartLocatingUser {
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [self.locateService stopUserLocationService];
    
    //_coordinate = userLocation.location.coordinate;
//    if (1 == _myType) {
//        [self requestShopsWithMode:JXWebLaunchModeLoad];
//    }else {
//        [self requestShopsForActivityWithMode:JXWebLaunchModeLoad];
//    }
}

- (void)didStopLocatingUser {
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    [self.locateService stopUserLocationService];
//    if (1 == _myType) {
//        [self requestShopsWithMode:JXWebLaunchModeLoad];
//    }else {
//        [self requestShopsForActivityWithMode:JXWebLaunchModeLoad];
//    }
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
    self.shops = [NSMutableArray arrayWithCapacity:20];
    _page = [[JXPage alloc] init];
    
    // _firstDataArry = @[@"500米",@"1000米",@"2000米",@"全城"];
    _firstDataArry = @[@"周边店铺", @"全城"]; // @[@"全城", @"2000米", @"1000米", @"500米"];
    _secondDataArry = @[@"离我最近", @"信用优先", @"销量优先"]; // @[@"活动优先",@"信用优先",@"销量优先"];
    _firstTitle = _firstDataArry[0];
    _secondTitle = _secondDataArry[0];
}

- (void)setupView {
    if (self.from == LHEntryFromHomeClothes) {
        self.navigationItem.title = @"快洗";
    }else if (self.from == LHEntryFromHomeShoe) {
        self.navigationItem.title = @"洗鞋";
    }else if (self.from == LHEntryFromHomeLeather) {
        self.navigationItem.title = @"皮具";
    }else if (self.from == LHEntryFromHomeLuxury) {
        self.navigationItem.title = @"奢侈品";
    }else if (self.from == LHEntryFromActivity) {
        self.navigationItem.title = @"选择店铺";
    }else if (self.from == LHEntryFromCoupon) {
        self.navigationItem.title = @"店铺列表";
    }
    
    if (_from >= LHEntryFromHomeClothes && _from <= LHEntryFromHomeLuxury) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem exBarItemWithImage:[UIImage imageNamed:@"nav_map"] size:CGSizeMake(20, 20) target:self action:@selector(mapItemPressed:)];
    }
    
    JCSegmentConditionChildMenu *segementMenu = [[JCSegmentConditionChildMenu alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    segementMenu.delegate                     = self;
    segementMenu.childDelegate                = self;
    segementMenu.targetObject                 = self;
    [self.view addSubview:segementMenu];
    [segementMenu reloadView];
    
    [segementMenu setMenuItemTitle:_firstTitle  atIndex:0];
    [segementMenu setMenuItemTitle:_secondTitle atIndex:1];
    
    UINib *cellNib = [UINib nibWithNibName:@"LHShopListCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:[LHShopListCell identifier]];
    
    
    if (_from >= LHEntryFromHomeClothes && _from <= LHEntryFromHomeLuxury) {
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestShopsWithMode:JXWebLaunchModeRefresh];
        }];
        
        self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self requestShopsWithMode:JXWebLaunchModeMore];
        }];
    }else if (_from == LHEntryFromActivity) {
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestShopsForActivityWithMode:JXWebLaunchModeRefresh];
        }];
        
        self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self requestShopsForActivityWithMode:JXWebLaunchModeMore];
        }];
    }else if (_from == LHEntryFromCoupon) {
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestShopsForCouponWithMode:JXWebLaunchModeRefresh];
        }];
        
        self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self requestShopsForCouponWithMode:JXWebLaunchModeMore];
        }];
    }
}

- (void)setupDB {
}

- (void)setupNet {
    if (_from >= LHEntryFromHomeClothes && _from <= LHEntryFromHomeLuxury) {
        [self requestShopsWithMode:JXWebLaunchModeLoad];
    }else if (_from == LHEntryFromActivity) {
        [self requestShopsForActivityWithMode:JXWebLaunchModeLoad];
    }else if (_from == LHEntryFromCoupon) {
        [self requestShopsForCouponWithMode:JXWebLaunchModeLoad];
    }
    
//    // YJX_TODO 临时测试
//    if (_from >= LHEntryFromHomeClothes && _from <= LHEntryFromHomeLuxury) {
//        _myType = 1;
//    }else if (_from == LHEntryFromActivity) {
//        _myType = 2;
//    }
//    [self requestDataWithMode:JXWebLaunchModeLoad];
}

#pragma mark fetch

#pragma mark request
- (void)requestDataWithMode:(JXWebLaunchMode)mode {
    [JXLoadView showProcessingAddedTo:self.tableView rect:self.tableRect];

//    if (![CLLocationManager locationServicesEnabled]) {
//        if (1 == _myType) {
//            [self requestShopsWithMode:mode];
//        }else {
//            [self requestShopsForActivityWithMode:mode];
//        }
//    }else {
//        [self.locateService startUserLocationService];
//    }
    
//    if (1 == _myType) {
//        [self requestShopsWithMode:JXWebLaunchModeLoad];
//    }else {
//        [self requestShopsForActivityWithMode:JXWebLaunchModeLoad];
//    }
}

- (void)requestShopsForActivityWithMode:(JXWebLaunchMode)mode {
    switch (mode) {
        case JXWebLaunchModeLoad:
        case JXWebLaunchModeRefresh: {
            if (JXWebLaunchModeLoad == mode) {
                [JXLoadView showProcessingAddedTo:self.tableView rect:self.tableRect];
            }
            [self.operaters exAddObject:
             [LHHTTPClient requestGetActivityShopsWithActivityid:_activity.activityid baseProductId:_activity.baseProductId lng:gLH.receipt.longitude lat:gLH.receipt.latitude range:[self getCurDistance] sort:[self getCurSort] page:1 rows:kPageSize success:^(AFHTTPRequestOperation *operation, LHActivityShopList *shopList) {
                if (JXWebLaunchModeRefresh == mode) {
                    [self.tableView.header endRefreshing];
                }
                
                self.curPage = 0;
                self.totalShops = shopList.pageSize;
                
                [self.shops removeAllObjects];
                if (0 == shopList.pageSize || 0 == shopList.shops.count) {
                    [JXLoadView showResultAddedTo:self.tableView rect:self.tableRect image:[UIImage imageNamed:@"ic_shop_empty"] message:kStringNoShopInCurrentLocation functitle:@"添加小区" callback:^{
                        LHFeedbackViewController *vc = [[LHFeedbackViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }];
                    [self.tableView.footer noticeNoMoreData];
                }else {
                    [JXLoadView hideForView:self.tableView];
                    [self.shops exInsertObjects:shopList.shops atIndex:0 unduplicated:YES];
                    
                    if (self.totalShops < shopList.totalRows) {
                        [self.tableView.footer resetNoMoreData];
                    }else {
                        [self.tableView.footer noticeNoMoreData];
                    }
                }
                
                [self.tableView reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestShopsForActivityWithMode:mode];
                }];
            }]];
            break;
        }
        case JXWebLaunchModeMore: {
            [self.operaters exAddObject:
             [LHHTTPClient requestGetActivityShopsWithActivityid:_activity.activityid baseProductId:_activity.baseProductId lng:gLH.receipt.longitude lat:gLH.receipt.latitude range:[self getCurDistance] sort:[self getCurSort] page:(self.curPage + 1) rows:kPageSize success:^(AFHTTPRequestOperation *operation, LHActivityShopList *shopList) {
                [self.tableView.footer endRefreshing];
                if (0 != shopList.pageSize || 0 != shopList.shops.count) {
                    [self.shops exInsertObjects:shopList.shops atIndex:self.shops.count unduplicated:YES];
                    [self.tableView reloadData];
                    
                    self.curPage++;
                    self.totalShops += shopList.pageSize;
                    if (self.totalShops < shopList.totalRows) {
                        [self.tableView.footer resetNoMoreData];
                    }else {
                        [self.tableView.footer noticeNoMoreData];
                    }
                }else {
                    [self.tableView.footer noticeNoMoreData];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestShopsForActivityWithMode:mode];
                }];
            }]];
            break;
        }
        default:
            break;
    }
}

- (void)requestMapShopsWithMode:(JXWebLaunchMode)mode {
    self.requestedMapShops = YES;
    JXHUDProcessing(nil);
    
    [LHHTTPClient queryShopsWithLatitude:gLH.receipt.latitude longitude:gLH.receipt.longitude type:self.from distance:100000.0 sort:[self getCurSort] index:1 size:10000 success:^(AFHTTPRequestOperation *operation, LHShopList *shopList) {
        self.mapShops = shopList.shops;
        JXHUDHide();
        LHShopMapViewController *mapVC = [[LHShopMapViewController alloc] initWithShops:self.mapShops];
        LHNavigationController *mapNav = [[LHNavigationController alloc] initWithRootViewController:mapVC];
        [self.navigationController presentViewController:mapNav animated:YES completion:NULL];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        JXHUDHide();
        LHShopMapViewController *mapVC = [[LHShopMapViewController alloc] initWithShops:self.mapShops];
        LHNavigationController *mapNav = [[LHNavigationController alloc] initWithRootViewController:mapVC];
        [self.navigationController presentViewController:mapNav animated:YES completion:NULL];
    }];
}

- (void)requestShopsWithMode:(JXWebLaunchMode)mode {
    switch (mode) {
        case JXWebLaunchModeLoad: {
            [JXLoadView showProcessingAddedTo:self.tableView rect:self.tableRect];
            [self.tableView.footer resetNoMoreData];
            [self.operaters exAddObject:
             [LHHTTPClient queryShopsWithLatitude:gLH.receipt.latitude longitude:gLH.receipt.longitude type:self.from distance:[self getCurDistance] sort:[self getCurSort] index:1 size:_page.pageSize success:^(AFHTTPRequestOperation *operation, LHShopList *shopList) {
                [self handleSuccessForTableView:self.tableView tableRect:self.tableRect mode:mode items:self.shops page:_page results:shopList.shops current:shopList.currentPage total:shopList.totalRows image:[UIImage imageNamed:@"ic_shop_empty"] message:kStringNoShopInCurrentLocation functitle:@"添加小区" callback:^{
                    LHFeedbackViewController *vc = [[LHFeedbackViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestShopsWithMode:mode];
                }];
            }]];
            break;
        }
        case JXWebLaunchModeRefresh: {
            [self.tableView.footer resetNoMoreData];
            [self.operaters exAddObject:
             [LHHTTPClient queryShopsWithLatitude:gLH.receipt.latitude longitude:gLH.receipt.longitude type:self.from distance:[self getCurDistance] sort:[self getCurSort] index:1 size:_page.pageSize success:^(AFHTTPRequestOperation *operation, LHShopList *shopList) {
                [self handleSuccessForTableView:self.tableView tableRect:self.tableRect mode:mode items:self.shops page:_page results:shopList.shops current:shopList.currentPage total:shopList.totalRows image:[UIImage imageNamed:@"ic_shop_empty"] message:kStringNoShopInCurrentLocation functitle:@"添加小区" callback:^{
                    LHFeedbackViewController *vc = [[LHFeedbackViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestShopsWithMode:mode];
                }];
            }]];
            break;
        }
        case JXWebLaunchModeMore: {
            [self.operaters exAddObject:
             [LHHTTPClient queryShopsWithLatitude:gLH.receipt.latitude longitude:gLH.receipt.longitude type:self.from distance:[self getCurDistance] sort:[self getCurSort] index:(self.page.currentPage + 1) size:self.page.pageSize success:^(AFHTTPRequestOperation *operation, LHShopList *shopList) {
                [self handleSuccessForTableView:self.tableView tableRect:self.tableRect mode:mode items:self.shops page:self.page results:shopList.shops current:shopList.currentPage total:shopList.totalRows image:nil message:@"没有更多店铺" functitle:nil callback:NULL];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestShopsWithMode:mode];
                }];
            }]];
            break;
        }
        default:
            break;
    }
}

- (void)requestShopsForCouponWithMode:(JXWebLaunchMode)mode {
    switch (mode) {
        case JXWebLaunchModeLoad: {
            [JXLoadView showProcessingAddedTo:self.tableView rect:self.tableRect];
            [self.operaters exAddObject:
             [LHHTTPClient queryShopsWithLatitude:gLH.receipt.latitude longitude:gLH.receipt.longitude type:self.from distance:[self getCurDistance] sort:[self getCurSort] index:1 size:_page.pageSize shops:self.shopsForCoupon success:^(AFHTTPRequestOperation *operation, LHShopList *shopList) {
                [self handleSuccessForTableView:self.tableView tableRect:self.tableRect mode:mode items:self.shops page:_page results:shopList.shops current:shopList.currentPage total:shopList.totalRows image:[UIImage imageNamed:@"ic_shop_empty"] message:kStringNoShopInCurrentLocation functitle:@"添加小区" callback:^{
                    LHFeedbackViewController *vc = [[LHFeedbackViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestShopsForCouponWithMode:mode];
                }];
            }]];
            break;
        }
        case JXWebLaunchModeRefresh: {
            [self.operaters exAddObject:
             [LHHTTPClient queryShopsWithLatitude:gLH.receipt.latitude longitude:gLH.receipt.longitude type:self.from distance:[self getCurDistance] sort:[self getCurSort] index:1 size:_page.pageSize shops:self.shopsForCoupon success:^(AFHTTPRequestOperation *operation, LHShopList *shopList) {
                [self handleSuccessForTableView:self.tableView tableRect:self.tableRect mode:mode items:self.shops page:_page results:shopList.shops current:shopList.currentPage total:shopList.totalRows image:[UIImage imageNamed:@"ic_shop_empty"] message:kStringNoShopInCurrentLocation functitle:@"添加小区" callback:^{
                    LHFeedbackViewController *vc = [[LHFeedbackViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestShopsForCouponWithMode:mode];
                }];
            }]];
            break;
        }
        case JXWebLaunchModeMore: {
            [self.operaters exAddObject:
             [LHHTTPClient queryShopsWithLatitude:gLH.receipt.latitude longitude:gLH.receipt.longitude type:self.from distance:[self getCurDistance] sort:[self getCurSort] index:(self.page.currentPage + 1) size:self.page.pageSize shops:self.shopsForCoupon success:^(AFHTTPRequestOperation *operation, LHShopList *shopList) {
                [self handleSuccessForTableView:self.tableView tableRect:self.tableRect mode:mode items:self.shops page:self.page results:shopList.shops current:shopList.currentPage total:shopList.totalRows image:nil message:@"没有更多店铺" functitle:nil callback:NULL];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestShopsForCouponWithMode:mode];
                }];
            }]];
            break;
        }
        default:
            break;
    }
}

#pragma mark assist
- (CGFloat)getCurDistance {
    NSInteger index = [_firstDataArry indexOfObject:_firstTitle];
//    if (3 == index) {
//        return 500.0f;
//    }else if (2 == index) {
//        return 1000.0f;
//    }else if (1 == index) {
//        return 2000.0f;
//    }else if (0 == index) {
//        return 100000.0f;
//    }else {
//        return 0.0f;
//    }
    
    if (0 == index) {
        return 3000.0f;
    }else if (1 == index) {
        return 100000.0f;
    }
    
    return 0.0f;
}

- (NSInteger)getCurSort {
    NSInteger index = [_secondDataArry indexOfObject:_secondTitle];
    
//    if (_from >= LHEntryFromHomeClothes && _from <= LHEntryFromHomeLuxury) {
//        if (0 == index) {
//            return 1;
//        }else if (1 == index) {
//            return 4;
//        }else if (2 == index) {
//            return 3;
//        }else {
//            return 2;
//        }
//    }else{
//        return index + 1;
//    }
    
    if (0 == index) {
        return 1;
    }else if (1 == index) {
        return 4;
    }else if (2 == index) {
        return 3;
    }else {
        return 2;
    }
    
    return 0;
}

#pragma mark - Accessor methods
- (CGRect)tableRect {
    if (CGRectEqualToRect(_tableRect, CGRectZero)) {
        _tableRect = CGRectMake(0, 0, kJXScreenWidth, kJXScreenHeight - 64 - 44);
    }
    return _tableRect;
}

#pragma mark - Action methods
- (void)mapItemPressed:(id)sender {
    if (!_requestedMapShops) {
        [self requestMapShopsWithMode:JXWebLaunchModeHUD];
    }else {
        LHShopMapViewController *mapVC = [[LHShopMapViewController alloc] initWithShops:self.mapShops];
        LHNavigationController *mapNav = [[LHNavigationController alloc] initWithRootViewController:mapVC];
        [self.navigationController presentViewController:mapNav animated:YES completion:NULL];
    }
}

#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _shops.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LHShopListCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHShopListCell identifier]];
    
    if (_from >= LHEntryFromHomeClothes && _from <= LHEntryFromHomeLuxury) {
        [(LHShopListCell *)cell setShop:_shops[indexPath.row]];
    }else if (_from == LHEntryFromActivity) {
        // [self requestShopsForActivityWithMode:JXWebLaunchModeLoad];
        [(LHShopListCell *)cell setActivityShop:_shops[indexPath.row]];
    }else if (_from == LHEntryFromFavorite) {
    }else if (_from == LHEntryFromCoupon) {
        [(LHShopListCell *)cell setShop:_shops[indexPath.row]];
    }
    
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ((_from >= LHEntryFromHomeClothes && _from <= LHEntryFromHomeLuxury) || (_from == LHEntryFromCoupon)) {
        LHShop *shop = self.shops[indexPath.row];
        if (2 == shop.sleeping) {
            JXToast(@"主人，店家去月球度假了，请移步别家~");
            return;
        }
//        if (shop.distance >= 3000) {
//            JXToast(@"怪我咯！超过服务范围，求反馈~");
//            return;
//        }
        
//        if (shop.freeze == 2) {
//            JXToast(@"这家店不乖，被关小黑屋了~");
//        }else if (shop.freeze == 4) {
//            JXToast(@"主人，店主回高老庄去了，请移步别家~");
//        }else if (shop.freeze == 5) {
//            JXToast(@"主人，店家去月球度假了，请移步别家~");
//        }else {
            // LHShopDetailViewController *detailVC = [[LHShopDetailViewController alloc] initWithShop:shop];
            LHShopDetailViewController *detailVC = [[LHShopDetailViewController alloc] initWithShopid:shop.shopId.integerValue];
            detailVC.from = self.from;
            [self.navigationController pushViewController:detailVC animated:YES];
        // }
    }else if (_from == LHEntryFromActivity) {
        LHActivityShop *as = _shops[indexPath.row];
        if (2 == as.sleeping) {
            JXToast(@"主人，店家去月球度假了，请移步别家~");
            return;
        }
        
//        if (as.distance >= 3000) {
//            JXToast(@"怪我咯！超过服务范围，求反馈~");
//            return;
//        }
        
//        [self showLoginIfNotLoginedWithFinish:^{
//            [self requestCheckWithMode:JXWebLaunchModeHUD shop:as];
//        }];
        
        //LHShopDetailViewController *detailVC = [[LHShopDetailViewController alloc] initWithShopid:as.shopId.integerValue activityId:as.activityId.integerValue];
        LHShopDetailViewController *detailVC = [[LHShopDetailViewController alloc] initWithShopid:as.shopId.integerValue];
        detailVC.activityFlag = YES;
        detailVC.from = self.from;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)requestCheckWithMode:(JXWebLaunchMode)mode  shop:(LHActivityShop *)shop {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient requestCheckUserJionActCountWithActId:shop.activityId productId:shop.productId success:^(AFHTTPRequestOperation *operation, NSNumber *response) {
        JXHUDHide();
        if (response.boolValue) {
            LHSpecify *s = [[LHSpecify alloc] init];
            s.productId = shop.productId;
            s.uid = shop.productId;
            s.name = shop.prodname;
            s.url = shop.producturl;
            s.price = [NSString stringWithFormat:@"%.2f", shop.price];
            s.pieces = 1;
            
            LHCartShop *cs = [[LHCartShop alloc] init];
            cs.shopID = shop.shopId;
            cs.shopName = shop.shopName;
            [cs.specifies addObject:s];
            
            LHOrderConfirmViewController *confirmVC = [[LHOrderConfirmViewController alloc] initWithCartShops:@[cs]];
            confirmVC.from = LHEntryFromActivity;
            [self.navigationController pushViewController:confirmVC animated:YES];
        }else {
            JXToast(@"该活动无法参加");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:NULL];
    }]];
}

//#pragma mark - SWTableViewDelegate
//
//- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
//{
//    switch (state) {
//        case 0:
//            NSLog(@"utility buttons closed");
//            break;
//        case 1:
//            NSLog(@"left utility buttons open");
//            break;
//        case 2:
//            NSLog(@"right utility buttons open");
//            break;
//        default:
//            break;
//    }
//}
//
//- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
//{
//    switch (index) {
//        case 0:
//            NSLog(@"left button 0 was pressed");
//            break;
//        case 1:
//            NSLog(@"left button 1 was pressed");
//            break;
//        case 2:
//            NSLog(@"left button 2 was pressed");
//            break;
//        case 3:
//            NSLog(@"left btton 3 was pressed");
//        default:
//            break;
//    }
//}
//
//- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
//{
//    switch (index) {
//        case 0:
//        {
//            NSLog(@"More button was pressed");
//            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
//            [alertTest show];
//
//            [cell hideUtilityButtonsAnimated:YES];
//            break;
//        }
//        case 1:
//        {
//////            // Delete button was pressed
//////            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
//////
//////            [_testArray[cellIndexPath.section] removeObjectAtIndex:cellIndexPath.row];
////            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
//            break;
//        }
//        default:
//            break;
//    }
//}
//
//- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
//{
//    // allow just one cell's utility button to be open at once
//    return YES;
//}
//
//- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
//{
//    switch (state) {
//        case 1:
//            // set to NO to disable all left utility buttons appearing
//            return YES;
//            break;
//        case 2:
//            // set to NO to disable all right utility buttons appearing
//            return YES;
//            break;
//        default:
//            break;
//    }
//
//    return YES;
//}


#pragma mark - JCSegmentConditionMenuDelegate
- (NSUInteger)numberOfSegmentConditionMenu:(JCSegmentConditionBaseMenu *)segmentConditionMenu NS_AVAILABLE_IOS(6_0) {
    return 2;
}

- (CGFloat)heightOfSegmentConditionMenuContentView:(JCSegmentConditionBaseMenu *)segmentConditionMenu atMenuItemIndex:(NSUInteger)index {
    switch (index) {
        case 0: {
            return [_firstDataArry count]*44.0f;
            break;
        }
        case 1: {
            return [_secondDataArry count]*44.0f;
            break;
        }
        default:
            break;
    }
    
    return 0;
}

- (NSArray *)dataOfSegmentConditionMenuContentView:(JCSegmentConditionBaseMenu *)segmentConditionMenu atMenuItemIndex:(NSUInteger)index {
    switch (index) {
        case 0:{
            return _firstDataArry;
            break;}
        case 1:{
            return _secondDataArry;
            break;}
        default:{
            break;
        }
    }
    return nil;
}


// item
- (JCSegmentMenuBaseItemView *)segmentConditionMenu:(JCSegmentConditionBaseMenu *)segmentConditionMenu baseItemViewForSegmentAtIndex:(NSUInteger)index NS_AVAILABLE_IOS(6_0) {
    JCSegmentMenuChildItemView *itemView = [[JCSegmentMenuChildItemView alloc] init];
    itemView.showTitleLabel.textColor    = JXColorRGB(102.0f, 102.0f, 102.0f); // JXColorHex(0x38D8D5); // JXColorRGB(102.0f, 102.0f, 102.0f);
    return itemView;
}


- (void)segmentConditionMenu:(JCSegmentConditionBaseMenu *)segmentConditionMenu didSelectMenuItemAtIndex:(NSUInteger)index {
    //NSLog(@"点击了%lu个",(unsigned long)index);
}

#pragma mark - JCSegmentConditionChildMenuDelegate
- (NSString *)titleOfSegmentConditionMenu:(JCSegmentConditionChildMenu *)segmentConditionMenu atMenuItemIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            return _firstTitle;
            break;
        }
        case 1:{
            return _secondTitle;
            break;
        }
        default:
            break;
    }
    
    return nil;
}


- (void)segmentConditionMenu:(JCSegmentConditionChildMenu *)segmentConditionMenu didSelectContentItemAtIndex:(NSUInteger)index {
    switch (segmentConditionMenu.currentSelectedMenuIndex) {
        case 0:{  //选择距离
            _firstTitle = [_firstDataArry objectAtIndex:index];
            break;
        }
        case 1:{  //选择类别数据
            _secondTitle  = [_secondDataArry objectAtIndex:index];
            break;
        }
        default:
            break;
    }
    //刷新菜单标题
    [segmentConditionMenu reloadMenuItemTitleAtIndex:segmentConditionMenu.currentSelectedMenuIndex];
    
    [self setupNet];
}


#pragma mark - Public methods
#pragma mark - Class methods
@end
