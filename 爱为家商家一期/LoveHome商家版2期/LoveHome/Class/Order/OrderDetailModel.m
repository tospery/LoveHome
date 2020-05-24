//
//  OrderDetailModel.m
//  LoveHome
//
//  Created by 杨建祥 on 15/8/27.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel
MJCodingImplementation

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
    
    if ([property.name isEqualToString:@"specName"]) {
        
        NSString *string = (NSString *)oldValue;
        
        if (string.length >= 1) {
            return [NSString stringWithFormat:@"(%@)",oldValue];
        }
        

        
    }
  
    return oldValue;
}

@end
