//
//  LHCollection.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/20.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHResponseCollection.h"

@implementation LHResponseCollection
MJCodingImplementation
@end

@implementation LHMessageCollection
MJCodingImplementation

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"messages": @"data"};
}

+ (NSDictionary *)objectClassInArray {
    return @{@"messages": @"LHMessage"};
}
@end

@implementation LHBalanceFlowCollection
MJCodingImplementation

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"balanceFlows": @"data"};
}

+ (NSDictionary *)objectClassInArray {
    return @{@"balanceFlows": @"LHBalanceFlow"};
}
@end

@implementation LHLovebeanWrapperCollection
MJCodingImplementation

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"lovebeanWrappers": @"data"};
}

+ (NSDictionary *)objectClassInArray {
    return @{@"lovebeanWrappers": @"LHLovebeanWrapper"};
}

@end

@implementation LHOrderCollection
MJCodingImplementation

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"orders": @"data"};
}

+ (NSDictionary *)objectClassInArray {
    return @{@"orders": [LHOrder class]};
}

@end

@implementation LHShopList
MJCodingImplementation

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"shops": @"data"};
}

+ (NSDictionary *)objectClassInArray {
    return @{@"shops": @"LHShop"};
}

@end


@implementation LHActivityShopList
MJCodingImplementation

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"shops": @"data"};
}

+ (NSDictionary *)objectClassInArray {
    return @{@"shops": [LHActivityShop class]};
}

@end


