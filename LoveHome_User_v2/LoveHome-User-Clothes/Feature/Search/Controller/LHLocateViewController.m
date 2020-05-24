//
//  LHLocateViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/14.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import "LHLocateViewController.h"
#import "LHLocateReceiptCell.h"
#import "LHReceiptViewController.h"
#import "LHReceiptModify2ViewController.h"
#import "LHLocationNearbyViewController.h"

#define LHLocateResultTag           (101)

@interface LHLocateViewController ()
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) BMKPoiSearch *poisearch;
@property (nonatomic, strong) BMKLocationService *locateService;
@property (nonatomic, weak) IBOutlet UITextField *keywordTextField;
@property (nonatomic, weak) IBOutlet UITableView *resultTableView;
@property (nonatomic, weak) IBOutlet UIView *resultBgView;

@property (nonatomic, assign) CGRect tableRect;
@property (nonatomic, strong) NSMutableArray *receipts;
@property (nonatomic, weak) IBOutlet UITableView *receiptTableView;

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *funcButtons;
@end

@implementation LHLocateViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVar];
    [self setupView];
    [self setupDB];
    [self setupNet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _poisearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _poisearch.delegate = nil;
}

- (void)dealloc {
    _poisearch = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_locateService) {
        [_locateService stopUserLocationService];
        _locateService = nil;
    }
}


#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
    _tableRect = CGRectMake(0, 0, kJXScreenWidth, kJXScreenHeight - 64 - kJXScreenWidth / 320.0f * (54 + 44 + 50));
    _results = [NSMutableArray array];
    _receipts = [NSMutableArray array];
    _poisearch = [[BMKPoiSearch alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyLoginSuccess:) name:kNotifyLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyReceiptChanged:) name:kNotifyReceiptChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyReceiptSelected:) name:kNotifyReceiptSelected object:nil];
}

- (void)setupView {
    self.navigationItem.title = @"管理收货地址";
    self.navigationItem.leftBarButtonItem = CreateBackBarItem(self);
    
    _resultTableView.tableFooterView = [[UIView alloc] init];
    
    //[_resultTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kJXIdentifierCellSystem];
    UINib *cellNib = [UINib nibWithNibName:@"LHLocateReceiptCell" bundle:nil];
    [_receiptTableView registerNib:cellNib forCellReuseIdentifier:[LHLocateReceiptCell identifier]];
    
    [_resultBgView exSetBorder:[UIColor clearColor] width:0.0 radius:2.0];
    
    for (UIButton *btn in _funcButtons) {
        ConfigButtonStyle(btn);
    }
}

- (void)setupDB {
}

- (void)setupNet {
    if (gLH.logined) {
        [self requestReceiptsWithMode:JXWebLaunchModeLoad];
    }
}

#pragma mark fetch
- (BMKLocationService *)locateService {
    if (!_locateService) {
        _locateService = [[BMKLocationService alloc] init];
        _locateService.delegate = self;
    }
    return _locateService;
}

- (void)startLocating {
    if (![CLLocationManager locationServicesEnabled]) {
        JXHUDHide();
        Alert(kStringTips, kStringLocationServiceIsClosedPleaseToOpenInSetting);
        return;
    }
    [self.locateService startUserLocationService];
}

#pragma mark request
- (void)requestReceiptsWithMode:(JXWebLaunchMode)mode {
    switch (mode) {
        case JXWebLaunchModeLoad: {
            [JXLoadView showProcessingAddedTo:self.receiptTableView rect:_tableRect];
            [self.operaters exAddObject:
             [LHHTTPClient getReceiptsWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *receipts) {
                [_receipts removeAllObjects];
                [_receipts addObjectsFromArray:receipts];
                [_receiptTableView reloadData];
                [JXLoadView hideForView:self.receiptTableView];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [JXLoadView hideForView:self.receiptTableView];
            }]];
            break;
        }
            //        case JXWebLaunchModeRefresh: {
            //            [self.operaters exAddObject:
            //             [LHHTTPClient getReceiptsWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *receipts) {
            //                [self.tableView.header endRefreshing];
            //                [self.receipts removeAllObjects];
            //                [self.receipts addObjectsFromArray:receipts];
            //                [self.tableView reloadData];
            //            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //                [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayToast error:error callback:^{
            //                    [self requestReceiptsWithMode:mode];
            //                }];
            //            }]];
            //            break;
            //        }
        default:
            break;
    }
}

- (void)requestSetDefault:(LHReceipt *)receipt {
    //    if (receipt.isDefault) {
    //        return;
    //    }
    //
    
    if (receipt.isDefault) {
        gLH.receipt = receipt;
        [self dismissViewControllerAnimated:YES completion:NULL];
        return;
    }
    
    JXHUDProcessing(nil);
    [LHHTTPClient setDefaultReceiptWithUid:@(receipt.receiptID.integerValue) success:^(AFHTTPRequestOperation *operation, NSNumber *result) {
                JXHUDHide();
                if (!result.boolValue) {
                    JXToast(@"咦~请重新设置收货地址");
                }else {
                    for (LHReceipt *obj in _receipts) {
                        if ([obj.receiptID isEqualToString:receipt.receiptID]) {
                            obj.isDefault = YES;
                        }else {
                            obj.isDefault = NO;
                        }
                    }
                    [_receiptTableView reloadData];
                    gLH.receipt = receipt;
                    [self dismissViewControllerAnimated:YES completion:NULL];
                }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:JXWebLaunchModeHUD way:JXWebHandleWayToast error:error callback:NULL];
    }];
}

#pragma mark assist

#pragma mark - Accessor methods

#pragma mark - Action methods
- (void)leftBarItemPressed:(id)sender {
    NSInteger zOrder = [self.view.subviews indexOfObject:_resultBgView];
    if (0 == zOrder) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }else {
        _keywordTextField.text = nil;
        [self.view sendSubviewToBack:_resultBgView];
    }
}

- (IBAction)searchBegined:(id)sender {
    NSInteger zOrder = [self.view.subviews indexOfObject:_resultBgView];
    if (0 == zOrder) {
        [self.view bringSubviewToFront:_resultBgView];
    }
}

- (IBAction)searchEdited:(UITextField *)textField {
    if (textField.text.length >= 1) {
        BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
        citySearchOption.pageIndex = 0;
        citySearchOption.pageCapacity = 20;
        citySearchOption.city= @"成都";
        citySearchOption.keyword = textField.text;
        BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
        if(flag) {
            JXLogDebug(@"城市内检索发送成功");
        }else {
            JXLogDebug(@"城市内检索发送失败");
        }
    }else {
        [_results removeAllObjects];
        [_resultTableView reloadData];
    }
}

- (IBAction)manageButtonPressed:(id)sender {
    [self showLoginIfNotLoginedWithFinish:^{
        LHReceiptViewController *vc = [[LHReceiptViewController alloc] init];
        vc.from = LHReceiptFromChoose;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (IBAction)addButtonPressed:(id)sender {
    [self showLoginIfNotLoginedWithFinish:^{
        LHReceiptModify2ViewController *vc = [[LHReceiptModify2ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (IBAction)nearbyButtonPressed:(id)sender {
    [self startLocating];
}

#pragma mark - Notification methods
- (void)notifyLoginSuccess:(NSNotification *)notification {
    [self requestReceiptsWithMode:JXWebLaunchModeLoad];
}

- (void)notifyReceiptChanged:(NSNotification *)notification {
    LHReceipt *receipt = notification.object;
    
    NSInteger index = 0;
    for (index = 0; index < self.receipts.count; ++index) {
        LHReceipt *obj = self.receipts[index];
        if ([obj.receiptID isEqualToString:receipt.receiptID]) {
            break;
        }
    }
    
    if (index == self.receipts.count) {
        if (receipt) {
            [self.receipts addObject:receipt];
        }
    }else {
        if (receipt) {
            [self.receipts replaceObjectAtIndex:index withObject:receipt];
        }
    }
    [_receiptTableView reloadData];
}

- (void)notifyReceiptSelected:(NSNotification *)notification {
//    LHReceipt *receipt = notification.object;
//    for (LHReceipt *obj in self.receipts) {
//        if ([obj.receiptID isEqualToString:receipt.receiptID]) {
//            obj.isDefault = YES;
//        }else {
//            obj.isDefault = NO;
//        }
//    }
//    [_receiptTableView reloadData];
    
//
////    NSInteger index = 0;
////    for (index = 0; index < self.receipts.count; ++index) {
////        LHReceipt *obj = self.receipts[index];
////        if ([obj.receiptID isEqualToString:receipt.receiptID]) {
////            break;
////        }
////    }
    
    [self requestReceiptsWithMode:JXWebLaunchModeLoad];
}

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (LHLocateResultTag == tableView.tag) {
        return _results.count;
    }else {
        return _receipts.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (LHLocateResultTag == tableView.tag) {
        return 50.0f;
    }else {
        return [LHLocateReceiptCell height];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (LHLocateResultTag == tableView.tag) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kJXIdentifierCellSystem];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kJXIdentifierCellSystem];
        }
        
        BMKPoiInfo *poi = _results[indexPath.row];
        cell.textLabel.text = poi.name;
        cell.textLabel.textColor = JXColorHex(0x333333);
        cell.detailTextLabel.text = poi.address;
        cell.detailTextLabel.textColor = JXColorHex(0x999999);
        cell.imageView.image = [UIImage imageNamed:@"navbar_location"];
        return cell;
    }else {
        LHLocateReceiptCell *cell = (LHLocateReceiptCell *)[tableView dequeueReusableCellWithIdentifier:[LHLocateReceiptCell identifier]];
        cell.receipt = _receipts[indexPath.row];
        return cell;
    }
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (LHLocateResultTag == tableView.tag) {
        BMKPoiInfo *poi = _results[indexPath.row];
        gLH.receipt = [[LHReceipt alloc] init];
        gLH.receipt.receiptID = @"-77";
        gLH.receipt.longitude = poi.pt.longitude;
        gLH.receipt.latitude = poi.pt.latitude;
        gLH.receipt.address = poi.name;
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    }else {
        LHReceipt *r = _receipts[indexPath.row];
        if (r.longitude == 0 && r.latitude == 0) {
            LHReceiptModify2ViewController *vc = [[LHReceiptModify2ViewController alloc] init];
            vc.receipt = r;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [self requestSetDefault:r];
        }
    }
}

#pragma mark BMKPoiSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //        NSMutableArray *annotations = [NSMutableArray array];
        //        for (int i = 0; i < result.poiInfoList.count; i++) {
        //            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
        //            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        //            item.coordinate = poi.pt;
        //            item.title = poi.name;
        //            [annotations addObject:item];
        //        }
        //        [_mapView addAnnotations:annotations];
        //        [_mapView showAnnotations:annotations animated:YES];
        [_results removeAllObjects];
        [_results addObjectsFromArray:poiResult.poiInfoList];
        [_resultTableView reloadData];
    }
}

#pragma mark BMKLocationServiceDelegate
- (void)willStartLocatingUser {
    JXHUDProcessing(nil);
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [self.locateService stopUserLocationService];
    
    LHLocationNearbyViewController *vc = [[LHLocationNearbyViewController alloc] init];
    vc.coordinate = userLocation.location.coordinate;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didStopLocatingUser {
    JXHUDHide();
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    [self.locateService stopUserLocationService];
    if (kCLErrorDenied == error.code) {
        Alert(kStringTips, kStringLocationServiceIsRejectedPleaseToOpenInSetting);
    }else if (kCLErrorLocationUnknown == error.code) {
        Alert(kStringTips, @"信号太弱，开启WIFI、定位更好哟~");
    }else {
        Alert(kStringTips, error.localizedDescription);
    }
}

#pragma mark - Public methods
#pragma mark - Class methods

@end
