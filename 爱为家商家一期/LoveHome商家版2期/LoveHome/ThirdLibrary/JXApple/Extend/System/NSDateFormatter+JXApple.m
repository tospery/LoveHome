//
//  NSDateFormatter+JXApple.m
//  LoveHome-User
//
//  Created by 杨建祥 on 15/7/4.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "NSDateFormatter+JXApple.h"

@implementation NSDateFormatter (JXApple)
// 实例化特定的格式化器
+ (NSDateFormatter *)exInstanceWithFormat:(NSString *)format locale:(NSString *)locale {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:locale];
    return dateFormatter;
}
// 实例化特定的格式化器
+ (NSDateFormatter *)exInstanceWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    return dateFormatter;
}
@end
