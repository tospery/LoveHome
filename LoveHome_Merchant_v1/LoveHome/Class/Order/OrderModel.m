//
//  OrderModel.m
//  LoveHome
//
//  Created by 杨建祥 on 15/8/27.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "OrderModel.h"


@implementation OrderModel
MJCodingImplementation

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"orderid": @"id"};
}

+ (NSDictionary *)objectClassInArray {
    return @{@"orderDetailList": @"OrderDetailModel"};
}

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    

    if (!oldValue||[oldValue isKindOfClass:[NSNull class]]) {
        
        if ([property.type.typeClass isSubclassOfClass:[NSString class]]) {
            return @"";
        }
        else
        {
            return nil;
        }
    }
    
//    if ([property.name isEqualToString:@"orderTime"]) {
//        
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[oldValue doubleValue]/1000];
//    }
    
    return oldValue;
}

- (BOOL)isEqual:(id)object {
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    if (self == object) {
        return YES;
    }
    
    if ([self.orderid isEqualToString:[(OrderModel *)object orderid]]) {
        return YES;
    }
    
    return NO;
}



//- (void)setValue:(id)value forKey:(NSString *)key
//{
//    if ([key isEqualToString:@"orderDetailList"]) {
//     
//        NSArray *vlue1 = (NSArray *)value;
//        NSMutableArray *mutable;
//        for (NSDictionary *dic in vlue1) {
//            
//            OrderDetailModel *delait = [[OrderDetailModel alloc] init];
//            [delait setValuesForKeysWithDictionary:dic];
//            
//        }
//        
//        self.orderDetailList = mutable;
//        
//        return;
//    }
//    [super setValue:value forKey:key];
//}
//
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key
//{
//    
//}

@end
