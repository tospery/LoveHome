//
//  LHCartShop.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/4.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHCartShop.h"

@implementation LHCartShop
MJCodingImplementation

- (NSMutableArray *)specifies {
    if (!_specifies) {
        _specifies = [NSMutableArray array];
    }
    return _specifies;
}

+ (void)addProductWithOrder:(LHOrder *)order {
    LHCartShop *cartShop = nil;
    for (LHCartShop *cs in gLH.cartShops) {
        if ([cs.shopID isEqualToString:order.shopId]) {
            cartShop = cs;
            break;
        }
    }
    
    if (cartShop) {
        NSMutableArray *xz = [NSMutableArray array];

        for (LHSpecify *s1 in order.products) {
            int i = 0;
            for (i = 0; i < cartShop.specifies.count; ++i) {
                LHSpecify *s2 = cartShop.specifies[i];
                if ([s1.productId isEqualToString:s2.productId]) {
                    if ((s1.uid == nil && s2.uid == nil) ||
                        ([s1.uid isEqualToString:s2.uid])) {
                        s2.pieces += s1.pieces;
                        break;
                    }
                }
            }
            
            if (i == cartShop.specifies.count) {
                [xz addObject:s1];
            }
        }
        [cartShop.specifies addObjectsFromArray:xz];
    }else {
        cartShop = [[LHCartShop alloc] init];
        cartShop.shopID = order.shopId;
        cartShop.shopName = order.shopName;
        [cartShop.specifies addObjectsFromArray:order.products];
        [gLH.cartShops addObject:cartShop];
    }
}

+ (NSInteger)getProdunctCount {
    NSInteger count = 0;
    for (LHCartShop *c in gLH.cartShops) {
        count += c.specifies.count;
    }
    return count;
}

+ (NSArray *)fetch {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[LHCartShop getLocalFile]];
}

+ (void)storage:(NSArray *)cartShops {
    [NSKeyedArchiver archiveRootObject:cartShops toFile:[LHCartShop getLocalFile]];
}

+ (NSString *)getLocalFile {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"cartShops.data"];
}
@end
