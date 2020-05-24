//
//  NSURL+JXApple.m
//  LoveHome-User
//
//  Created by 杨建祥 on 15/7/7.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "NSURL+JXApple.h"

@implementation NSURL (JXApple)
+ (NSURL *)exURLWithBase:(NSString *)base path:(NSString *)path {
    if (0 == base.length || 0 == path.length) {
        return nil;
    }
    
    NSURL *baseURL = [NSURL URLWithString:base];
    if (baseURL.path.length > 0 && ![baseURL.absoluteString hasSuffix:@"/"]) {
        baseURL = [baseURL URLByAppendingPathComponent:@""];
    }
    return [NSURL URLWithString:path relativeToURL:baseURL];
}
@end
