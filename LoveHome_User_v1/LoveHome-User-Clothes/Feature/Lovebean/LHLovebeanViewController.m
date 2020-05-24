//
//  LHLovebeanViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/31.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHLovebeanViewController.h"
#import "LHLovebeanFlowCell.h"

#define kLHLovebeanRuneAnimation        (@"kLHLovebeanRuneAnimation")

@interface LHLovebeanViewController ()
@property (nonatomic, weak) IBOutlet UIButton *signButton;
@property (nonatomic, assign) BOOL onceToken;
@property (nonatomic, strong) JXPage *page;
@property (nonatomic, strong) NSMutableArray *flows;
@property (nonatomic, assign) CGRect tableRect;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UILabel *moneyLabel;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation LHLovebeanViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [JXLoadViewManager setBackgroundColor:JXColorHex(0xF4F4F4)];
    [self setupView];
    [self setupNet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [JXLoadViewManager setBackgroundColor:JXColorHex(0xF4F4F4)];
    
    if (_onceToken) {
        [_moneyLabel setHidden:YES];
        [self starAnimationFrom:0 to:gLH.user.info.loveBean];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [JXLoadViewManager setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupView {
    self.navigationItem.title = @"我的爱豆";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"使用规则" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed:)];
    
    UINib *cellNib = [UINib nibWithNibName:@"LHLovebeanFlowCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:[LHLovebeanFlowCell identifier]];
    
    self.moneyLabel.layer.transform = CATransform3DMakeScale(0.5f, 0.5f, 1.f);
    
    [_signButton setBackgroundImage:[UIImage exImageWithColor:JXColorHex(0xCCCCCC)] forState:UIControlStateDisabled];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestFlowsWithMode:JXWebLaunchModeRefresh];
    }];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestFlowsWithMode:JXWebLaunchModeMore];
    }];
}

- (void)setupNet {
    [self requestFlowsWithMode:JXWebLaunchModeLoad];
}

- (IBAction)signButtonPressed:(id)sender {
    [self requestSignWithMode:JXWebLaunchModeHUD];
}

- (void)requestSignWithMode:(JXWebLaunchMode)mode {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient getLovebeanSignWithSuccess:^(AFHTTPRequestOperation *operation, LHLovebeanSign *sign) {
        JXHUDHide();
        
        if (sign.increaseLoveBeans != 0) {
            [_moneyLabel setHidden:YES];
            [self starAnimationFrom:gLH.user.info.loveBean to:sign.totalLoveBeans];
            gLH.user.info.loveBean = sign.totalLoveBeans;
            
            [_signButton setEnabled:NO];
            [_signButton exSetBorder:[UIColor clearColor] width:1.0 radius:4.0];
            
            [self.tableView.header beginRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestSignWithMode:mode];
        }];
    }]];
}

#pragma mark request
- (void)requestFlowsWithMode:(JXWebLaunchMode)mode {
    switch (mode) {
        case JXWebLaunchModeLoad: {
//            [JXLoadView showProcessingAddedTo:self.tableView rect:self.tableRect];
//            [self.operaters exAddObject:
//             [LHHTTPClient getLovebeanFlowsWithPage:1 size:self.page.pageSize success:^(AFHTTPRequestOperation *operation, LHLovebeanWrapperCollection *collection) {
//                NSArray *flows = [(LHLovebeanWrapper *)[collection.lovebeanWrappers objectAtIndex:0] flows];
//                [self handleSuccessForTableView:self.tableView tableRect:self.tableRect mode:mode items:self.flows page:self.page results:flows current:collection.currentPage total:collection.totalRows image:nil message:kStringNoLovebean functitle:nil callback:NULL];
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                [self handleFailureForView:self.tableView rect:self.tableRect mode:JXWebLaunchModeLoad way:JXWebHandleWayShow error:error callback:^{
//                    [self requestFlowsWithMode:mode];
//                }];
//            }]];
            
            [JXLoadView showProcessingAddedTo:self.view rect:CGRectZero];
            [self.operaters exAddObject:
             [LHHTTPClient getLovebeanFlowsWithPage:1 size:self.page.pageSize success:^(AFHTTPRequestOperation *operation, LHLovebeanWrapperCollection *collection) {
                [JXLoadView hideForView:self.view];
                
                LHLovebeanWrapper *wrapper = (LHLovebeanWrapper *)[collection.lovebeanWrappers objectAtIndex:0];
                self.page.currentPage = collection.currentPage;
                if (wrapper.flows.count < collection.totalRows) {
                    [self.tableView.footer resetNoMoreData];
                }else {
                    [self.tableView.footer noticeNoMoreData];
                }
                
                if (wrapper.signedToday) {
                    [_signButton setEnabled:NO];
                    [_signButton exSetBorder:[UIColor clearColor] width:1.0 radius:4.0];
                }else {
                    [_signButton setEnabled:YES];
                    [_signButton exSetBorder:JXColorHex(0x25b9b9) width:1.0 radius:4.0];
                }
                
                _onceToken = YES;
                [_moneyLabel setHidden:YES];
                gLH.user.info.loveBean = wrapper.loveBeansNumber;
                [self starAnimationFrom:0 to:gLH.user.info.loveBean];
                
                [self.flows removeAllObjects];
                [self.flows addObjectsFromArray:wrapper.flows];
                [self.tableView reloadData];
                
                if (self.flows.count == 0) {
                    [JXLoadView showResultAddedTo:self.tableView rect:self.tableRect image:nil message:kStringNoLovebean functitle:nil callback:NULL];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestFlowsWithMode:mode];
                }];
            }]];
            break;
        }
        case JXWebLaunchModeRefresh: {
            [self.operaters exAddObject:
             [LHHTTPClient getLovebeanFlowsWithPage:1 size:self.page.pageSize success:^(AFHTTPRequestOperation *operation, LHLovebeanWrapperCollection *collection) {
                [JXLoadView hideForView:self.tableView];
                NSArray *flows = [(LHLovebeanWrapper *)[collection.lovebeanWrappers objectAtIndex:0] flows];
                [self handleSuccessForTableView:self.tableView tableRect:self.tableRect mode:mode items:self.flows page:self.page results:flows current:collection.currentPage total:collection.totalRows image:nil message:kStringNoLovebean functitle:nil callback:NULL];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayToast error:error callback:^{
                    [self.tableView.header beginRefreshing];
                }];
            }]];
            break;
        }
        case JXWebLaunchModeMore: {
            [self.operaters exAddObject:
             [LHHTTPClient getLovebeanFlowsWithPage:(self.page.currentPage + 1) size:self.page.pageSize success:^(AFHTTPRequestOperation *operation, LHLovebeanWrapperCollection *collection) {
                [JXLoadView hideForView:self.tableView];
                NSArray *flows = [(LHLovebeanWrapper *)[collection.lovebeanWrappers objectAtIndex:0] flows];
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

#pragma mark fetch
- (void)starAnimationFrom:(NSInteger)from to:(NSInteger)to {
    [self.countLabel pop_removeAnimationForKey:kLHLovebeanRuneAnimation];
    
    POPBasicAnimation *anim = [POPBasicAnimation animation];
    anim.duration = 1.0;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    POPAnimatableProperty * prop = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.readBlock = ^(id obj, CGFloat values[]) {
            values[0] = [[obj description] floatValue];
        };
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            [obj setText:[NSString stringWithFormat:@"%.f",values[0]]];
        };
        prop.threshold = 0.01;
    }];
    
    anim.property = prop;
    anim.fromValue = @(from);
    anim.toValue = @(to);
    [self.countLabel pop_addAnimation:anim forKey:kLHLovebeanRuneAnimation];
    
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            self.moneyLabel.text = [NSString stringWithFormat:@"可抵扣%.2f元", (CGFloat)gLH.user.info.loveBean / 100.0f];
            [self.moneyLabel setHidden:NO];
            [self showMoneyLabel];
        }
    }];
}

- (void)showMoneyLabel {
    self.moneyLabel.layer.opacity = 1.0;
    POPSpringAnimation *layerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.springBounciness = 18;
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.moneyLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"labelScaleAnimation"];
    
    POPSpringAnimation *layerPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.countLabel.layer.position.y + self.countLabel.intrinsicContentSize.height);
    layerPositionAnimation.springBounciness = 12;
    [self.moneyLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
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
    JXWebViewController *webVC = [[JXWebViewController alloc] initWithURLString:kHTTPLovebean];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LHLovebeanFlowCell height];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.flows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHLovebeanFlowCell identifier]];
    [(LHLovebeanFlowCell *)cell setFlow:self.flows[indexPath.row]];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Public methods
#pragma mark - Class methods

@end
