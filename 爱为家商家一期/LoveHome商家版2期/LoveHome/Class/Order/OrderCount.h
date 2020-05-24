//
//  OrderCount.h
//  LoveHome
//
//  Created by 杨建祥 on 15/8/31.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderCount : NSObject
@property (nonatomic, assign) NSUInteger finishedCount;     // 完成
@property (nonatomic, assign) NSUInteger newlyIncreasedCount; // 新增
@property (nonatomic, assign) NSUInteger notResponseCount;  // 未响应
@property (nonatomic, assign) NSUInteger rejectedCount;     // 拒绝
@property (nonatomic, assign) NSUInteger servingCount;      // 服务

@end
