//
//  LHSecondBusiness.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/29.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import "LHSecondBusiness.h"
#import "LHSecondActivity.h"

@implementation LHSecondBusiness
+ (NSDictionary *)objectClassInArray {
    return @{@"activitys": [LHSecondActivity class]};
}

@end
