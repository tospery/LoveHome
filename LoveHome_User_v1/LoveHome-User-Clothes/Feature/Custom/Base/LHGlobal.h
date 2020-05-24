//
//  LHGlobal.h --- 该类表示一个用作全局变量的数据集
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/16.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHUser.h"
#import "LHCartShop.h"

/**
 *  用于表示一个将用作全局变量的数据集
 */
@interface LHGlobal : NSObject
@property (nonatomic, assign) BOOL isLocated;
@property (nonatomic, assign) double longitude;     // 经度
@property (nonatomic, assign) double latitude;      // 纬度
@property (nonatomic, assign) BOOL logined;         // 是登录
@property (nonatomic, strong) NSString *city;       // 城市
@property (nonatomic, strong) NSString *version;    // 版本
@property (nonatomic, strong) NSString *account;    // 账号
@property (nonatomic, strong) LHUser *user;         // 用户基础信息
@property (nonatomic, strong) NSMutableArray *cartShops;

/**
 *  执行存储
 */
- (void)storage;

/**
 *  退出登录时，清理必要的本地数据
 */
- (void)cleanForLogout;

/**
 *  单例类方法
 *
 *  @return 类实例
 */
+ (LHGlobal *)sharedGlobal;
@end
