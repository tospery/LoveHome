//
//  LHHomeViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/16.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "LHHomeViewController.h"
#import "LHLoginViewController.h"
#import "LHWasherButton.h"
#import "LHHTTPClient.h"
#import "LHShopListViewController.h"
#import "LHStarView.h"
#import "LHShopDetailViewController.h"
#import "LHCityViewController.h"
#import "LHShopDetailViewController.h"
#import "LHHomeSearchView.h"
#import "LHLoveBeanViewController.h"
#import "LHActivity.h"
#import "LHActivityViewController.h"
#import "LHRechargeViewController.h"
#import "LHSearchViewController.h"

@interface LHHomeViewController ()
//@property (nonatomic, strong) LHWasherButton *myClickedButton;
//@property (nonatomic, assign) NSInteger actionType;
//@property (nonatomic, assign) BOOL isLocating;
@property (nonatomic, strong) NSArray *activities;
@property (nonatomic, assign) BOOL onceLayout;
@property (nonatomic, assign) BOOL locationFlag;
@property (nonatomic, strong) BMKLocationService *locateService;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableArray *activitySubviews;
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, strong) UIBarButtonItem *locationBarItem;
@property (nonatomic, strong) UIBarButtonItem *rechargeBarItem;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, weak) IBOutlet UIView *mainView;
@property (nonatomic, weak) IBOutlet UIButton *washerButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@end

@implementation LHHomeViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initVar];
    [self initView];
    [self initDB];
    [self initNet];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    if (!gLH.isLocated) {
        gLH.isLocated = YES;
        JXHUDProcessing(@"正在定位");
        [self startLocating];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //self.locateService.delegate = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.locateService stopUserLocationService];
    self.locateService = nil;
}

#pragma mark - Private methods
#pragma mark init
- (void)initVar {
    //_isLocating = YES;
    self.categories = @[[UIImage imageNamed:@"home_washer_shoe"],
                        [UIImage imageNamed:@"home_washer_nearby"],
                        [UIImage imageNamed:@"home_washer_beans"],
                        [UIImage imageNamed:@"home_washer_activity"],
                        [UIImage imageNamed:@"home_washer_luxury"],
                        [UIImage imageNamed:@"home_washer_safe"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyApplicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyApplicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)initView {
    [self showNavBarItem:YES];

    _scrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestGetActivitiesWithMode:JXWebLaunchModeRefresh];
    }];
}

- (void)initDB {
    
}

- (void)initNet {
    [self requestGetActivitiesWithMode:JXWebLaunchModeSilent];
}

#pragma mark request
- (void)requestGetActivitiesWithMode:(JXWebLaunchMode)mode {
    switch (mode) {
        case JXWebLaunchModeSilent: {
            [LHHTTPClient getActivitiesWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *activities) {
                self.activities = activities;
                [self showActivities];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            } retryTimes:3];
            break;
        }
        case JXWebLaunchModeRefresh: {
            [LHHTTPClient getActivitiesWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *activities) {
                self.activities = activities;
                [self showActivities];
                [_scrollView.header endRefreshing];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [_scrollView.header endRefreshing];
            } retryTimes:0];
            break;
        }
        default:
            break;
    }
}

#pragma mark assist
- (void)showActivities {
    if (self.activities.count == 0) {
        return;
    }
    
    __block CGFloat firstOffset;
    CGFloat topHeight;
    CGFloat lineHeight = 90.0f;
    JXDeviceResolution resolution = [JXDevice sharedInstance].resolution;
    switch (resolution) {
        case JXDeviceResolution640x960: {
            firstOffset = -28;
            topHeight = 273.5;
            break;
        }
        case JXDeviceResolution640x1136: {
            firstOffset = -28;
            topHeight = 273.5;
            break;
        }
        case JXDeviceResolution750x1334: {
            firstOffset = -33;
            topHeight = 319.0f;
            break;
        }
        case JXDeviceResolution1242x2208: {
            firstOffset = -36;
            topHeight = 353.3f;
            break;
        }
        default:
            break;
    }
    
    self.heightConstraint.constant = topHeight + lineHeight * self.activities.count + 20;
    
    [self.activitySubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *currentLine;
    UIImageView *prevLine;
    for (NSUInteger i = 0; i < self.activities.count; ++i) {
        if (0 == i) {
            currentLine = [[UIImageView alloc] init];
            currentLine.image = [UIImage imageNamed:@"home_line_1"];
            [currentLine sizeToFit];
            [self.mainView addSubview:currentLine];
            [self.activitySubviews addObject:currentLine];
            [currentLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mainView);
                make.top.equalTo(self.washerButton.mas_bottom).offset(firstOffset);
            }];
            prevLine = currentLine;
        }else {
            currentLine = [[UIImageView alloc] init];
            currentLine.image = [UIImage imageNamed:@"home_line_2"];
            [currentLine sizeToFit];
            [self.mainView addSubview:currentLine];
            [self.activitySubviews addObject:currentLine];
            [currentLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mainView);
                make.top.equalTo(prevLine.mas_bottom).offset(0);
            }];
            prevLine = currentLine;
        }
        
        if (0 == i % 2) {
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            rightButton.tag = i;
            rightButton.contentMode = UIViewContentModeScaleAspectFit;
            rightButton.backgroundColor = [UIColor clearColor];
            [rightButton sd_setImageWithURL:[NSURL URLWithString:[(LHActivity *)self.activities[i] imgurl]]  forState:UIControlStateNormal placeholderImage:kImageWaitingRectangle];
            [rightButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [rightButton sizeToFit];
            [self.mainView addSubview:rightButton];
            [self.activitySubviews addObject:rightButton];
            [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(currentLine.mas_trailing).offset(4);
                make.bottom.equalTo(currentLine.mas_bottom).offset(30);
                make.trailing.equalTo(self.mainView.mas_trailing).offset(-20);
                make.width.equalTo(rightButton.mas_height).multipliedBy(316/140);
            }];
        }else {
            UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            leftButton.tag = i;
            leftButton.contentMode = UIViewContentModeScaleAspectFit;
            leftButton.backgroundColor = [UIColor clearColor];
            [leftButton sd_setImageWithURL:[NSURL URLWithString:[(LHActivity *)self.activities[i] imgurl]]  forState:UIControlStateNormal placeholderImage:kImageWaitingRectangle];
            [leftButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [leftButton sizeToFit];
            [self.mainView addSubview:leftButton];
            [self.activitySubviews addObject:leftButton];
            [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(currentLine.mas_leading).offset(-4);
                make.bottom.equalTo(currentLine.mas_bottom).offset(30);
                make.leading.equalTo(self.mainView.mas_leading).offset(20);
                make.width.equalTo(leftButton.mas_height).multipliedBy(316/140);
            }];
        }
    }
    
    [self.view setNeedsDisplay];
}

- (void)showNavBarItem:(BOOL)show {
    if (show) {
        CGFloat width = 0.0;
        if (!_locationBarItem) {
            _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _locationButton.backgroundColor = [UIColor clearColor];
            _locationButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            _locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_locationButton setImage:[UIImage imageNamed:@"navbar_location"] forState:UIControlStateNormal];
            [_locationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_locationButton setTitle:gLH.city forState:UIControlStateNormal];
            [_locationButton sizeToFit];
            width = _locationButton.bounds.size.width;
            [_locationButton addTarget:self action:@selector(locationBarItemPressed:) forControlEvents:UIControlEventTouchUpInside];
            _locationBarItem = [[UIBarButtonItem alloc] initWithCustomView:_locationButton];
        }
        self.navigationItem.leftBarButtonItem = _locationBarItem;
        
        if (!_rechargeBarItem) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
            view.backgroundColor = [UIColor clearColor];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundImage:[UIImage imageNamed:@"navbar_recharge"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(rechargeBarItemPressed:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(view.mas_trailing);
                make.width.equalTo(@24);
                make.height.equalTo(@24);
                make.centerY.equalTo(view.mas_centerY);
            }];
            _rechargeBarItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        }
        self.navigationItem.rightBarButtonItem = _rechargeBarItem;
        
        
        LHHomeSearchView *searchView = [[[NSBundle mainBundle] loadNibNamed:@"LHHomeSearchView" owner:self options:nil] lastObject];
        searchView.frame = CGRectMake(0, 0, kJXScreenWidth - width * 2, 44);
        [searchView setPressBlock:^() {
//            if (_isLocating) {
//                _actionType = 2;
//                JXHUDProcessing(@"正在定位");
//            }else {
                LHSearchViewController *searchVC = [[LHSearchViewController alloc] init];
                LHNavigationController *searchNav = [[LHNavigationController alloc] initWithRootViewController:searchVC];
                [self presentViewController:searchNav animated:NO completion:NULL];
            //}
        }];
        self.navigationItem.titleView = searchView;
    }else {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

//- (void)handleFinishLocated {
//    _isLocating = NO;
//    JXHUDHide();
//    
//    if (1 == _actionType) {
//        [self funcButtonPressed:_myClickedButton];
//    }else if (2 == _actionType) {
//        LHSearchViewController *searchVC = [[LHSearchViewController alloc] init];
//        LHNavigationController *searchNav = [[LHNavigationController alloc] initWithRootViewController:searchVC];
//        [self presentViewController:searchNav animated:NO completion:NULL];
//    }else {
//        
//    }
//    
//    _myClickedButton = nil;
//    _actionType = 0;
//}

- (void)startLocating {
    if (![CLLocationManager locationServicesEnabled]) {
        JXHUDHide();
        Alert(kStringTips, kStringLocationServiceIsClosedPleaseToOpenInSetting);
        //[self handleFinishLocated];
        return;
    }
    [self.locateService startUserLocationService];
}

#pragma mark - Accessor methods
- (BMKLocationService *)locateService {
    if (!_locateService) {
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        _locateService = [[BMKLocationService alloc] init];
        _locateService.delegate = self;
    }
    return _locateService;
}

- (NSMutableArray *)activitySubviews {
    if (!_activitySubviews) {
        _activitySubviews = [NSMutableArray arrayWithCapacity:5];
    }
    return _activitySubviews;
}

#pragma mark - Action methods
- (void)locationBarItemPressed:(id)sender {
    LHCityViewController *cityVC = [[LHCityViewController alloc] init];
    LHNavigationController *cityNav = [[LHNavigationController alloc] initWithRootViewController:cityVC];
    [self presentViewController:cityNav animated:YES completion:NULL];
}

- (void)rechargeBarItemPressed:(id)sender {
    [self showLoginIfNotLoginedWithFinish:^(){
        LHRechargeViewController *inchargeVC = [[LHRechargeViewController alloc] init];
        inchargeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:inchargeVC animated:YES];
    }];
}

- (void)activityButtonPressed:(id)sender {
    LHActivity *activity = [self.activities objectAtIndex:[(UIButton *)sender tag]];
    LHActivityViewController *activityVC = [[LHActivityViewController alloc] initWithActivity:activity];
    activityVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:activityVC animated:YES];
}

- (IBAction)funcButtonPressed:(id)sender {
//    if (_isLocating) {
//        _myClickedButton = sender;
//        _actionType = 1;
//        JXHUDProcessing(@"正在定位")
//        return;
//    }
    
    
    LHWasherButton *btn = (LHWasherButton *)sender;
    [btn setBackgroundImage:self.categories[btn.tag] forState:UIControlStateNormal];
    
    switch (btn.tag) {
        case 0: {   // 洗鞋
            LHShopListViewController *nearbyVC = [[LHShopListViewController alloc] init];
            nearbyVC.from = LHEntryFromHomeShoe;
            nearbyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nearbyVC animated:YES];
            break;
        }
        case 1: {   // 快洗
            LHShopListViewController *nearbyVC = [[LHShopListViewController alloc] init];
            nearbyVC.from = LHEntryFromHomeClothes;
            nearbyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nearbyVC animated:YES];
            
            //[self.navigationController pushViewController:nearbyVC animated:YES checkLogin:YES];
            break;
        }
        case 2: {   // 爱豆
            [self showLoginIfNotLoginedWithFinish:^(){
                LHLovebeanViewController *loveBeanVC = [[LHLovebeanViewController alloc] init];
                loveBeanVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:loveBeanVC animated:YES];
            }];
            break;
        }
        case 3: {   // 活动
            JXToast(@"怪我咯，努力ing，你懂的~");
            break;
        }
        case 4: {   // 奢侈品
            LHShopListViewController *nearbyVC = [[LHShopListViewController alloc] init];
            nearbyVC.from = LHEntryFromHomeLuxury;
            nearbyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nearbyVC animated:YES];
            break;
        }
        case 5: {   // 皮具
            LHShopListViewController *nearbyVC = [[LHShopListViewController alloc] init];
            nearbyVC.from = LHEntryFromHomeLeather;
            nearbyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nearbyVC animated:YES];
            break;
        }
        default: {
            LogError(@"没有该分类");
            break;
        }
    }
    
    //_myClickedButton = nil;
}

- (void)entryListWithTag:(NSInteger)tag {
    
}

#pragma mark - Notification methods
- (void)notifyApplicationDidBecomeActive:(NSNotification *)notify {
    [self startLocating];
}

- (void)notifyApplicationDidEnterBackground:(NSNotification *)notify {
    //_isLocating = YES;
}

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kJXStandardCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kJXIdentifierCellSystem];
    cell.textLabel.text = @"结果";
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark BMKLocationServiceDelegate
- (void)willStartLocatingUser {
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [self.locateService stopUserLocationService];
    
    CLLocation *location = userLocation.location;
    gLH.longitude = location.coordinate.longitude;
    gLH.latitude = location.coordinate.latitude;
    
//    NSString *str = [NSString stringWithFormat:@"(%@, %@)", @(gLH.longitude), @(gLH.latitude)];
//    JXAlert(@"临时测试", str);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || 0 == placemarks.count) {
            //Alert(kStringError, @"无法定位，请手动选择城市");
        }else {
            CLPlacemark *foundPlacemark = [placemarks objectAtIndex:0];
//            gLH.longitude = foundPlacemark.location.coordinate.longitude;
//            gLH.latitude = foundPlacemark.location.coordinate.latitude;
            
            NSString *city = foundPlacemark.locality;
            if ([foundPlacemark.locality hasSuffix:@"市"]) {
                city = [city substringToIndex:city.length - 1];
            }
            if (![city isEqualToString:gLH.city]) {
                gLH.city = city;
                [_locationButton setTitle:gLH.city forState:UIControlStateNormal];
                [_locationButton sizeToFit];
            }
        }
    }];
    JXHUDHide();
}

- (void)didStopLocatingUser {
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    [self.locateService stopUserLocationService];
    if (kCLErrorDenied == error.code) {
        Alert(kStringTips, kStringLocationServiceIsRejectedPleaseToOpenInSetting);
    }else {
        //Alert(kStringError, @"无法定位，请手动选择城市");
    }
    JXHUDHide();
}

#pragma mark UISearchDisplayDelegate
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kJXIdentifierCellSystem];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    return YES;
}

//#pragma mark UISearchBarDelegate
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    [self showNavBarItem:NO];
//    searchBar.showsCancelButton = YES;
//}
//
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    [self showNavBarItem:YES];
//    searchBar.showsCancelButton = NO;
//    searchBar.text = nil;
//    [searchBar resignFirstResponder];
//}
@end




