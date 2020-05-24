//
//  JXError.m
//  DaiChi
//
//  Created by 杨建祥 on 15/6/23.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "JXError.h"
#import "JXApple.h"

#define JXErrorDomain                   (@"com.tospery.jxapple")
#define JXErrorStart                    (14700)

@implementation JXError
+ (NSError *)errorWithCode:(JXErrorCode)code {
    static NSArray *descriptions;
    if (!descriptions) {
        descriptions = @[@"无效的数据", @"账号或密码不一致", @"注册失败"];
    }
    
    NSString *description;
    if (code > 0 && code < JXErrorCodeAll) {
        description = [descriptions objectAtIndex:(code - 1)];
    }else {
        description = @"未定义的错误";
    }
    
    return [NSError errorWithDomain:[JXApp identifier]
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey: description}];
}

+ (NSError *)errorWithCode:(JXErrorCode)code description:(NSString *)description {
    return [NSError errorWithDomain:[JXApp identifier]
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey: description}];
}
@end
