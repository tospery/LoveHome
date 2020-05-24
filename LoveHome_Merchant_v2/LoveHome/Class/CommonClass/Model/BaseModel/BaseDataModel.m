//
//  BaseDataModel.m
//  ProjectFrameworkXC5.0
//
//  Created by MRH on 14-10-21.
//  Copyright (c) 2014年 卡莱博尔. All rights reserved.
//

#import "BaseDataModel.h"
#import <objc/message.h>
#import <objc/runtime.h>
@implementation BaseDataModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

//- (void)setValue:(id)value forKey:(NSString *)key
//{
//
////    NSMutableString *name = [[NSMutableString alloc] initWithString:key];
////    // 4.SEL
////    // 首字母
////    NSString *cap = [key substringToIndex:1];
////    // 变大写
////    cap = cap.uppercaseString;
////    // 将大写字母调换掉原首字母
////    [name replaceCharactersInRange:NSMakeRange(0, 1) withString:cap];
////    // 拼接set
////    [name insertString:@"set" atIndex:0];
////    // 拼接冒号:
////    [name appendString:@":"];
////    SEL selector = NSSelectorFromString(name);
////    objc_msgSend(self, selector, value);
////
//
//
//}


- (NSDictionary *)objectToDictionary
{
    NSArray *namesArray = NSArrayFromClassAllProperty(self);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int i =0; i<[namesArray count]; i++)
    {
        id valueObject = [self valueForKey:[namesArray objectAtIndex:i]];
        if (valueObject)
        {
            [dic setObject:valueObject forKey:[namesArray objectAtIndex:i]];
        }
    }
    
    return dic;
}

@end
