//
//  UIBarButtonItem+JXApple.h
//  MyiOS
//
//  Created by Thundersoft on 10/20/14.
//  Copyright (c) 2014 Thundersoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifdef JXEnableVBFPopFlatButton
#import "VBFPopFlatButton.h"
#endif

#define kJXBarButtonItemIconNormal                  (@"kJXBarButtonItemIconNormal")
#define kJXBarButtonItemIconHighlighted             (@"kJXBarButtonItemIconHighlighted")
#define kJXBarButtonItemIconDisabled                (@"kJXBarButtonItemIconDisabled")
#define kJXBarButtonItemIconSelected                (@"kJXBarButtonItemIconSelected")


@interface UIBarButtonItem (JXApple)
+ (UIBarButtonItem *)exBarItemWithImage:(UIImage *)image size:(CGSize)size target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)exBarItemWithImages:(NSDictionary *)images target:(id)target action:(SEL)action;

#ifdef JXEnableVBFPopFlatButton
+ (UIBarButtonItem *)exBarItemWithType:(FlatButtonType)type color:(UIColor *)color target:(id)target action:(SEL)action;
#endif
@end
