//
//  LHShop.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/30.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHShop.h"

@implementation LHShop
MJCodingImplementation

- (instancetype)initWithShopId:(NSString *)shopId shopName:(NSString *)shopName
{
    if (self = [super init])
    {
        _shopId = shopId;
        _shopName = shopName;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    if (self == object) {
        return YES;
    }
    
    if ([self.shopId isEqualToString:[(LHShop *)object shopId]]) {
        return YES;
    }
    
    return NO;
}

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"shopName": @"name",
             @"level": @"starLevel",
             //@"shopDes": @"description",
             @"totalComment": @"commonts",
             //@"shopDes": @"description",
             @"types": @"tag",
             @"services": @"businessTime",
             @"mobile": @"telePhone"};
}


+ (NSArray *)ignoredPropertyNames {
    return @[@"description"];
}

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (!oldValue || [oldValue isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    if ([property.name isEqualToString:@"tag"]) {
        return [oldValue componentsSeparatedByString:@","];
    }
    
    return oldValue;
}


- (NSString *)title {
    return self.shopName;
}

- (NSString *)subtitle {
    return nil;
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}
@end


