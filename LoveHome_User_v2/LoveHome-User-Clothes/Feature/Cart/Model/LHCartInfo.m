//
//  LHCartInfo.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 16/1/5.
//  Copyright © 2016年 艾维科思. All rights reserved.
//

#import "LHCartInfo.h"

@implementation LHCartInfo
+ (NSDictionary *)objectClassInArray {
    return @{@"normalPro": [LHCartInfoShop class],
             @"passDueProducts": [LHCartInfoShop class]};
}
@end


@implementation LHCartInfoShop
+ (NSDictionary *)objectClassInArray {
    return @{@"products": [LHCartInfoProduct class],
             @"activictInfos": [LHCartInfoActivity class]};
}
@end

@implementation LHCartInfoProduct
MJCodingImplementation

- (BOOL)isEqual:(id)object {
    if (!object || ![object isKindOfClass:[LHProduct class]]) {
        return NO;
    }
    
    if (self == object) {
        return YES;
    }
    
    if ([self.uid isEqualToString:[(LHProduct *)object uid]]) {
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
    return @{@"specifies": [LHCartInfoSpecify class]};
}

@end


@implementation LHCartInfoActivity
MJCodingImplementation

- (BOOL)isEqual:(id)object {
    if (!object || ![object isKindOfClass:[LHCartInfoActivity class]]) {
        return NO;
    }
    
    if (self == object) {
        return YES;
    }
    
    if ([self.activityId isEqualToString:[(LHCartInfoActivity *)object activityId]]) {
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

+ (NSDictionary *)objectClassInArray {
    return @{@"products": [LHCartInfoProduct class]};
}

@end


@implementation LHCartInfoSpecify
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"uid": @"id"};
}

@end




