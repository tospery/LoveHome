//
//  LHSecondProduct.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/29.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import "LHSecondProduct.h"
#import "LHSecondSpecify.h"

@implementation LHSecondProduct
+ (NSDictionary *)objectClassInArray {
    return @{@"specifies": [LHSecondSpecify class]};
}

@end
