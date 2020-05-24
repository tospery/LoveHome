//
//  OrderCount.m
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/21.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "OrderCount.h"

@implementation OrderCount
- (BOOL)isEqual:(id)object {
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    if (self == object) {
        return YES;
    }
    
    OrderCount *other = (OrderCount *)object;
    if ((_newlyIncreasedCount == other.newlyIncreasedCount) &&
        (_notResponseCount == other.notResponseCount) &&
        (_colletingCount == other.colletingCount) &&
        (_servingCount == other.servingCount) &&
        (_finishedCount == other.finishedCount) &&
        (_rejectedCount == other.rejectedCount)) {
        
    }
    
    return NO;
}

@end
