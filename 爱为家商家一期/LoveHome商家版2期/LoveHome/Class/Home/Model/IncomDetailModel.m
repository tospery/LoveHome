//
//  IncomDetailModel.m
//  LoveHome
//
//  Created by MRH-MAC on 15/9/6.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "IncomDetailModel.h"

@implementation IncomDetailModel

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
//    if ([property.name isEqualToString:@"dealDate"]) {
//        
//        return [NSDate dateWithTimeIntervalSince1970:[oldValue doubleValue]/1000];
//    }
    return oldValue;
}
@end
