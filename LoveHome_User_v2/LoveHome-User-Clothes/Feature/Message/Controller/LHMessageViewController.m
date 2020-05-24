//
//  LHMessageViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/18.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHMessageViewController.h"
#import "LHMessageCell.h"

#define kLHMessageViewControllerOrderTag        (101)

@interface LHMessageViewController ()
@property (nonatomic, assign) BOOL isHScrolling;
@property (nonatomic, assign) CGRect tableRect;

@property (nonatomic, strong) JXPage *systemPage;
@property (nonatomic, strong) JXPage *orderPage;

@property (nonatomic, assign) BOOL onceToken;
//@property (nonatomic, assign) NSUInteger systemPage;
//@property (nonatomic, assign) NSUInteger orderPage;
@property (nonatomic, assign) CGFloat scrollViewHeight;
@property (nonatomic, strong) NSMutableArray *systemMessages;
@property (nonatomic, strong) NSMutableArray *orderMessages;
@property (nonatomic, weak) IBOutlet HMSegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UITableView *systemTableView;
@property (nonatomic, weak) IBOutlet UITableView *orderTableView;
@end

@implementation LHMessageViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [JXLoadViewManager setBackgroundColor:JXColorHex(0xF4F4F4)];
    [self initVar];
    [self initView];
    [self initDB];
    [self initNet];
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
#pragma mark init
- (void)initVar {
//    self.systemPage = 1;
//    self.orderPage = 1;
    _systemPage = [[JXPage alloc] init];
    _orderPage = [[JXPage alloc] init];
}

- (void)initView {
    self.navigationItem.title = @"信息中心";
    
    self.segmentedControl.sectionTitles = @[@"我的消息", @"订单助手"];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : ColorHex(0x666666), NSFontAttributeName: [UIFont systemFontOfSize:17]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : ColorHex(0x25BAB9), NSFontAttributeName: [UIFont systemFontOfSize:17]};
    self.segmentedControl.selectionIndicatorColor = ColorHex(0x25BAB9);
    self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.selectionIndicatorHeight = 1.5f;
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        if (NO == self.onceToken && 1 == index) {
            self.onceToken = YES;
            [self requestGetOrderMessagesWithMode:JXWebLaunchModeLoad];
        }
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(kScreenWidth * index, 0, kScreenWidth, weakSelf.scrollViewHeight) animated:YES];
    }];
    
    UINib *cellNib = [UINib nibWithNibName:@"LHMessageCell" bundle:nil];
    [self.systemTableView registerNib:cellNib forCellReuseIdentifier:[LHMessageCell identifier]];
    [self.orderTableView registerNib:cellNib forCellReuseIdentifier:[LHMessageCell identifier]];
    
    self.systemTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestGetSystemMessagesWithMode:JXWebLaunchModeRefresh];
    }];
    self.systemTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestGetSystemMessagesWithMode:JXWebLaunchModeMore];
    }];
    
    self.orderTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestGetOrderMessagesWithMode:JXWebLaunchModeRefresh];
    }];
    self.orderTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestGetOrderMessagesWithMode:JXWebLaunchModeMore];
    }];
}

- (void)initDB {
}

- (void)initNet {
    [self requestGetSystemMessagesWithMode:JXWebLaunchModeLoad];
}

#pragma mark - web
- (void)requestGetSystemMessagesWithMode:(JXWebLaunchMode)mode {
    switch (mode) {
        case JXWebLaunchModeLoad: {
            [JXLoadView showProcessingAddedTo:self.systemTableView rect:self.tableRect];
            [LHHTTPClient getMessagesWithType:1 page:1 rows:self.systemPage.pageSize success:^(AFHTTPRequestOperation *operation, LHMessageCollection *collection) {
                NSArray *messages = collection.messages;
                [self handleSuccessForTableView:self.systemTableView tableRect:self.tableRect mode:mode items:self.systemMessages page:_systemPage results:messages current:collection.currentPage total:collection.totalRows image:nil message:@"暂无消息" functitle:nil callback:NULL];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.systemTableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestGetSystemMessagesWithMode:mode];
                }];
            }];
            break;
        }
        case JXWebLaunchModeHUD: {
            break;
        }
        case JXWebLaunchModeRefresh: {
            [LHHTTPClient getMessagesWithType:1 page:1 rows:self.systemPage.pageSize success:^(AFHTTPRequestOperation *operation, LHMessageCollection *collection) {
                NSArray *messages = collection.messages;
                [self handleSuccessForTableView:self.systemTableView tableRect:self.tableRect mode:mode items:_systemMessages page:_systemPage results:messages current:collection.currentPage total:collection.totalRows image:nil message:@"暂无消息" functitle:nil callback:NULL];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.systemTableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestGetSystemMessagesWithMode:mode];
                }];
            }];
            break;
        }
        case JXWebLaunchModeMore: {
            [LHHTTPClient getMessagesWithType:1 page:(_systemPage.currentPage + 1) rows:_systemPage.pageSize success:^(AFHTTPRequestOperation *operation, LHMessageCollection *collection) {
                NSArray *messages = collection.messages;
                [self handleSuccessForTableView:self.systemTableView tableRect:self.tableRect mode:mode items:_systemMessages page:_systemPage results:messages current:collection.currentPage total:collection.totalRows image:nil message:nil functitle:nil callback:NULL];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.systemTableView rect:self.tableRect mode:mode way:JXWebHandleWayToast error:error callback:^{
                    [self.systemTableView.footer beginRefreshing];
                }];
            }];
            break;
        }
        default:
            break;
    }
}

- (void)requestGetOrderMessagesWithMode:(JXWebLaunchMode)mode {
    switch (mode) {
        case JXWebLaunchModeLoad: {
            [JXLoadView showProcessingAddedTo:self.orderTableView rect:self.tableRect];
            [LHHTTPClient getMessagesWithType:2 page:1 rows:_orderPage.pageSize success:^(AFHTTPRequestOperation *operation, LHMessageCollection *collection) {
                NSArray *messages = collection.messages;
                [self handleSuccessForTableView:self.orderTableView tableRect:self.tableRect mode:mode items:self.orderMessages page:_orderPage results:messages current:collection.currentPage total:collection.totalRows image:nil message:@"暂无消息" functitle:nil callback:NULL];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.orderTableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestGetOrderMessagesWithMode:mode];
                }];
            }];
            break;
        }
        case JXWebLaunchModeHUD: {
            break;
        }
        case JXWebLaunchModeRefresh: {
            [LHHTTPClient getMessagesWithType:2 page:1 rows:_orderPage.pageSize success:^(AFHTTPRequestOperation *operation, LHMessageCollection *collection) {
                NSArray *messages = collection.messages;
                [self handleSuccessForTableView:self.orderTableView tableRect:self.tableRect mode:mode items:_orderMessages page:_orderPage results:messages current:collection.currentPage total:collection.totalRows image:nil message:@"暂无消息" functitle:nil callback:NULL];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.orderTableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestGetOrderMessagesWithMode:mode];
                }];
            }];
            break;
        }
        case JXWebLaunchModeMore: {
            [LHHTTPClient getMessagesWithType:2 page:(_orderPage.currentPage + 1) rows:(_orderPage.pageSize) success:^(AFHTTPRequestOperation *operation, LHMessageCollection *collection) {
                NSArray *messages = collection.messages;
                [self handleSuccessForTableView:self.orderTableView tableRect:self.tableRect mode:mode items:_orderMessages page:_orderPage results:messages current:collection.currentPage total:collection.totalRows image:nil message:nil functitle:nil callback:NULL];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.orderTableView rect:self.tableRect mode:mode way:JXWebHandleWayToast error:error callback:^{
                    [self.orderTableView.footer beginRefreshing];
                }];
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Accessor methods
- (CGFloat)scrollViewHeight {
    if (0 == _scrollViewHeight) {
        _scrollViewHeight = kScreenHeight - 64 - 44;
    }
    return _scrollViewHeight;
}

- (NSMutableArray *)systemMessages {
    if (!_systemMessages) {
        _systemMessages = [NSMutableArray arrayWithCapacity:10];
    }
    return _systemMessages;
}

- (NSMutableArray *)orderMessages {
    if (!_orderMessages) {
        _orderMessages = [NSMutableArray arrayWithCapacity:10];
    }
    return _orderMessages;
}

- (CGRect)tableRect {
    if (CGRectEqualToRect(_tableRect, CGRectZero)) {
        _tableRect = CGRectMake(0, 0, kJXScreenWidth, kJXScreenHeight - 64 - 44);
    }
    return _tableRect;
}

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (kLHMessageViewControllerOrderTag == tableView.tag) {
        return self.orderMessages.count;
    }
    return self.systemMessages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LHMessage *message;
    if (kLHMessageViewControllerOrderTag == tableView.tag) {
        message = self.orderMessages[indexPath.row];
    }else {
        message = self.systemMessages[indexPath.row];
    }
    return [LHMessageCell heightForMessage:message];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHMessageCell identifier]];
    LHMessage *message;
    if (kLHMessageViewControllerOrderTag == tableView.tag) {
        message = self.orderMessages[indexPath.row];
    }else {
        message = self.systemMessages[indexPath.row];
    }
    [(LHMessageCell *)cell setMessage:message];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
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
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
    if (NO == self.onceToken && 1 == page) {
        self.onceToken = YES;
        [self requestGetOrderMessagesWithMode:JXWebLaunchModeLoad];
    }
}
@end
