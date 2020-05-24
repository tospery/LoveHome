//
//  LHMessage.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/20.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHMessage.h"

@implementation LHMessage
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"uid": @"id"};
}

- (BOOL)isEqual:(id)object {
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    if (self == object) {
        return YES;
    }
    
    if ([self.uid isEqualToString:[(LHMessage *)object uid]]) {
        return YES;
    }
    
    return NO;
}

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (!oldValue || [oldValue isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
//    if ([property.name isEqualToString:@"pushTime"]) {
//        return [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)oldValue doubleValue] / 1000];
//    }
    
    return oldValue;
}
@end
