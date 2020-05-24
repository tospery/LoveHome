//
//  LHOrder.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/7.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHOrder.h"

@implementation LHOrder
MJCodingImplementation

- (BOOL)isEqual:(id)object {
    if (!object || ![object isKindOfClass:[LHOrder class]]) {
        return NO;
    }
    
    if (self == object) {
        return YES;
    }
    
    if ([self.uid isEqualToString:[(LHOrder *)object uid]]) {
        return YES;
    }
    
    return NO;
}

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (!oldValue || [oldValue isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
//    if ([property.name isEqualToString:@"orderTime"]
//        || [property.name isEqualToString:@"appointTime"]
//        || [property.name isEqualToString:@"receiptTime"]
//        || [property.name isEqualToString:@"rejectTime"]) {
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:((double)[oldValue longLongValue] / 1000)];
//        return [date stringWithFormat:kJXFormatDatetimeNormal];
//    }
    
    return oldValue;
}

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"uid": @"id",
             @"pay": @"orderPayDto",
             @"products": @"orderDetailList"};
}

+ (NSDictionary *)objectClassInArray {
    return @{@"products": [LHOrderProduct class]};
}
@end
