//
//  NSError+JXApple.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/1.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXType.h"

@interface NSError (JXApple)
+ (NSError *)exErrorWithCode:(JXErrorCode)code;
+ (NSError *)exErrorWithCode:(JXErrorCode)code description:(NSString *)description;

@end
