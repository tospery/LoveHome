//
//  RHType.h
//  RHKitv1.0
//
//  Created by MRH on 15/2/9.
//  Copyright © 2015年 MRH-MAC. All rights reserved.
//

#ifndef RHType_h
#define RHType_h


typedef NS_ENUM(NSInteger, RHErrorCode){
    RHErrorCodeTokenInvalid = 401,          // Token过期
    RHErrorCodeNone = 14700,
    RHErrorCodeNetworkException,            // 网路不给力
    RHErrorCodeServerException,             // 服务器异常
    RHErrorCodeDataEmpty,                 // 数据为空};

    //待整理
    RHErrorCodeNetworkDisable,
    RHErrorCodeSessionInvalid,
    RHErrorCodeLoginUnregistered,
    RHErrorCodeLoginWrongPassword,
    RHErrorCodeLoginFailure,
    RHErrorCodeSigninFailure,
    RHErrorCodeAll
};


/*******请求操作方式******/
typedef NS_ENUM(NSInteger, RHWebLaunchType){
    RHWebLaunchTypeSilent,
    RHWebLaunchTypeLoad,
    RHWebLaunchTypeHUD,
    RHWebLaunchTypeRefresh,
    RHWebLaunchTypeMore
};


/*****错误提示方式*******/
typedef NS_ENUM(NSInteger, RHErrorShowType){
    RHErrorShowTypeSilent,
    RHErrorShowTypeHUD,
    RHErrorShowTypeLoad
};

typedef void (^RHLoadResultCallback)(void);


#endif /* RHType_h */
