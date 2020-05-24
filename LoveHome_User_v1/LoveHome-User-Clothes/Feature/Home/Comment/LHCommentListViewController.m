//
//  LHCommentViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/18.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHCommentListViewController.h"
#import "LHCommentCell.h"

@interface LHCommentListViewController ()
@property (nonatomic, assign) NSInteger shopid;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) LHCommentCollection *commentCollection;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation LHCommentListViewController
#pragma mark update
#pragma mark fetch
#pragma mark web
#pragma mark assist
#pragma mark - Accessor methods
#pragma mark - Action methods
#pragma mark - Notification methods

#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initVar];
    [self initView];
    [self initDB];
    [self initNet];
}

#pragma mark - Private methods
#pragma mark init
- (void)initVar {
    self.comments = [NSMutableArray arrayWithCapacity:10];
}

- (void)initView {
    self.navigationItem.title = @"评论";
    
    UINib *cellNib = [UINib nibWithNibName:@"LHCommentCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:[LHCommentCell identifier]];
    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kJXIdentifierHeaderFooter];
    self.tableView.sectionFooterHeight = 12.0f;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self webGetCommentsWithMode:JXWebLaunchModeRefresh];
    }];
}

- (void)initDB {
}

- (void)initNet {
    [self webGetCommentsWithMode:JXWebLaunchModeLoad];
}

#pragma mark web
- (void)webGetCommentsWithMode:(JXWebLaunchMode)mode {
    switch (mode) {
        case JXWebLaunchModeLoad: {
            [JXLoadView showProcessingAddedTo:self.view rect:CGRectZero];
            [LHHTTPClient queryShopCommentsWithShopId:self.shopid page:1 rows:20 success:^(AFHTTPRequestOperation *operation, LHCommentCollection *commentCollection) {
                if (0 == commentCollection.totalRows) {
                    [JXLoadView showResultAddedTo:self.view rect:CGRectZero image:nil message:@"该店铺还没有评论" functitle:nil callback:NULL];
                }else {
                    [JXLoadView hideForView:self.view];
                    
                    self.navigationItem.title = [NSString stringWithFormat:@"评价（%@）", @(commentCollection.totalRows)];
                    
                    self.page = commentCollection.currentPage;
                    if (self.page < commentCollection.totalPages) {
                        self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                            [self webGetCommentsWithMode:JXWebLaunchModeMore];
                        }];
                    }
                    [self.comments exInsertObjects:commentCollection.comments atIndex:self.comments.count unduplicated:YES];
                    [self.tableView reloadData];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self webGetCommentsWithMode:mode];
                }];
                self.navigationItem.title = @"评论（0）";
            }];
            break;
        }
        case JXWebLaunchModeRefresh: {
            [LHHTTPClient queryShopCommentsWithShopId:self.shopid page:1 rows:20 success:^(AFHTTPRequestOperation *operation, LHCommentCollection *commentCollection) {
                [self.tableView.header endRefreshing];
                [self.comments exInsertObjects:commentCollection.comments atIndex:0 unduplicated:YES];
                [self.tableView reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self webGetCommentsWithMode:mode];
                }];
                [self.tableView.header endRefreshing];
            }];
            break;
        }
        case JXWebLaunchModeMore: {
            [LHHTTPClient queryShopCommentsWithShopId:self.shopid page:++self.page rows:20 success:^(AFHTTPRequestOperation *operation, LHCommentCollection *commentCollection) {
                [self.tableView.footer endRefreshing];
                
                self.page = commentCollection.currentPage;
                if (self.page >= commentCollection.totalPages) {
                    [self.tableView.footer noticeNoMoreData];
                }
                
                [self.comments exInsertObjects:commentCollection.comments atIndex:self.comments.count unduplicated:YES];
                [self.tableView reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self webGetCommentsWithMode:mode];
                }];
                [self.tableView.footer endRefreshing];
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Public methods
- (instancetype)initWithShopid:(NSInteger)shopid {
    if (self = [self init]) {
        _shopid = shopid;
    }
    return self;
}

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LHCommentCell heightForComment:self.comments[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHCommentCell identifier]];
    [(LHCommentCell *)cell setComment:self.comments[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kJXIdentifierHeaderFooter];
    return view;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

@end
