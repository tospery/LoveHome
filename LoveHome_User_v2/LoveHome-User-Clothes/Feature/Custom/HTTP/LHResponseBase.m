//
//  LHResponse.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/22.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHResponseBase.h"

@implementation LHResponseBase
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"message": @"description"};
}

@end
