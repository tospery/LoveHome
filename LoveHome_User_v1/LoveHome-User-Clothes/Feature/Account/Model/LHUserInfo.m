//
//  LHUserInfo.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/3.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHUserInfo.h"

@implementation LHUserInfo
MJCodingImplementation

- (BOOL)isEqual:(id)object {
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    if (self == object) {
        return YES;
    }
    
    if ([self.phoneNumber isEqualToString:[(LHUserInfo *)object phoneNumber]]) {
        return YES;
        
    }
    
    return NO;
}

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (!oldValue || [oldValue isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
//    if (property.type.typeClass == [NSDate class]) {
//        return [NSDate dateWithTimeIntervalSince1970:[oldValue doubleValue]];
//    }
    return oldValue;
}

+ (LHUserInfo *)fetch {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[LHUserInfo getLocalFile]];
}

+ (void)storage:(LHUserInfo *)user {
    [NSKeyedArchiver archiveRootObject:user toFile:[LHUserInfo getLocalFile]];
}

+ (NSString *)getLocalFile {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.data"];
}

@end
