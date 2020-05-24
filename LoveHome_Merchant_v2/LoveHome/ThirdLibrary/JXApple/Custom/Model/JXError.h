//
//  JXError.h
//  DaiChi
//
//  Created by 杨建祥 on 15/6/23.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JXErrorCode){
    JXErrorCodeNone = 14700,
    JXErrorCodeCommon,
    JXErrorCodeDataEmpty,
    JXErrorCodeDataInvalid,
    JXErrorCodeNetworkDisable,  //网络不可用
    JXErrorCodeSessionInvalid,
    JXErrorCodeServerException,
    JXErrorCodeLoginUnregistered,
    JXErrorCodeLoginWrongPassword,
    JXErrorCodeLoginFailure,
    JXErrorCodeSigninFailure,
    JXErrorCodeAll
};

@interface JXError : NSObject
+ (NSError *)errorWithCode:(JXErrorCode)code;
+ (NSError *)errorWithCode:(JXErrorCode)code description:(NSString *)description;
@end
