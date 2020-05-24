//
//  LHVerifyShopCartResult.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/2.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import "LHVerifyShopCartResult.h"

@implementation LHVerifyShopCartResultSpecify

@end

@implementation LHVerifyShopCartResultProduct
+ (NSDictionary *)objectClassInArray {
    return @{@"specifies": [LHVerifyShopCartResultSpecify class]};
}

@end

@implementation LHVerifyShopCartResultShop
+ (NSDictionary *)objectClassInArray {
    return @{@"products": [LHVerifyShopCartResultProduct class]};
}
@end

@implementation LHVerifyShopCartResult
+ (NSDictionary *)objectClassInArray {
    return @{@"normalPro": [LHVerifyShopCartResultShop class],
             @"passDueProducts": [LHVerifyShopCartResultShop class]};
}
@end
