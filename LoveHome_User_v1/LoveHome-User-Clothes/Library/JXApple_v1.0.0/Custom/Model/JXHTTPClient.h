//
//  JXHTTPClient.h
//  LoveHome-User
//
//  Created by 杨建祥 on 15/7/4.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#ifdef JXEnableAFNetworking
#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

#define kJXHTTPFileArg              (@"kJXHTTPFileArg")
#define kJXHTTPFileName             (@"kJXHTTPFileName")
#define kJXHTTPFileData             (@"kJXHTTPFileData")

typedef NS_ENUM(NSInteger, JXHTTPMethodType){
    JXHTTPMethodTypeGet,
    JXHTTPMethodTypePost,
    JXHTTPMethodTypePut,
    JXHTTPMethodTypeDelete
};

typedef NS_ENUM(NSInteger, JXHTTPParamType){
    JXHTTPParamTypeDefault,
    JXHTTPParamTypePath,
    JXHTTPParamTypeKeyValue,
    JXHTTPParamTypeJSON,
    JXHTTPParamTypeXML
};

// AFHTTPRequestOperation参数可用于获取一些HTTP相关参数
typedef void (^JXHTTPRequestSuccessBlock)(AFHTTPRequestOperation *operation, id response);
typedef void (^JXHTTPRequestFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);
typedef void (^JXHTTPTaskSuccessBlock)(NSURLResponse *urlResponse, id response);
typedef void (^JXHTTPTaskFailureBlock)(NSURLResponse *urlResponse, NSError *error);
typedef void (^JXHTTPProgressBlock)(CGFloat progress);

@interface JXHTTPClient : NSObject
@property (nonatomic, copy) JXHTTPProgressBlock progress;

+ (AFHTTPRequestOperation *)sendBaseRequestWithBaseString:(NSString *)baseString
                                               pathString:(NSString *)pathString
                                               methodType:(JXHTTPMethodType)methodType
                                                paramType:(JXHTTPParamType)paramType
                                                   params:(id)params
                                                    files:(NSArray *)files
                                                  headers:(NSDictionary *)headers
                                                  success:(JXHTTPRequestSuccessBlock)success
                                                  failure:(JXHTTPRequestFailureBlock)failure
                                                 progress:(JXHTTPProgressBlock)progress;

+ (NSURLSessionUploadTask *)sendUploadTaskWithBaseString:(NSString *)baseString
                                              pathString:(NSString *)pathString
                                               paramType:(JXHTTPParamType)paramType
                                                  params:(id)params
                                                   files:(NSArray *)files
                                                 headers:(NSDictionary *)headers
                                                 success:(JXHTTPTaskSuccessBlock)success
                                                 failure:(JXHTTPTaskFailureBlock)failure
                                                progress:(JXHTTPProgressBlock)progress;

+ (AFHTTPRequestOperation *)sendSOAPRequestWithBaseString:(NSString *)baseString
                                            soapNamespace:(NSString *)soapNamespace
                                               soapAction:(NSString *)soapAction
                                                   params:(NSDictionary *)params
                                                  success:(JXHTTPRequestSuccessBlock)success
                                                  failure:(JXHTTPRequestFailureBlock)failure;

+ (JXHTTPClient *)sharedInstance;
@end
#endif