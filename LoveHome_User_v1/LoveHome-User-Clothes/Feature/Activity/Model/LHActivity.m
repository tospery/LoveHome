//
//  LHActivity.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/21.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHActivity.h"

@implementation LHActivity
MJCodingImplementation

- (BOOL)isEqual:(id)object {
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    if (self == object) {
        return YES;
    }
    
    if ([self.activityid isEqualToString:[(LHActivity *)object activityid]]) {
        return YES;
    }
    
    return NO;
}

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (!oldValue || [oldValue isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
//    if ([property.name isEqualToString:@"type"]) {
//        return [NSNumber numberWithInteger:[(NSString *)oldValue integerValue]];
//    }
    
    return oldValue;
}
@end
