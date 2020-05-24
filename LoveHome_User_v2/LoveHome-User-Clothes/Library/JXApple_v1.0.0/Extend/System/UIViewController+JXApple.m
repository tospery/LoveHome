//
//  UIViewController+JXApple.m
//  iOSLibrary
//
//  Created by 杨建祥 on 15/8/19.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "UIViewController+JXApple.h"
#import "JXApple.h"

@implementation UIViewController (JXApple)
- (void)showLoginIfTokenInvalidWithError:(NSError *)error
                                  finish:(JXLoginResultCallback)finish {
#ifdef JXEnableForApp
    [[LHLoginViewController sharedController] loginIfNeedWithTarget:self error:error willPresent:NULL didPresented:NULL willCancel:NULL didCancelled:NULL willFinish:NULL didFinished:^{
        if (finish) {
            finish(YES);
        }
    } hasLoginned:^{
        if (finish) {
            finish(NO);
        }
    }];
#else
    JXAlert(@"待实现", @"showLoginIfNotLoginedWithFinish:^()Block");
#endif
}

- (void)showLoginIfNotLoginedWithFinish:(JXLoginDidPassOrReloginDidFinishCallback)finish {
    [self showLoginIfTokenInvalidWithError:nil didPresent:NULL didPass:finish reloginWillFinish:NULL reloginDidFinish:finish];
}

- (void)showLoginIfNotLoginedWithFinish:(JXLoginReloginDidFinishCallback)finish pass:(JXLoginDidPassCallback)pass {
    [self showLoginIfTokenInvalidWithError:nil didPresent:NULL didPass:pass reloginWillFinish:NULL reloginDidFinish:finish];
}

- (void)showLoginIfTokenInvalidWithError:(NSError *)error didPresent:(JXLoginDidPresentCallback)didPresent didPass:(JXLoginDidPassCallback)didPass reloginWillFinish:(JXLoginReloginWillFinishCallback)reloginWillFinish reloginDidFinish:(JXLoginReloginDidFinishCallback)reloginDidFinish {
#ifdef JXEnableForApp
    [[LHLoginViewController sharedController] loginIfNeedWithTarget:self error:error willPresent:NULL didPresented:^{
        if (didPresent) {
            didPresent();
        }
    } willCancel:NULL didCancelled:NULL willFinish:^{
        if (reloginWillFinish) {
            reloginWillFinish();
        }
    } didFinished:^{
        if (reloginDidFinish) {
            reloginDidFinish();
        }
    } hasLoginned:^{
        if (didPass) {
            didPass();
        }
    }];
#else
    JXAlert(@"待实现", @"showLoginIfNotLoginedWithFinish:^()Block");
#endif
}

//- (void)handleSuccessForView:(UIView *)view
//                        mode:(JXWebLaunchMode)mode
//                       items:(NSMutableArray *)items
//                        page:(JXPage *)page
//                     results:(NSArray *)results
//                     current:(NSInteger)current
//                       total:(NSInteger)total
//                       image:(UIImage *)image
//                     message:(NSString *)message
//                   functitle:(NSString *)functitle
//                    callback:(JXWebResultCallback)callback {
//    
//}


- (void)handleSuccessForTableView:(UITableView *)tableView
                        tableRect:(CGRect)tableRect
                             mode:(JXWebLaunchMode)mode
                            items:(NSMutableArray *)items
                             page:(JXPage *)page
                          results:(NSArray *)results
                          current:(NSInteger)current
                            total:(NSInteger)total
                            image:(UIImage *)image
                          message:(NSString *)message
                        functitle:(NSString *)functitle
                         callback:(JXWebResultCallback)callback {
    if (results.count == 0) {
        if (mode == JXWebLaunchModeSilent || mode == JXWebLaunchModeLoad || mode == JXWebLaunchModeRefresh) {
            [JXLoadView showResultAddedTo:tableView rect:tableRect image:image message:message functitle:functitle callback:callback];
        }else {
            JXToast(kStringServerException);
        }
    }else {
        [JXLoadView hideForView:tableView];
    }
    
    if (mode == JXWebLaunchModeSilent || mode == JXWebLaunchModeLoad || mode == JXWebLaunchModeRefresh) {
        [items removeAllObjects];
        [items addObjectsFromArray:results];
    }else {
        [items exInsertObjects:results atIndex:items.count unduplicated:YES];
    }
    
    if (page) {
        page.currentPage = current;
        if (items.count < total) {
            [tableView.footer resetNoMoreData];
        }else {
            [tableView.footer noticeNoMoreData];
        }
    }
    
    [tableView reloadData];
    if (mode == JXWebLaunchModeRefresh) {
        [tableView.header endRefreshing];
    }
}

- (void)handleFailureForView:(UIView *)view rect:(CGRect)rect mode:(JXWebLaunchMode)mode way:(JXWebHandleWay)way error:(NSError *)error callback:(JXWebResultCallback)callback {
    if (!error) {
        return;
    }
    
    if (JXWebLaunchModeLoad == mode) {
        [JXLoadView hideForView:view];
    }else if (JXWebLaunchModeHUD == mode) {
        JXHUDHide();
    }else if (JXWebLaunchModeRefresh == mode) {
        UITableView *tableView = (UITableView *)view;
        [tableView.header endRefreshing];
    }else if (JXWebLaunchModeMore == mode) {
        UITableView *tableView = (UITableView *)view;
        [tableView.footer endRefreshing];
    }
    
    [self showLoginIfTokenInvalidWithError:error didPresent:^{
        [kJXWindow makeToast:error.localizedDescription duration:1.5f position:CSToastPositionCenter];
        if (JXWebHandleWayShow == way) {
            [JXLoadView showResultAddedTo:view rect:rect error:error callback:callback];
        }
    } didPass:^{
        if (JXWebHandleWayShow == way) {
            [JXLoadView showResultAddedTo:view rect:rect error:error callback:callback];
        }else if (JXWebHandleWayToast == way) {
            JXToast(error.localizedDescription);
        }
    } reloginWillFinish:^{
        
    } reloginDidFinish:^{
        if (callback) {
            callback();
        }
    }];
}
@end
