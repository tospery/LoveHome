//
//  NSDictionary+JXApple.m
//  iOSLibrary
//
//  Created by 杨建祥 on 15/3/20.
//  Copyright (c) 2015年 Thundersoft. All rights reserved.
//

#import "NSDictionary+JXApple.h"

@implementation NSDictionary (JXApple)
+ (instancetype)exInitWithExpressions:(NSString *)expressions {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    NSString *findString = expressions;
    NSRange range;
    while (YES) {
        range = [findString rangeOfString:@"<"];
        if (NSNotFound == range.location) {
            break;
        }
        NSString *key = [findString substringToIndex:range.location];
        findString = [findString substringFromIndex:(range.location + 1)];
        
        range = [findString rangeOfString:@">"];
        if (NSNotFound == range.location) {
            break;
        }
        NSString *value = [findString substringToIndex:range.location];
        findString = [findString substringFromIndex:(range.location + 1)];
        
        [result setObject:value forKey:key];
    }
    
    return result;
}
@end
