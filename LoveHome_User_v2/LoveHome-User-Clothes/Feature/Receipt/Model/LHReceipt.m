//
//  LHAddress.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/24.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHReceipt.h"


@implementation LHReceipt
MJCodingImplementation

- (BOOL)isEqual:(id)object {
    if (!object || ![object isKindOfClass:[LHReceipt class]]) {
        return NO;
    }
    
    if (self == object) {
        return YES;
    }
    
    if ([self.receiptID isEqualToString:[(LHReceipt *)object receiptID]]) {
        return YES;
    }
    
    return NO;
}

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (!oldValue || [oldValue isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    if ([property.name isEqualToString:@"isDefault"]) {
        return ([(NSNumber *)oldValue integerValue] == 1) ? @(YES) : @(NO);
    }
    
    return oldValue;
}

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"receiptID": @"id"};
}

+ (LHReceipt *)fetch {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[LHReceipt getLocalFile]];
}

+ (void)storage:(LHReceipt *)receipt {
    [NSKeyedArchiver archiveRootObject:receipt toFile:[LHReceipt getLocalFile]];
}

+ (NSString *)getLocalFile {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"receipt.data"];
}
@end





