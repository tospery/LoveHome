//
//  UIBarButtonItem+JXApple.m
//  MyiOS
//
//  Created by Thundersoft on 10/20/14.
//  Copyright (c) 2014 Thundersoft. All rights reserved.
//

#import "UIBarButtonItem+JXApple.h"

@implementation UIBarButtonItem (JXApple)
+ (UIBarButtonItem *)exBarItemWithImage:(UIImage *)image size:(CGSize)size target:(id)target action:(SEL)action {
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.frame = frame;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    if(action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)exBarItemWithImages:(NSDictionary *)images target:(id)target action:(SEL)action {
    CGRect frame = CGRectMake(0, 0, 20, 20);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;

    [button setBackgroundImage:[images objectForKey:kJXBarButtonItemIconNormal] forState:UIControlStateNormal];
    [button setBackgroundImage:[images objectForKey:kJXBarButtonItemIconHighlighted] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[images objectForKey:kJXBarButtonItemIconDisabled] forState:UIControlStateDisabled];
    [button setBackgroundImage:[images objectForKey:kJXBarButtonItemIconSelected] forState:UIControlStateSelected];

    if(action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }

    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

// FlatButtonType
#ifdef JXEnableVBFPopFlatButton
+ (UIBarButtonItem *)exBarItemWithType:(FlatButtonType)type color:(UIColor *)color target:(id)target action:(SEL)action {
    VBFPopFlatButton *popFlatButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)
                                                buttonType:type
                                               buttonStyle:buttonPlainStyle
                                     animateToInitialState:NO];
    popFlatButton.lineThickness = 2.0;
    popFlatButton.tintColor = color;
    if (target && action) {
        [popFlatButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return [[UIBarButtonItem alloc] initWithCustomView:popFlatButton];
}
#endif
@end







