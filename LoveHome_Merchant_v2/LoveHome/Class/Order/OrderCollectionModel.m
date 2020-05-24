//
//  OrderCollectionModel.m
//  LoveHome
//
//  Created by 杨建祥 on 15/8/27.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "OrderCollectionModel.h"

@implementation OrderCollectionModel
MJCodingImplementation

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"orders": @"data"};
}

+ (NSDictionary *)objectClassInArray {
    return @{@"orders": @"OrderModel"};
}

@end
