//
//  UIViewController+JXApple.h
//  LoveHome
//
//  Created by 杨建祥 on 15/8/28.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXApple.h"

@interface UIViewController (JXApple)
- (void)handleSuccessWithMode:(JXRequestMode)mode view:(UIView *)view;
- (void)handleFailureWithMode:(JXRequestMode)mode view:(UIView *)view error:(NSError *)error retry:(void (^)(void))retry;


- (void)handleSuccessForSlient;
- (void)handleFailureForSlient;

- (void)handleSuccessForLoad:(UIView *)view;
- (void)handleFailureForLoad:(UIView *)view error:(NSError *)error retry:(void (^)(void))retry;

- (void)handleSuccessForHUD;
- (void)handleFailureForHUD:(NSError *)error;

- (void)handleSuccessForRefresh:(UIView *)view;
- (void)handleFailureForRefresh:(UIView *)view error:(NSError *)error;

- (void)handleSuccessForMore:(UIView *)view;
- (void)handleFailureForMore:(UIView *)view error:(NSError *)error;
@end
