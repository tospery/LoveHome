//
//  MMDrawerController+JXApple.m
//  TianlongHome
//
//  Created by 杨建祥 on 15/4/26.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#ifdef JXEnableMMDrawerController
#import "MMDrawerController+JXApple.h"

@implementation MMDrawerController (JXApple)
+ (MMDrawerController *)exDrawerControllerWithCenterVC:(UIViewController *)centerVC
                                                 leftVC:(UIViewController *)leftVC
                                                rightVC:(UIViewController *)rightVC
                                                leftWidth:(CGFloat)leftWidth
                                              rightWidth:(CGFloat)rightWidth{
    MMDrawerController *drawerController = [[MMDrawerController alloc]
                                            initWithCenterViewController:centerVC
                                            leftDrawerViewController:leftVC
                                            rightDrawerViewController:rightVC];
    [drawerController setShowsShadow:NO];
    //[drawerController setShouldStretchDrawer:NO];
    if (leftWidth > 0) {
        [drawerController setMaximumLeftDrawerWidth:leftWidth];
    }
    if (rightWidth > 0) {
        [drawerController setMaximumRightDrawerWidth:rightWidth];
    }
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    return drawerController;
}
@end
#endif