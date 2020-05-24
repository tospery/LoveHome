//
//  LHCoupon.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/2.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHCoupon.h"

@implementation LHCoupon
MJCodingImplementation

- (BOOL)isEqual:(id)object {
    if (!object || ![object isKindOfClass:[LHCoupon class]]) {
        return NO;
    }
    
    if (self == object) {
        return YES;
    }
    
    if ([self.couponId isEqualToString:[(LHCoupon *)object couponId]]) {
        return YES;
    }
    
    return NO;
}

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (!oldValue || [oldValue isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return oldValue;
}

@end
