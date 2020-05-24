//
//  LHUser.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/23.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHUser.h"

@interface LHUser()
@end

@implementation LHUser
{
    LHUserInfo *myUserInfo;
}

MJCodingImplementation

- (BOOL)isEqual:(id)object {
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    if (self == object) {
        return YES;
    }
    
//    if ([self.info isEqualToString:[(LHUser *)object info]]) {
//        return YES;
//    }
    
    return NO;
}

#pragma mark - Accessor methods
- (LHUserInfo *)info
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myUserInfo = [LHUserInfo fetch];
    });
    return myUserInfo;
}

- (void)setInfo:(LHUserInfo *)info
{
    myUserInfo = info;
    [LHUserInfo storage:info];
    [LHUser storage:self];
}


+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"info": @"accountUserDto"};
}

+ (LHUser *)fetch {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[LHUser getLocalFile]];
}

+ (void)storage:(LHUser *)user {
    [NSKeyedArchiver archiveRootObject:user toFile:[LHUser getLocalFile]];
}

+ (NSString *)getLocalFile {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"user.data"];
}
@end

