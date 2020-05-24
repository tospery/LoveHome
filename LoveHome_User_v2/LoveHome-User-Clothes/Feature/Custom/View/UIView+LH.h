//
//  UIView+LH.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/22.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIView * (^STHitTestViewBlock)(CGPoint point, UIEvent *event, BOOL *returnSuper);
typedef BOOL (^STPointInsideBlock)(CGPoint point, UIEvent *event, BOOL *returnSuper);

@interface UIView (LH)
@property(nonatomic, strong) STHitTestViewBlock hitTestBlock;
@property(nonatomic, strong) STPointInsideBlock pointInsideBlock;

@end
