//
//  LHProductSpecify.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/3.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHSpecify.h"

@implementation LHSpecify
MJCodingImplementation

- (id)copyWithZone:(NSZone *)zone {
    LHSpecify *copy = [[LHSpecify allocWithZone:zone] init];
    copy.uid = self.uid;
    copy.name = self.name;
    copy.price = self.price;
    copy.url = self.url;
    copy.specifies = self.specifies;
    copy.selected = self.selected;
    copy.pieces = self.pieces;
    copy.activityId = self.activityId;
    copy.actPriceType = self.actPriceType;
    copy.actPrice = self.actPrice;
    copy.activityTitle = self.activityTitle;
    copy.actProductImgUrl = self.actProductImgUrl;
    
    return copy;
}

- (BOOL)isEqual:(id)object {
    if (!object || ![object isKindOfClass:[LHSpecify class]]) {
        return NO;
    }
    
    if (self == object) {
        return YES;
    }
    
    if ([self.uid isEqualToString:[(LHSpecify *)object uid]]) {
        LHSpecify *other = object;
        if (self.activityId.length == 0 && other.activityId.length == 0) {
            return YES;
        }else {
            return [self.activityId isEqualToString:other.activityId];
        }
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
@end
