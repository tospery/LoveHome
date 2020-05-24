//
//  RHCharModels.m
//  LoveHome
//
//  Created by MRH on 15/12/5.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import "RHCharMode.h"


@implementation RHCharMode
- (instancetype)init
{
    self = [super init];
    if (self) {
        _chartFillColor = [UIColor clearColor];
        _chartListData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if ([self.name isEqualToString:[(RHCharMode *)object name]]) {
        return YES;
    }
    
    if (self == object) {
        return YES;
    }
    return NO;
}

@end
