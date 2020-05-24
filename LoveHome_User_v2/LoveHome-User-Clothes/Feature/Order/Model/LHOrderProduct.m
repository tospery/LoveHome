//
//  LHOrderProduct.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/7.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHOrderProduct.h"

@implementation LHOrderProduct
MJCodingImplementation

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (!oldValue || [oldValue isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return oldValue;
}

             //@"name": @"productName",
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"uid": @"specId",
             @"pieces": @"count",
             @"price": @"specPrice",
             @"url": @"imageUrl"};
}

- (NSString *)name {
    if (_specName.length == 0) {
        return _productName;
    }else {
        return [NSString stringWithFormat:@"%@(%@)", _productName, _specName];
    }
}
@end
