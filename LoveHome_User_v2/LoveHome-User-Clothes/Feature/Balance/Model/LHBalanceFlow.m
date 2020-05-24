//
//  LHBalanceFlow.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/27.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHBalanceFlow.h"

@implementation LHBalanceFlow
- (BOOL)isEqual:(id)object {
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    if (self == object) {
        return YES;
    }
    
    if ([self.orderId isEqualToString:[(LHBalanceFlow *)object orderId]]) {
        return YES;
    }
    
    return NO;
}

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (!oldValue || [oldValue isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
//    if ([property.name isEqualToString:@"dealDate"]) {
//        return [NSDate dateWithTimeIntervalSince1970:([oldValue doubleValue] / 1000)];
//    }
    
    return oldValue;
}

//+ (NSArray *)states {
//    return @[@"充值中", @"充值成功", @"充值失败", @"支付中", @"支付成功", @"支付失败", @"等待退款", @"退款中", @"退款成功", @"退款失败", @"等待划账", @"划账中", @"划账成功", @"划账失败", @"收款成功"];
//}
//
//+ (NSArray *)types {
//    return @[@"支付", @"充值", @"退款"];
//}
//
//+ (NSString *)stringForState:(LHBalanceFlowState)state {
//    if (state <= LHBalanceFlowStateNone || state >= LHBalanceFlowStateAll) {
//        return nil;
//    }
//    return [[LHBalanceFlow states] objectAtIndex:(state - 1)];
//}
//
//+ (NSString *)stringForType:(LHBalanceFlowType)type {
//    if (type <= LHBalanceFlowTypeNone || type >= LHBalanceFlowTypeAll) {
//        return nil;
//    }
//    return [[LHBalanceFlow types] objectAtIndex:(type - 1)];
//}
@end
