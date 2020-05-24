//
//  NSDateFormatter+JXApple.h
//  LoveHome-User
//
//  Created by 杨建祥 on 15/7/4.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (JXApple)
// 实例化特定的格式化器
+ (NSDateFormatter *)exInstanceWithFormat:(NSString *)format locale:(NSString *)locale;
// 实例化特定的格式化器
+ (NSDateFormatter *)exInstanceWithFormat:(NSString *)format;
@end
