//
//  MainViewController.m
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/19.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "MainViewController.h"
#import "MainViewModel.h"
#import "HomeViewController.h"
#import "OrderViewController.h"
#import "StatViewController.h"

@interface MainViewController ()
@property (nonatomic, strong) MainViewModel *viewModel;

@end

@implementation MainViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JXNavigationController *homeNC = ({
        HomeViewController *homeVC = [[HomeViewController alloc] initWithViewModel:self.viewModel.homeViewModel];
        UIImage *normalImage = [JXImageWithName(@"ic_tab_home_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectedImage = [JXImageWithName(@"ic_tab_home_selected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:normalImage selectedImage:selectedImage];
        [[JXNavigationController alloc] initWithRootViewController:homeVC];
    });
    
    JXNavigationController *orderNC = ({
        OrderViewController *orderVC = [[OrderViewController alloc] initWithViewModel:self.viewModel.orderViewModel];
        UIImage *normalImage = [JXImageWithName(@"ic_tab_order_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectedImage = [JXImageWithName(@"ic_tab_order_selected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        orderVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"订单" image:normalImage selectedImage:selectedImage];
        [[JXNavigationController alloc] initWithRootViewController:orderVC];
    });
    
    JXNavigationController *statNC = ({
        StatViewController *statVC = [[StatViewController alloc] initWithViewModel:self.viewModel.statViewModel];
        UIImage *normalImage = [JXImageWithName(@"ic_tab_stat_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectedImage = [JXImageWithName(@"ic_tab_stat_selected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        statVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"统计" image:normalImage selectedImage:selectedImage];
        [[JXNavigationController alloc] initWithRootViewController:statVC];
    });
    
    self.tabBarController.viewControllers = @[homeNC, orderNC, statNC];
}

@end
