//
//  UINavigationBar+JXApple.m
//  TianlongHome
//
//  Created by 杨建祥 on 15/5/2.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "UINavigationBar+JXApple.h"

@implementation UINavigationBar (JXApple)
- (void)exConfigBackgroundImage:(UIImage *)backgroundImage titleColor:(UIColor *)titleColor {
    [self setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    self.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                titleColor, NSForegroundColorAttributeName, nil];
}
@end
