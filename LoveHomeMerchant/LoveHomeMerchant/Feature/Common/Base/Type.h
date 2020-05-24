//
//  Type.h
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/18.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#ifndef Type_h
#define Type_h

typedef NS_ENUM(NSInteger, ClientType){
    ClientTypeNone,
    ClientTypeWeixin,
    ClientTypeiOS,
    ClientTypeAndroid,
    ClientTypeWinPhone,
    ClientTypePC
};

typedef NS_ENUM(NSInteger, UserRole){
    UserRoleNone,
    UserRoleBoos,
    UserRoleEmployee
};

typedef NS_ENUM(NSInteger, AccountStatus){
    AccountStatusNone,
    AccountStatusUnauthed,
    AccountStatusAuthing,
    AccountStatusAuthed,
    AccountStatusAuthFailed
};

typedef NS_ENUM(NSInteger, ShopStatus){
    ShopStatusNone,
    ShopStatusEnabled,
    ShopStatusDisabled
};

typedef NS_ENUM(NSInteger, BusinessStatus){
    BusinessStatusNone,
    BusinessStatusNormal,
    BusinessStatusSleeping
};

typedef NS_ENUM(NSInteger, HTTPReqOrderStatus){
    HTTPReqOrderStatusNewly = 1,        // 新增
    HTTPReqOrderStatusInservice = 4,    // 服务中
    HTTPReqOrderStatusFinished = 5,     // 已完成
    HTTPReqOrderStatusCanceled = 6      // 已取消
};


#endif /* Type_h */






