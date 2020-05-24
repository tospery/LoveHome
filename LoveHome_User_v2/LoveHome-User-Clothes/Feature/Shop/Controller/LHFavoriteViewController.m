//
//  LHShopFollowViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/26.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHFavoriteViewController.h"
#import "LHShopFavoriteCell.h"
#import "LHShopDetailViewController.h"

@interface LHFavoriteViewController ()
@property (nonatomic, strong) NSMutableArray *favorites;
@property (nonatomic, assign) CGRect tableRect;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation LHFavoriteViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self initNet];
}

#pragma mark - Private methods
#pragma mark init
- (void)initView {
    self.navigationItem.title = @"关注店铺";
    
    UINib *cellNib = [UINib nibWithNibName:@"LHShopFavoriteCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:[LHShopFavoriteCell identifier]];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestFavoritesWithMode:JXWebLaunchModeRefresh];
    }];
}

- (void)initNet {
    [self requestFavoritesWithMode:JXWebLaunchModeLoad];
}

#pragma mark web
- (void)requestFavoritesWithMode:(JXWebLaunchMode)mode {
    switch (mode) {
        case JXWebLaunchModeLoad: {
            [JXLoadView showProcessingAddedTo:self.tableView rect:self.tableRect];
            [self.operaters exAddObject:
             [LHHTTPClient getFavoritesWithLatitude:gLH.receipt.latitude longitude:gLH.receipt.longitude success:^(AFHTTPRequestOperation *operation, NSArray *favorites) {
                [self handleSuccessForTableView:self.tableView tableRect:self.tableRect mode:mode items:self.favorites page:nil results:favorites current:0 total:0 image:nil message:@"没有收藏的店铺" functitle:nil callback:NULL];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestFavoritesWithMode:mode];
                }];
            }]];
            break;
        }
        case JXWebLaunchModeRefresh: {
            [self.operaters exAddObject:
             [LHHTTPClient getFavoritesWithLatitude:gLH.receipt.latitude longitude:gLH.receipt.longitude success:^(AFHTTPRequestOperation *operation, NSArray *favorites) {
                [self handleSuccessForTableView:self.tableView tableRect:self.tableRect mode:mode items:self.favorites page:nil results:favorites current:0 total:0 image:nil message:@"没有收藏的店铺" functitle:nil callback:NULL];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayShow error:error callback:^{
                    [self requestFavoritesWithMode:mode];
                }];
            }]];
            break;
        }
        default:
            break;
    }
}

- (void)requestDeleteWithMode:(JXWebLaunchMode)mode indexPath:(NSIndexPath *)indexPath {
    LHFavorite *f = _favorites[indexPath.row];
    
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient requestFavoriteDeleteWithFavoriteId:[NSString stringWithFormat:@"%ld", (long)f.uid] success:^(AFHTTPRequestOperation *operation, id response) {
        JXHUDHide();
        [_favorites removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if (gLH.user.info.shopCount >= 1) {
            gLH.user.info.shopCount -= 1;
        }
        
        if (_favorites.count == 0) {
            [JXLoadView showResultAddedTo:self.tableView rect:self.tableRect image:nil message:@"没有收藏的店铺" functitle:nil callback:NULL];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestDeleteWithMode:mode indexPath:indexPath];
        }];
    }]];
}

#pragma mark - Accessor methods
- (NSMutableArray *)favorites {
    if (!_favorites) {
        _favorites = [NSMutableArray array];
    }
    return _favorites;
}

- (CGRect)tableRect {
    if (CGRectEqualToRect(_tableRect, CGRectZero)) {
        _tableRect = CGRectMake(0, 0, kJXScreenWidth, kJXScreenHeight - 64);
    }
    return _tableRect;
}

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    return rightUtilityButtons;
}

#pragma mark - Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favorites.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LHShopFavoriteCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHShopFavoriteCell identifier]];
    [(LHShopFavoriteCell *)cell setFavorite:self.favorites[indexPath.row]];
    [(LHShopFavoriteCell *)cell setRightUtilityButtons:[self rightButtons]];
    [(LHShopFavoriteCell *)cell setDelegate:self];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LHFavorite *favorite = self.favorites[indexPath.row];
    if (2 == favorite.sleeping) {
        JXToast(@"主人，店家去月球度假了，请移步别家~");
        return;
    }
    
    //    if (favorite.distance >= 3000) {
    //        JXToast(@"怪我咯！超过服务范围，求反馈~");
    //        return;
    //    }
    
    //    if (favorite.freeze == 2) {
    //        JXToast(@"这家店不乖，被关小黑屋了~");
    //    }else if (favorite.freeze == 4) {
    //        JXToast(@"主人，店主回高老庄去了，请移步别家~");
    //    }else if (favorite.freeze == 5) {
    //        JXToast(@"主人，店家去月球度假了，请移步别家~");
    //    }else {
    LHShopDetailViewController *detailVC = [[LHShopDetailViewController alloc] initWithShopid:favorite.shopId];
    detailVC.from = LHEntryFromFavorite;
    detailVC.distanceForFavorite = favorite.distance;
    if (favorite.coverage != -1) {
        if (favorite.distance > (favorite.coverage * 1000)) {
            detailVC.outOfService = YES;
        }
    }
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //}
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state {
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            [self requestDeleteWithMode:JXWebLaunchModeHUD indexPath:[self.tableView indexPathForCell:cell]];
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return NO;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    return YES;
}
@end
