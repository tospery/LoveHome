//
//  LHMessage.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/20.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

//"title": "订单消息通知",
//"content": "订单号:DD22222222 已下单",
//"pushTime": 1439961969000

@interface LHMessage : NSObject
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *pushTime;

@end
