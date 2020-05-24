//
//  LHLovebeanWrapper.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/1.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHLovebeanWrapper.h"


@implementation LHLovebeanWrapper
- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (!oldValue || [oldValue isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return oldValue;
}

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"flows": @"list"};
}

+ (NSDictionary *)objectClassInArray {
    return @{@"flows": @"LHLovebeanFlow"};
}

@end
