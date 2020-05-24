//
//  LHProductCategory.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/3.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHProductCategory.h"

@implementation LHProductCategory
MJCodingImplementation

- (BOOL)isEqual:(id)object {
    if (!object || ![object isKindOfClass:[LHProductCategory class]]) {
        return NO;
    }
    
    if (self == object) {
        return YES;
    }
    
    if ([self.uid isEqualToString:[(LHProductCategory *)object uid]]) {
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

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"uid": @"id"};
}

+ (NSDictionary *)objectClassInArray {
    return @{@"products": [LHProduct class]};
}
@end