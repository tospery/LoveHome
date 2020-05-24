//
//  BaseNavigationController.m
//  Love_Home
//
//  Created by MRH-MAC on 14-11-3.
//  Copyright (c) 2014年 MRH-MAC. All rights reserved.
//

#import "BaseNavigationController.h"

@implementation BaseNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    
    if (self)
    {
        self.navigationBar.translucent = NO;
    }
    return self;
}


#pragma mark - 初始化
+ (void)initialize
{
    // 1.取出设置主题的对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];

    

    navBar.tintColor = [UIColor whiteColor];
    
    // 3.设置导航栏标题颜色为白色
 
    [navBar setTitleTextAttributes:@{
                                     NSForegroundColorAttributeName : [UIColor darkGrayColor]
                                     }];
//    [navBar setBarTintColor:COLOR_CUSTOM(54,54,54, 1)];
    
    // 4.设置导航栏按钮文字颜色为白色
    [barItem setTitleTextAttributes:@{
                                      NSForegroundColorAttributeName : [UIColor darkGrayColor],
                                      NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]
                                      } forState:UIControlStateNormal];

}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    // 白色样式
    return UIStatusBarStyleDefault;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
        button.frame = (CGRect){CGPointZero, button.currentBackgroundImage.size};
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    [super pushViewController:viewController animated:YES];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end
