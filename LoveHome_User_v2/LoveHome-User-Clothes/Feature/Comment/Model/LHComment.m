//
//  LHComment.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/17.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHComment.h"

@implementation LHComment
MJCodingImplementation

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"comments": @"data"};
}

+ (NSDictionary *)objectClassInArray {
    return @{@"comments": @"LHComment"};
}

- (BOOL)isEqual:(id)object {
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    if (self == object) {
        return YES;
    }
    
    if (self.commentId == [(LHComment *)object commentId]) {
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


@implementation LHCommentCollection
MJCodingImplementation

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"comments": @"data"};
}

+ (NSDictionary *)objectClassInArray {
    return @{@"comments": @"LHComment"};
}
@end

