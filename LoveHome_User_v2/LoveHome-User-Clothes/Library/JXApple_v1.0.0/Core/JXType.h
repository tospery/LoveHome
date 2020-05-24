//
//  JXType.h
//  MyiOS
//
//  Created by Thundersoft on 14/11/20.
//  Copyright (c) 2014年 Thundersoft. All rights reserved.
//

#ifndef MyiOS_JXType_h
#define MyiOS_JXType_h

typedef NS_ENUM(NSInteger, JXSlideDirection){
    JXSlideDirectionNone,
    JXSlideDirectionUp,
    JXSlideDirectionDown,
    JXSlideDirectionLeft,
    JXSlideDirectionRight
};

//typedef NS_ENUM(NSInteger, JXWebLaunchMode){
//    JXWebLaunchModeSilent,
//    JXWebLaunchModeLoad,
//    JXWebLaunchModeHUD,
//    JXWebLaunchModeRefresh,
//    JXWebLaunchModeMore
//};

typedef NS_ENUM(NSInteger, JXErrorCode){
    //    THErrorCodeSuccess = 0,
    //    THErrorCodeAccountNeed,
    //    THErrorCodePasswordNeed,
    //    THErrorCodeAccountNone,
    //    THErrorCodeAccountRepeat,
    //    THErrorCodePasswordFailure,
    //    THErrorCodeAdminNeed,
    //    THErrorCodePasswordOriginalNeed,
    //    THErrorCodeAccountFailure,
    //    THErrorCodeRecordNone,
    //    THErrorCodeParamNeed,
    //    THErrorCodeFormatIPFailure,
    //    THErrorCodePhoneNumberFailure
    
    JXErrorCodeTokenInvalid = 401,          // Token过期
    JXErrorCodeNone = 14700,
    JXErrorCodeNetworkException,            // 网路不给力
    JXErrorCodeServerException,             // 服务器异常
    JXErrorCodeDataEmpty,                   // 数据为空
    
    // 待整理
    JXErrorCodeCommon,
    JXErrorCodeDataInvalid,
    JXErrorCodeSessionInvalid,
    JXErrorCodeLoginUnregistered,
    JXErrorCodeLoginWrongPassword,
    JXErrorCodeLoginFailure,
    JXErrorCodeSigninFailure,
    JXErrorCodeDeviceNotSupport,
    JXErrorCodeFileNotPicture,
    JXErrorCodeLocateFailure,
    JXErrorCodeLocateClosed,
    JXErrorCodeLocateDenied,
    JXErrorCodeAll
};


typedef NS_ENUM(NSInteger, JXWebLaunchMode){
    JXWebLaunchModeSilent,
    JXWebLaunchModeLoad,
    JXWebLaunchModeHUD,
    JXWebLaunchModeRefresh,
    JXWebLaunchModeMore
};

typedef NS_ENUM(NSInteger, JXWebHandleWay){
    JXWebHandleWaySilent,
    JXWebHandleWayShow,
    JXWebHandleWayToast
};

// 登录相关block
typedef void (^JXLoginDidPresentCallback)(void);    // 登录控制器显示之后的callback
typedef void (^JXLoginDidPassCallback)(void);       // 通过登录验证
typedef void (^JXLoginReloginWillFinishCallback)(void);    // 重新登录成功
typedef void (^JXLoginReloginDidFinishCallback)(void);    // 重新登录成功
typedef void (^JXLoginDidPassOrReloginDidFinishCallback)(void);     // 已经登录或者完成重新登录（上面两个callback的集合）

// Web相关
typedef void (^JXWebResultCallback)(void);

typedef void (^JXProcessViewCallbackBlock)(void);
typedef void (^JXLoadResultCallback)(void);
typedef void (^JXLoginResultCallback)(BOOL isRelogin);


#endif







