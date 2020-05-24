//
//  TabBarController.m
//  Fashion_Show_V1
//
//  Created by TangJR on 8/13/15.
//  Copyright (c) 2015 tangjr. All rights reserved.
//

#import "TabBarController.h"
#import "BaseNavigationController.h"
#import "HomePageViewController.h"
#import "OrderListViewController.h"
#import "LoveHome-Swift.h"
@interface TabBarController () <UITabBarControllerDelegate>



@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    HomePageViewController *home = [HomePageViewController new];
    [self addChildVc:home title:@"" image:@"icon_tabbar_main_nomal" selectedImage:@"icon_tabbar_main_down"];
    
    
//    OrderListViewController *orderVC = [[OrderListViewController alloc] initWithType:OrderTypeAdded];
//    [self addChildVc:orderVC title:@"订单" image:@"icon_tabbar_urgent_nomal" selectedImage:@"icon_tabbar_urgent_down"];
//    self.delegate = self;

    

    self.tabBar.translucent = NO;
    self.tabBar.hidden = YES;
    
//    TColorfulTabBar *colorfulTabBar = [[TColorfulTabBar alloc] initWithFrame:self.tabBar.frame];
//    [self setValue:colorfulTabBar forKey:@"tabBar"];
//    self.colorfulTabBar = colorfulTabBar;
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    childVc.tabBarItem.title = @"";
    
    // 设置子控制器的图片
    childVc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    //    textAttrs[NSForegroundColorAttributeName] = COLOR_CUSTOM(123, 123, 123, 1);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    BaseNavigationController  *nav = [[BaseNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
}



#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
//    NSInteger shouldSelectIndex = [self.viewControllers indexOfObject:viewController];
//    BOOL moduleNeedLogin = shouldSelectIndex != 2;
//    BOOL isLogin = [UserStatusSingleton shareUserStatus].isLogin;
//    
//    if (moduleNeedLogin && !isLogin) {
//        
//        [StaticFunction functionNeedLoginSuccess:^{
//            
//            self.selectedViewController = viewController;
//        } fail:^{
//            
//            self.selectedIndex = 2; // 如果登录失败，则跳回首页模块
//        }];
//        return NO;
//    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    

    

}

@end