//
//  LHBasicData.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/28.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import "LHBasicData.h"

@implementation LHBasicData
MJCodingImplementation

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (!oldValue || [oldValue isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return oldValue;
}
@end
