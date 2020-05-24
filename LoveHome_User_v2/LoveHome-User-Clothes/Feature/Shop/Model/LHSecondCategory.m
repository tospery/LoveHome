//
//  LHSecondCategory.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/29.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import "LHSecondCategory.h"
#import "LHSecondProduct.h"

@implementation LHSecondCategory
+ (NSDictionary *)objectClassInArray {
    return @{@"products": [LHSecondProduct class]};
}

@end
