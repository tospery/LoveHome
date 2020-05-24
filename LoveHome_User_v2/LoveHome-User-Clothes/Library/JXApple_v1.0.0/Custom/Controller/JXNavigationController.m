//
//  JXNavigationController.m
//  iOSLibrary
//
//  Created by 杨建祥 on 15/4/3.
//  Copyright (c) 2015年 Thundersoft. All rights reserved.
//

#import "JXNavigationController.h"
#import "JXApple.h"

@interface JXNavigationController ()

@end

@implementation JXNavigationController
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    if (!viewController.navigationItem.leftBarButtonItem && [self.viewControllers count] > 1) {
        viewController.navigationItem.leftBarButtonItem = [self createLeftBarItem];
    }
}

- (UIBarButtonItem *)createLeftBarItem {
    return JXCreateLeftBarItem(self);
}

- (void)leftBarItemPressed:(id)sender {
    [self popViewControllerAnimated:YES];
}

- (void)configWithBarColor:(UIColor *)barColor
                      titleColor:(UIColor *)titleColor {
    if (JXiOSVersionGreaterThanOrEqual(7.0)) {
        self.navigationBar.translucent = NO;
        self.navigationBar.barTintColor = barColor;
    } else {
        [self.navigationBar setBackgroundImage:[UIImage exImageWithColor:barColor] forBarMetrics:UIBarMetricsDefault];
    }
    
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                              titleColor, NSForegroundColorAttributeName, nil];
}
@end
