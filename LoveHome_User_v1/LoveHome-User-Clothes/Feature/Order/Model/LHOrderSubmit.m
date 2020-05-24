//
//  LHOrderSubmit.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/7.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHOrderSubmit.h"

@implementation LHOrderSubmitOrderDetail

@end

@implementation LHOrderSubmitOrderList
MJCodingImplementation

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (!oldValue || [oldValue isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return oldValue;
}

+ (NSDictionary *)objectClassInArray {
    return @{@"orderDetailList": [LHOrderSubmitOrderDetail class]};
}
@end

@implementation LHOrderSubmit
MJCodingImplementation

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (!oldValue || [oldValue isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return oldValue;
}

+ (NSDictionary *)objectClassInArray {
    return @{@"orderList": [LHOrderSubmitOrderList class]};
}
@end
