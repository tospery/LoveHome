//
//  JXConfigManager.h
//  TianlongHome
//
//  Created by 杨建祥 on 15/4/21.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXConfigManager : NSObject
+ (void)configDatabase;

+ (void)configLog;

+ (void)configKeyboard;

+ (void)configNetwork;

+ (void)configBarWithNavBarColor:(UIColor *)navBarColor
                navBarTitleColor:(UIColor *)navBarTitleColor
                     tabBarColor:(UIColor *)tabBarColor
             tabBarSelectedColor:(UIColor *)tabBarSelectedColor
                  statusBarStyle:(UIStatusBarStyle)statusBarStyle;
@end