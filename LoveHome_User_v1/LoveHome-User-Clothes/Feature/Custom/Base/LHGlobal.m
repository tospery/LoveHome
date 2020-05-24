//
//  LHGlobal.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/16.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "LHGlobal.h"
@implementation LHGlobal {
    //    LHUser *myUser;
    //    LHCartShop *myCartInfo;
}

#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _latitude = [userDefaults doubleForKey:kUdLatitude];
        _longitude = [userDefaults doubleForKey:kUdLongitude];
        _logined = [userDefaults boolForKey:kUdLogined];
        _city = [userDefaults objectForKey:kUdCity];
        _version = [userDefaults objectForKey:kUdVersion];
        _account = [userDefaults objectForKey:kUdAccount];
        
        if (0 == _latitude && 0 == _longitude) {
            _isLocated = NO;
            _latitude = 30.67f;
            _longitude = 104.06f;
        }else {
            _isLocated = YES;
        }
        
        if (0 == _city.length) {
            _city = @"成都";
        }
    }
    return self;
}

#pragma mark - Accessor methods
- (LHUser *)user {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _user = [LHUser fetch];
    });
    return _user;
}

- (NSArray *)cartShops {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *arr = [LHCartShop fetch];
        _cartShops = [NSMutableArray arrayWithArray:arr];
        
        for (LHCartShop *cs in _cartShops) {
            cs.isEditing = NO;
            for (LHSpecify *s in cs.specifies) {
                s.isEditing = NO;
                s.selected = NO;
            }
        }
    });
    return _cartShops;
}

#pragma mark - Public methods
/**
 *  执行存储
 */
- (void)storage {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setDouble:_latitude forKey:kUdLatitude];
    [userDefaults setDouble:_longitude forKey:kUdLongitude];
    [userDefaults setBool:_logined forKey:kUdLogined];
    [userDefaults setObject:_city forKey:kUdCity];
    [userDefaults setObject:_version forKey:kUdVersion];
    [userDefaults setObject:_account forKey:kUdAccount];
    [userDefaults synchronize];
    
    [LHUser storage:self.user];
    [LHCartShop storage:self.cartShops];
}

/**
 *  退出登录时，清理必要的本地数据
 */
- (void)cleanForLogout {
    // 默认设置
    _logined = NO;
    
    // 归档文件
    _user = nil;
    
    // 数据库
//    [LHReceipt MR_truncateAll];
//    [LHCoupon MR_truncateAll];
}


#pragma mark - Class methods
/**
 *  单例类方法
 *
 *  @return 类实例
 */
+ (LHGlobal *)sharedGlobal {
    static LHGlobal *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
@end
