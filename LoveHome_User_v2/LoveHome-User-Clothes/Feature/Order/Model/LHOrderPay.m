//
//  LHOrderPay.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/7.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHOrderPay.h"

@implementation LHOrderPay
MJCodingImplementation

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (!oldValue || [oldValue isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return oldValue;
}

- (CGFloat)cash {
    if (_cash == 0) {
        _cash = _payPrice;
    }
    return _cash;
}

- (CGFloat)payPrice {
    if (_payPrice == 0) {
        _payPrice = _cash;
    }
    return _payPrice;
}
@end
