//
//  LHWasherButton.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/22.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHWasherButton.h"
#import "UIView+LH.h"

@implementation LHWasherButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self custom];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self custom];
    }
    return self;
}

- (void)custom {
    __weak LHWasherButton *weakSelf = self;
    self.hitTestBlock = ^(CGPoint point, UIEvent *event, BOOL *returnSuper) {
        CGPoint center = CGPointMake(CGRectGetWidth(weakSelf.bounds) / 2, CGRectGetHeight(weakSelf.bounds) / 2);
        CGFloat ratio = DistanceBetweenPoints(point, center) / (weakSelf.frame.size.width / 2);
        if (ratio > 0.55 && ratio < 0.975) {
            *returnSuper = YES;
            CGFloat degree = DegreeBetweenPoints(point, center);
            if (degree > -29 && degree < 26) {
                weakSelf.tag = 0;
            }else if (degree > -88 && degree < -34) {
                weakSelf.tag = 1;
            }else if (degree > -146 && degree < -91) {
                weakSelf.tag = 2;
            }else if ((degree >= -180 && degree < -150) || (degree > 155 && degree <= 180)) {
                weakSelf.tag = 3;
            }else if (degree > 93 && degree < 150) {
                weakSelf.tag = 4;
            }else if (degree > 30 && degree < 80) {
                weakSelf.tag = 5;
            }else {
                *returnSuper = NO;
            }
        }
        return (UIView *)nil;
    };
}
@end
