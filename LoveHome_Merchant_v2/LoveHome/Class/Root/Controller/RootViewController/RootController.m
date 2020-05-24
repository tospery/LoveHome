//
//  RootController.m
//  LoveHome
//
//  Created by MRH-MAC on 15/8/5.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "RootController.h"
#import "HomeViewCtroller.h"
#import "BaseNavigationController.h"
#import "LoginsViewController.h"
#import "HomePageViewController.h"
#import "TabBarController.h"

@interface RootController ()
@property (nonatomic, strong) TabBarController *tabar;

@end

@implementation RootController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;

    _tabar = [[TabBarController alloc] init];
    [self addChildViewController:_tabar];
    
    
    if ([self fisrtcheckIsLogin])
    {
        [self.view addSubview:_tabar.view];
        
    }

}


- (BOOL)fisrtcheckIsLogin
{
    BOOL isLogin = YES;
    
    if ([UserTools sharedUserTools].userModel == nil) {
        isLogin = NO;
        
        LoginsViewController *login = [[LoginsViewController alloc] init];
        __weak LoginsViewController *weakLogin = login;
        __weak RootController *weakSelf = self;
        login.loginSucessBlock = ^
        {
            [weakLogin removeFromParentViewController];
            [weakLogin.view removeFromSuperview];
            [weakSelf.view addSubview:self.tabar.view];
            
        };
        BaseNavigationController *nav =[[BaseNavigationController alloc] initWithRootViewController:login];
        [self addChildViewController:nav];
        [self.view addSubview:nav.view];

    }
    return isLogin;
    
  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
