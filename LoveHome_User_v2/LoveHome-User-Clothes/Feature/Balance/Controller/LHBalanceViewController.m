//
//  LHBalanceViewController2.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/2.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHBalanceViewController.h"
#import "LHBalanceFlowCell.h"
#import "LHRechargeViewController.h"

#define kLHBalanceAnimRune          (@"kLHBalanceAnimRune")

@interface LHBalanceViewController ()
//@property (nonatomic, assign) BOOL onceToken;
@property (nonatomic, assign) CGRect tableRect;

@property (nonatomic, strong) JXPage *page;
@property (nonatomic, strong) NSMutableArray *flows;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *moneyBgView;
@property (nonatomic, weak) IBOutlet UILabel *moneyCountLable;

@end

@implementation LHBalanceViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [JXLoadViewManager setBackgroundColor:JXColorHex(0xF4F4F4)];
    [self setupView];
    [self setupNet];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [JXLoadViewManager setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [JXLoadViewManager setBackgroundColor:JXColorHex(0xF4F4F4)];
    
//    if (!self.onceToken) {
//        self.onceToken = YES;
        [self starAnimationFrom:0 to:gLH.user.info.accountBalance];
        [self scaleViewAnimation];
    //}
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupView {
    self.navigationItem.title = @"我的账户余额";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"充值" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed:)];
    
    UINib *cellNib = [UINib nibWithNibName:@"LHBalanceFlowCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:[LHBalanceFlowCell identifier]];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestFlowsWithMode:JXWebLaunchModeRefresh];
    }];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestFlowsWithMode:JXWebLaunchModeMore];
    }];
    
    self.moneyBgView.clipsToBounds = YES;
    self.moneyBgView.layer.cornerRadius = self.moneyBgView.bounds.size.width / 2.0;
    self.moneyBgView.layer.borderColor = JXColorHex(0x25BAB9).CGColor;
    self.moneyBgView.layer.borderWidth = 3.2f;
    self.moneyBgView.transform = CGAffineTransformMakeScale(0.7, 0.7);
}

- (void)setupNet {
    [self requestFlowsWithMode:JXWebLaunchModeLoad];
}

#pragma mark fetch
#pragma mark request
- (void)requestFlowsWithMode:(JXWebLaunchMode)mode {
    switch (mode) {
        case JXWebLaunchModeLoad: {
            [self.operaters exAddObject:
             [LHHTTPClient getBalanceFlowsWithPage:1 size:self.page.pageSize success:^(AFHTTPRequestOperation *operation, LHBalanceFlowCollection *collection) {
                NSArray *flows = collection.balanceFlows;
                [self handleSuccessForTableView:self.tableView tableRect:self.tableRect mode:mode items:self.flows page:self.page results:flows current:collection.currentPage total:collection.totalRows image:nil message:kStringNoBalanceFlows functitle:nil callback:NULL];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.tableView rect:self.tableRect mode:JXWebLaunchModeLoad way:JXWebHandleWayShow error:error callback:^{
                    [self requestFlowsWithMode:mode];
                }];
            }]];
            break;
        }
        case JXWebLaunchModeRefresh: {
            [self.operaters exAddObject:
             [LHHTTPClient getBalanceFlowsWithPage:1 size:self.page.pageSize success:^(AFHTTPRequestOperation *operation, LHBalanceFlowCollection *collection) {
                NSArray *flows = collection.balanceFlows;
                [self handleSuccessForTableView:self.tableView tableRect:self.tableRect mode:mode items:self.flows page:self.page results:flows current:collection.currentPage total:collection.totalRows image:nil message:kStringNoBalanceFlows functitle:nil callback:NULL];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayToast error:error callback:^{
                    [self.tableView.header beginRefreshing];
                }];
            }]];
            break;
        }
        case JXWebLaunchModeMore: {
            [self.operaters exAddObject:
             [LHHTTPClient getBalanceFlowsWithPage:(self.page.currentPage + 1) size:self.page.pageSize success:^(AFHTTPRequestOperation *operation, LHBalanceFlowCollection *collection) {
                NSArray *flows = collection.balanceFlows;
                [self handleSuccessForTableView:self.tableView tableRect:self.tableRect mode:mode items:self.flows page:self.page results:flows current:collection.currentPage total:collection.totalRows image:nil message:nil functitle:nil callback:NULL];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.tableView rect:self.tableRect mode:JXWebLaunchModeMore way:JXWebHandleWayToast error:error callback:^{
                    [self.tableView.footer beginRefreshing];
                }];
            }]];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark assist
- (void)starAnimationFrom:(CGFloat)from to:(CGFloat)to {
    [self.moneyCountLable pop_removeAnimationForKey:kLHBalanceAnimRune];
    
    POPBasicAnimation *anim = [POPBasicAnimation animation];
    anim.duration = 1.0;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    POPAnimatableProperty * prop = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.readBlock = ^(id obj, CGFloat values[]) {
            values[0] = [[obj description] floatValue];
        };
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            [obj setText:[NSString stringWithFormat:@"%.2f",values[0]]];
        };
        prop.threshold = 0.01;
    }];
    
    anim.property = prop;
    anim.fromValue = @(from);
    anim.toValue = @(to);
    
    [self.moneyCountLable pop_addAnimation:anim forKey:kLHBalanceAnimRune];
}

- (void)scaleViewAnimation {
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.moneyBgView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

#pragma mark - Accessor methods
- (NSMutableArray *)flows {
    if (!_flows) {
        _flows = [NSMutableArray array];
    }
    return _flows;
}

- (CGRect)tableRect {
    if (CGRectEqualToRect(_tableRect, CGRectZero)) {
        _tableRect = CGRectMake(0, 0, kJXScreenWidth, kJXScreenHeight - 64 - 170);
    }
    return _tableRect;
}

- (JXPage *)page {
    if (!_page) {
        _page = [[JXPage alloc] init];
    }
    return _page;
}

#pragma mark - Action methods
- (void)rightItemPressed:(id)sender {
    LHRechargeViewController *vc = [[LHRechargeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.flows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LHBalanceFlowCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHBalanceFlowCell identifier]];
    [(LHBalanceFlowCell *)cell setFlow:self.flows[indexPath.row]];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

#pragma mark - Public methods
#pragma mark - Class methods

@end
