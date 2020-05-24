//
//  LHShopActivity.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/16.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHActivityShop.h"

@implementation LHActivityShop
MJCodingImplementation

+ (NSArray *)ignoredPropertyNames {
    return @[@"description"];
}

- (BOOL)isEqual:(id)object {
    if (!object || ![object isKindOfClass:[LHActivityShop class]]) {
        return NO;
    }
    
    if (self == object) {
        return YES;
    }
    
    if ([self.shopId isEqualToString:[(LHActivityShop *)object shopId]]) {
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
