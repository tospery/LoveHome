//
//  LHNavigationController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/16.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "LHNavigationController.h"

@interface LHNavigationController ()

@end

@implementation LHNavigationController

+ (void)initialize
{
    [self setupNavTheme];
}

+ (void)setupNavTheme{
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    navBar.tintColor = [UIColor whiteColor];
    
    // 设置标题文字颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    [navBar setTitleTextAttributes:attrs];
    
    // 2.设置BarButtonItem的主题
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // 设置文字颜色
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
////    if (self.viewControllers.count > 0) {
////        viewController.hidesBottomBarWhenPushed = YES;
////        
////        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
////        [button setBackgroundImage:[UIImage imageNamed:@"jx_arrow_left_gray"] forState:UIControlStateNormal];
////        [button setBackgroundImage:[UIImage imageNamed:@"jx_arrow_left_gray"] forState:UIControlStateHighlighted];
////        button.frame = (CGRect){CGPointZero, button.currentBackgroundImage.size};
////        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
////        
////        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
////    }
//    [super pushViewController:viewController animated:YES];
//}

- (void)back
{
    [self popViewControllerAnimated:YES];
}
@end
