//
//  LHLocationNearbyViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/21.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import "LHLocationNearbyViewController.h"

@interface LHLocationNearbyViewController ()
@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;
@property (nonatomic, strong) NSArray *results;
@property (nonatomic, weak) IBOutlet UITableView *resultTableView;
@property (nonatomic, assign) CGRect tableRect;
@end

@implementation LHLocationNearbyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"您周围的地址列表";
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    _tableRect = CGRectMake(0, 0, kJXScreenWidth, kJXScreenHeight - 64);
    _resultTableView.tableFooterView = [[UIView alloc] init];
    
    [self requestNearbyPoints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _geocodesearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _geocodesearch.delegate = nil;
}

- (void)dealloc {
    _geocodesearch = nil;
}

- (void)requestNearbyPoints {
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = _coordinate;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if (flag) {
        [JXLoadView showProcessingAddedTo:_resultTableView rect:_tableRect];
    }else {
        Toast(@"检索失败");
    }
}


#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _results.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BMKPoiInfo *poi = _results[indexPath.row];
    gLH.receipt = [[LHReceipt alloc] init];
    gLH.receipt.receiptID = @"-77";
    gLH.receipt.longitude = poi.pt.longitude;
    gLH.receipt.latitude = poi.pt.latitude;
    gLH.receipt.address = poi.name;
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark BMKPoiSearchDelegate
//- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode {
//    if (errorCode == BMK_SEARCH_NO_ERROR) {
//        [_results removeAllObjects];
//        [_results addObjectsFromArray:poiResult.poiInfoList];
//        [_resultTableView reloadData];
//    }
//}

#pragma mark BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == 0) {
        _results = result.poiList;
        [_resultTableView reloadData];
    }else {
        Toast(@"检索失败");
    }
    [JXLoadView hideForView:_resultTableView];
}

@end
