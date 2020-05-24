//
//  UINavigationItem+JXApple.m
//  iOSLibrary
//
//  Created by 杨建祥 on 15/4/3.
//  Copyright (c) 2015年 Thundersoft. All rights reserved.
//

#import "UINavigationItem+JXApple.h"
#import "JXApple.h"

@implementation UINavigationItem (JXApple)
- (void)exSetTitleOnly:(NSString *)title color:(UIColor *)color {
    if (JXiOSVersionGreaterThanOrEqual(7.0)) {
        self.title = nil;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., 100., 21.)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = color;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:17.];
        label.text = title;
        self.titleView = label;
    }else {
        self.title = title;
    }
}
@end
