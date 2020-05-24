//
//  JXViewControllerAnimatedTransition.h
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/17.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXViewController.h"

@interface JXViewControllerAnimatedTransition : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign, readonly) UINavigationControllerOperation operation;
@property (nonatomic, weak, readonly) JXViewController *fromViewController;
@property (nonatomic, weak, readonly) JXViewController *toViewController;

- (instancetype)initWithNavigationControllerOperation:(UINavigationControllerOperation)operation
                                   fromViewController:(JXViewController *)fromViewController
                                     toViewController:(JXViewController *)toViewController;
@end
