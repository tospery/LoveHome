//
//  UIViewController+JXApple.m
//  LoveHome
//
//  Created by 杨建祥 on 15/8/28.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "UIViewController+JXApple.h"

@implementation UIViewController (JXApple)
- (void)handleSuccessWithMode:(JXRequestMode)mode view:(UIView *)view {
    switch (mode) {
        case JXRequestModeSilent: {
            break;
        }
        case JXRequestModeLoad: {
            [JXLoadingView hideForView:view];
            break;
        }
        case JXRequestModeHUD: {
            JXHUDHide();
            break;
        }
        case JXRequestModeRefresh: {
            if (view && [view isKindOfClass:[UITableView class]]) {
                [[(UITableView *)view header] endRefreshing];
            }
            break;
        }
        case JXRequestModeMore: {
            if (view && [view isKindOfClass:[UITableView class]]) {
                [[(UITableView *)view footer] endRefreshing];
            }
            break;
        }
        default:
            break;
    }
}

- (void)handleFailureWithMode:(JXRequestMode)mode view:(UIView *)view error:(NSError *)error retry:(void (^)(void))retry {
    switch (mode) {
        case JXRequestModeSilent: {
            break;
        }
        case JXRequestModeLoad: {
            if (error) {
                [JXLoadingView showFailedAddedTo:view error:error retry:retry];
            }else {
                [JXLoadingView hideForView:view];
            }
            break;
        }
        case JXRequestModeHUD: {
            JXHUDHide();
            JXToast(error.localizedDescription);
            break;
        }
        case JXRequestModeRefresh: {
            if (view && [view isKindOfClass:[UITableView class]]) {
                [[(UITableView *)view header] endRefreshing];
            }
            if (error) {
                JXToast(error.localizedDescription);
            }
            break;
        }
        case JXRequestModeMore: {
            if (view && [view isKindOfClass:[UITableView class]]) {
                [[(UITableView *)view footer] endRefreshing];
            }
            if (error) {
                JXToast(error.localizedDescription);
            }
            break;
        }
        default:
            break;
    }
    
  }

- (void)handleSuccessForSlient {
    [self handleSuccessWithMode:JXRequestModeSilent view:nil];
}

- (void)handleFailureForSlient {
    [self handleFailureWithMode:JXRequestModeSilent view:nil error:nil retry:NULL];
}

- (void)handleSuccessForLoad:(UIView *)view {
    [self handleSuccessWithMode:JXRequestModeLoad view:view];
}

- (void)handleFailureForLoad:(UIView *)view error:(NSError *)error retry:(void (^)(void))retry {
    [self handleFailureWithMode:JXRequestModeLoad view:view error:error retry:retry];
}

- (void)handleSuccessForHUD {
    [self handleSuccessWithMode:JXRequestModeHUD view:nil];
}

- (void)handleFailureForHUD:(NSError *)error {
    [self handleFailureWithMode:JXRequestModeHUD view:nil error:error retry:NULL];
}

- (void)handleSuccessForRefresh:(UIView *)view {
    [self handleSuccessWithMode:JXRequestModeRefresh view:view];
}

- (void)handleFailureForRefresh:(UIView *)view error:(NSError *)error {
    [self handleFailureWithMode:JXRequestModeRefresh view:view error:error retry:NULL];
}

- (void)handleSuccessForMore:(UIView *)view {
    [self handleSuccessWithMode:JXRequestModeMore view:view];
}

- (void)handleFailureForMore:(UIView *)view error:(NSError *)error {
    [self handleFailureWithMode:JXRequestModeMore view:view error:error retry:NULL];
}
@end
