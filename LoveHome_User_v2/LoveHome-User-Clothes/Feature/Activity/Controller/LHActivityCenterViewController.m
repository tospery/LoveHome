//
//  LHActivityCenterViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/1.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import "LHActivityCenterViewController.h"
#import "LHActivityCenterCell.h"
#import "LHActivity.h"
#import "LHShopListViewController.h"

@interface LHActivityCenterViewController ()
@property (nonatomic, strong) JXPage *page;
@property (nonatomic, assign) CGRect tableRect;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation LHActivityCenterViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVar];
    [self setupView];
    [self setupDB];
    [self setupNet];
}


#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
    _tableRect = CGRectMake(0, 0, kJXScreenWidth, kJXScreenHeight - 64);
    _page = [[JXPage alloc] init];
    _items = [NSMutableArray array];
}

- (void)setupView {
    self.navigationItem.title = @"活动专区";
    
    UINib *cellNib = [UINib nibWithNibName:@"LHActivityCenterCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:[LHActivityCenterCell identifier]];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestShopsWithMode:JXWebLaunchModeRefresh];
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestShopsWithMode:JXWebLaunchModeMore];
    }];
}

- (void)setupDB {
}

- (void)setupNet {
    [self requestShopsWithMode:JXWebLaunchModeLoad];
}

#pragma mark fetch

#pragma mark request
- (void)requestShopsWithMode:(JXWebLaunchMode)mode {
    switch (mode) {
        case JXWebLaunchModeLoad: {
            [JXLoadView showProcessingAddedTo:self.tableView rect:self.tableRect];
            [LHHTTPClient getActivityCenterWithCurrentPage:1 pageSize:_page.pageSize success:^(AFHTTPRequestOperation *operation, LHActivityCenterList *list) {
                [self handleSuccessForTableView:self.tableView tableRect:self.tableRect mode:mode items:_items page:_page results:list.activities current:list.currentPage total:list.totalRows image:nil message:@"敬请期待" functitle:nil callback:NULL];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestShopsWithMode:mode];
                }];
            }];
            break;
        }
        case JXWebLaunchModeRefresh: {
            [LHHTTPClient getActivityCenterWithCurrentPage:1 pageSize:_page.pageSize success:^(AFHTTPRequestOperation *operation, LHActivityCenterList *list) {
                [self handleSuccessForTableView:self.tableView tableRect:self.tableRect mode:mode items:_items page:_page results:list.activities current:list.currentPage total:list.totalRows image:nil message:@"敬请期待" functitle:nil callback:NULL];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestShopsWithMode:mode];
                }];
            }];
            break;
        }
        case JXWebLaunchModeMore: {
            [LHHTTPClient getActivityCenterWithCurrentPage:(self.page.currentPage + 1) pageSize:_page.pageSize success:^(AFHTTPRequestOperation *operation, LHActivityCenterList *list) {
                [self handleSuccessForTableView:self.tableView tableRect:self.tableRect mode:mode items:_items page:_page results:list.activities current:list.currentPage total:list.totalRows image:nil message:@"没有更多活动" functitle:nil callback:NULL];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestShopsWithMode:mode];
                }];
            }];
            break;
        }
        default:
            break;
    }
}


#pragma mark assist

#pragma mark - Accessor methods
#pragma mark - Action methods
#pragma mark - Notification methods


#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LHActivityCenterCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LHActivityCenterCell *cell = (LHActivityCenterCell *)[tableView dequeueReusableCellWithIdentifier:[LHActivityCenterCell identifier]];
    cell.ac = self.items[indexPath.row];
    return cell;
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LHActivityCenter *ac = self.items[indexPath.row];
    
    LHActivity *at = [LHActivity new];
    at.activityid = JXStringFromInteger(ac.activityId);
    at.activitytitle = ac.activityTitle;
    
    LHShopListViewController *listVC = [[LHShopListViewController alloc] init];
    listVC.from = LHEntryFromActivity;
    listVC.activity = at;
    [self.navigationController pushViewController:listVC animated:YES];
}

#pragma mark - Public methods
#pragma mark - Class methods

@end
