//
//  LHLocationSearchViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/18.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import "LHLocationSearchViewController.h"

@interface LHLocationSearchViewController ()
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) BMKPoiSearch *poisearch;
@property (nonatomic, weak) IBOutlet UITextField *keywordTextField;
@property (nonatomic, weak) IBOutlet UITableView *resultTableView;
@property (nonatomic, assign) CGRect tableRect;
@end

@implementation LHLocationSearchViewController
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
    [_keywordTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _poisearch.delegate = nil;
}

- (void)dealloc {
    _poisearch = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
    _tableRect = CGRectMake(0, 0, kJXScreenWidth, kJXScreenHeight - 64 - kJXScreenWidth / 320.0f * 54);
    _results = [NSMutableArray array];
    _poisearch = [[BMKPoiSearch alloc] init];
}

- (void)setupView {
    self.navigationItem.title = @"成都市";
    
    _resultTableView.tableFooterView = [[UIView alloc] init];
}

- (void)setupDB {
}

- (void)setupNet {
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyAddressChoosed object:poi];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark BMKPoiSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        [_results removeAllObjects];
        [_results addObjectsFromArray:poiResult.poiInfoList];
        [_resultTableView reloadData];
    }
}
@end














