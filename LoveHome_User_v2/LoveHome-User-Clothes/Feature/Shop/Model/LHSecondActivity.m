//
//  LHSecondActivity.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/29.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import "LHSecondActivity.h"
#import "LHSecondCategory.h"

@implementation LHSecondActivity
+ (NSDictionary *)objectClassInArray {
    return @{@"categories": [LHSecondCategory class]};
}

@end
