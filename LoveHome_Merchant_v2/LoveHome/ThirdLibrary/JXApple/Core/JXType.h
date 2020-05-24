//
//  JXType.h
//  MyiOS
//
//  Created by Thundersoft on 14/11/20.
//  Copyright (c) 2014年 Thundersoft. All rights reserved.
//

#ifndef MyiOS_JXType_h
#define MyiOS_JXType_h

typedef NS_ENUM(NSInteger, JXDataFetchWay){
    JXDataFetchWayFirstLoad,
    JXDataFetchWayRefresh,
    JXDataFetchWayLoadMore
};

typedef NS_ENUM(NSInteger, JXSlideDirection){
    JXSlideDirectionNone,
    JXSlideDirectionUp,
    JXSlideDirectionDown,
    JXSlideDirectionLeft,
    JXSlideDirectionRight
};

typedef NS_ENUM(NSInteger, JXRequestMode){
    JXRequestModeSilent,
    JXRequestModeLoad,
    JXRequestModeHUD,
    JXRequestModeRefresh,
    JXRequestModeMore
};
#endif
