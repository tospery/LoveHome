//
//  NotificationModel.m
//  LoveHome
//
//  Created by MRH-MAC on 15/9/16.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "NotificationModel.h"

@implementation NotificationModel


+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"notifId": @"id"};
}

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
//    if ([property.name isEqualToString:@"pushTime"]) {
//        
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[oldValue doubleValue]/1000];
//        NSString *pustime = GetDateNStringWith(date);
//        return pustime;
//    }
    
    return oldValue;
}

@end
