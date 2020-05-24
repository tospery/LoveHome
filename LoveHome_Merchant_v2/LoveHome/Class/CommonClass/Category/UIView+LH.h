//
//  NSString+ContentSize.h
//  ScrollerViewPage
//
//  Created by MRH-MAC on 15/1/7.
//  Copyright (c) 2015年 MRH-MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIView * (^STHitTestViewBlock)(CGPoint point, UIEvent *event, BOOL *returnSuper);
typedef BOOL (^STPointInsideBlock)(CGPoint point, UIEvent *event, BOOL *returnSuper);

@interface UIView (LH)
@property(nonatomic, strong) STHitTestViewBlock hitTestBlock;
@property(nonatomic, strong) STPointInsideBlock pointInsideBlock;

@end
