//
//  LHSearchViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/23.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import "LHSearchViewController.h"
#import "LHSearchBackView.h"
#import "LHShopListCell.h"
#import "LHShopDetailViewController.h"
#import "LHFeedbackViewController.h"

@interface LHSearchViewController ()
@property (nonatomic, assign) BOOL onced;
@property (nonatomic, strong) BMKLocationService *locateService;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) JXPage *page;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, assign) CGRect tableRect;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@end

@implementation LHSearchViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVar];
    [self setupView];
    [self setupDB];
    [self setupNet];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.locateService stopUserLocationService];
    self.locateService = nil;
}

- (BMKLocationService *)locateService {
    if (!_locateService) {
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        _locateService = [[BMKLocationService alloc] init];
        _locateService.delegate = self;
    }
    return _locateService;
}

- (void)startLocating {
    [JXLoadView showProcessingAddedTo:self.tableView rect:self.tableRect];
    
    if (![CLLocationManager locationServicesEnabled]) {
        [self requestSearchShopsWithMode:JXWebLaunchModeLoad name:_searchBar.text];
    }else {
        [self.locateService startUserLocationService];
    }
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
    [self requestSearchShopsWithMode:JXWebLaunchModeLoad name:_searchBar.text];
}

- (void)didStopLocatingUser {
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    [self.locateService stopUserLocationService];
    [self requestSearchShopsWithMode:JXWebLaunchModeLoad name:_searchBar.text];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
    _page = [[JXPage alloc] init];
    _tableRect = CGRectMake(0, 0, kJXScreenWidth, kJXScreenHeight - 64);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)hideKeyboard:(id)sender {
    [_searchBar resignFirstResponder];
}

- (void)setupView {
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.placeholder = @"输入店铺名";
    _searchBar.tintColor = [UIColor darkGrayColor];
    _searchBar.delegate = self;
    [_searchBar becomeFirstResponder];
    self.navigationItem.titleView = _searchBar;
    
//    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
//    //不加会屏蔽到TableView的点击事件等
//    tapGr.cancelsTouchesInView = NO;
//    [_tableView addGestureRecognizer:tapGr];
//    [_contentView addGestureRecognizer:tapGr];
    
    LHSearchBackView *backView = [[[NSBundle mainBundle] loadNibNamed:@"LHSearchBackView" owner:self options:nil] lastObject];
    [backView setPressBlock:^() {
        [self dismissViewControllerAnimated:NO completion:NULL];
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    
    UINib *cellNib = [UINib nibWithNibName:@"LHShopListCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:[LHShopListCell identifier]];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestSearchShopsWithMode:JXWebLaunchModeRefresh name:_name];
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestSearchShopsWithMode:JXWebLaunchModeMore name:_name];
    }];
}

- (void)setupDB {
}

- (void)setupNet {
}

#pragma mark fetch

#pragma mark request
- (void)requestSearchShopsWithMode:(JXWebLaunchMode)mode name:(NSString *)name {
    _name = name;
    
    switch (mode) {
        case JXWebLaunchModeLoad: {
            [JXLoadView showProcessingAddedTo:self.tableView rect:self.tableRect];
            [self.operaters exAddObject:
             [LHHTTPClient searchShopsWithLatitude:gLH.latitude longitude:gLH.longitude name:name distance:30000.0f sort:1 index:1 size:_page.pageSize success:^(AFHTTPRequestOperation *operation, LHShopList *shopList) {
                [self handleSuccessForTableView:self.tableView tableRect:self.tableRect mode:mode items:self.results page:_page results:shopList.shops current:shopList.currentPage total:shopList.totalRows image:[UIImage imageNamed:@"ic_shop_empty"] message:kStringNoShopInCurrentLocation functitle:@"添加小区" callback:^{
                    LHFeedbackViewController *vc = [[LHFeedbackViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                [self configRightItemWithCount:shopList.totalRows];
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestSearchShopsWithMode:mode name:name];
                }];
            }]];
            break;
        }
        case JXWebLaunchModeRefresh: {
            [self.operaters exAddObject:
             [LHHTTPClient searchShopsWithLatitude:gLH.latitude longitude:gLH.longitude name:name distance:30000.0f sort:1 index:1 size:_page.pageSize success:^(AFHTTPRequestOperation *operation, LHShopList *shopList) {
                [self handleSuccessForTableView:self.tableView tableRect:self.tableRect mode:mode items:self.results page:_page results:shopList.shops current:shopList.currentPage total:shopList.totalRows image:[UIImage imageNamed:@"ic_shop_empty"] message:kStringNoShopInCurrentLocation functitle:@"添加小区" callback:^{
                    LHFeedbackViewController *vc = [[LHFeedbackViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                [self configRightItemWithCount:shopList.totalRows];
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestSearchShopsWithMode:mode name:name];
                }];
            }]];
            break;
        }
        case JXWebLaunchModeMore: {
            [self.operaters exAddObject:
             [LHHTTPClient searchShopsWithLatitude:gLH.latitude longitude:gLH.longitude name:name distance:30000.0f sort:1 index:(_page.currentPage + 1) size:_page.pageSize success:^(AFHTTPRequestOperation *operation, LHShopList *shopList) {
                [self handleSuccessForTableView:self.tableView tableRect:self.tableRect mode:mode items:self.results page:_page results:shopList.shops current:shopList.currentPage total:shopList.totalRows image:nil message:@"没有更多店铺" functitle:nil callback:NULL];
                [self configRightItemWithCount:shopList.totalRows];
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestSearchShopsWithMode:mode name:name];
                }];
            }]];
            break;
        }
        default:
            break;
    }
}


#pragma mark assist
- (void)configRightItemWithCount:(NSInteger)count {
    NSString *tips;
    if (count >= 1000) {
        tips = [NSString stringWithFormat:@"%ld条", (long)count];
    }else if (count >= 100 && count < 1000) {
        tips = [NSString stringWithFormat:@" %ld条", (long)count];
    }else {
        tips = [NSString stringWithFormat:@" %ld条 ", (long)count];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:tips style:UIBarButtonItemStylePlain target:self action:@selector(resultItemPressed:)];
}

#pragma mark - Accessor methods
- (NSMutableArray *)results {
    if (!_results) {
        _results = [NSMutableArray array];
    }
    return _results;
}


#pragma mark - Action methods
- (void)resultItemPressed:(id)sender {
    if (self.results.count == 0) {
        return;
    }
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - Notification methods
- (void)notifyKeyboardWillHide:(id)sender {
    _searchBar.showsCancelButton = NO;
    [self configRightItemWithCount:self.results.count];
}

- (void)notifyKeyboardWillShow:(id)sender {
    _searchBar.showsCancelButton = YES;
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LHShopListCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LHShopListCell *cell = (LHShopListCell *)[tableView dequeueReusableCellWithIdentifier:[LHShopListCell identifier]];
    cell.shop = self.results[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LHShop *shop = self.results[indexPath.row];
//    if (shop.distance >= 3000) {
//        JXToast(@"怪我咯！超过服务范围，求反馈~");
//        return;
//    }
    
    if (shop.freeze == 2) {
        JXToast(@"这家店不乖，被关小黑屋了~");
    }else if (shop.freeze == 4) {
        JXToast(@"主人，店主回高老庄去了，请移步别家~");
    }else if (shop.freeze == 5) {
        JXToast(@"主人，店家去月球度假了，请移步别家~");
    }else {
        LHShopDetailViewController *detailVC = [[LHShopDetailViewController alloc] initWithShop:shop];
        detailVC.from = LHEntryFromSearch;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text.length == 0) {
        JXToast(@"请输入搜索内容");
        return;
    }
    
    [searchBar resignFirstResponder];
    
//    if (!_onced) {
//        _onced = YES;
//        [self startLocating];
//    }else {
    //[self requestSearchShopsWithMode:JXWebLaunchModeLoad name:searchBar.text];
    //}
    
    [self requestSearchShopsWithMode:JXWebLaunchModeLoad name:searchBar.text];
}

#pragma mark - Public methods
#pragma mark - Class methods


@end





