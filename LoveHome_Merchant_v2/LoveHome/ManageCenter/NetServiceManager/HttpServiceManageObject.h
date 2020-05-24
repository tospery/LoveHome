//
//  HttpServiceManageObject.h
//  LoveHome
//
//  Created by MRH on 14/11/20.
//  Copyright (c) 2014年 卡莱博尔. All rights reserved.
//
/*https://github.com/AFNetworking/AFNetworking*/

#import <Foundation/Foundation.h>

#pragma mark - 开发网络的选择, 第二个为测试网址,第三个开发内网,第四个是发布外网

//#define kHTTPServer (@"http://183.220.1.29:40800/appvworks.portal/")
//#define kHTTPServer (@"http://ivhome-test.appvworks.com/appvworks.portal/") // 测试环境
//#define kHTTPServer (@"http://192.168.10.235:8080/appvworks.portal/") //开发环境
//#define kHTTPServer (@"https://api.appvworks.com/") //发布环境
#define kHTTPServer (@"http://192.168.2.61:8080/appvworks.portal/")      // shizheng
//#define kHTTPServer (@"http://192.168.199.123:8080/appvworks.portal/")
//#define kHTTPServer (@"http://192.168.2.70:8080/appvworks.portal/")




//网络数据请求的数量大小限制
extern const NSTimeInterval HttpServerManage_RequestContent_PageSize;
//网络数据请求的请求超时时间
extern const NSTimeInterval HttpServerManage_RequestTimeoutInterval;


typedef enum {
    kHttpRequestMethodType_None = 0,
    kHttpRequestMethodType_Get,
    kHttpRequestMethodType_Post,
    kHttpRequestMethodType_Put,
    kHttpRequestMethodType_Delete
}HttpRequestMethodType;     //请求方法类型

typedef enum {
    kHttpRequestParameterType_None = 0,
    kHttpRequestParameterType_Path,
    kHttpRequestParameterType_KeyValue,
    kHttpRequestParameterType_JSON,
}HttpRequestParameterType;  //请求参数类型



@class AFHTTPRequestOperation;


//Block的定义
typedef void (^HttpServiceBasicSucessBackBlock)(AFHTTPRequestOperation *operation,id responsObject);

typedef void (^HttpServiceBasicFailBackBlock) (AFHTTPRequestOperation *operation, NSError *error);



@interface HttpServiceManageObject : NSObject
{
    HttpServiceBasicSucessBackBlock requestSucceedCallback;
    HttpServiceBasicFailBackBlock   requestFailedCallback;
}

#pragma mark 网络判断

/*!
 *  @brief  判断网络是否可用（不区分具体网络类型）
 *
 *  @return BOOL
 */
+ (BOOL)isInternetAvailable;


/*!
 *  @brief  判断Wifi是否可用
 *
 *  @return BOOL
 */
+ (BOOL)IsEnableWIFI;


/*!
 *  @brief  判断运营商网络是否可用
 *
 *  @return BOOL
 */
+ (BOOL)IsEnableWWAN;


#pragma mark 参数相关
/*!
 *  @brief  获取公共参数（查询类接口）
 *
 *  @param currentPage  请求的页面数
 *  @param pageSize     请求的当前页面的数量
 *  @param conditionDic 查询条件参数
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)getQueryParameterWithCurrent:(int)currentPage
                                   andPageSize:(int)pageSize
                                 andConditions:(NSDictionary *)conditionDic;

/*!
 *  @brief  生成图片地址
 *
 *  @param baseUrl
 *  @param pathUrl
 *
 *  @return 图片地址
 */
+ (NSString *)generateImageUrlWithBaseUrl:(NSString *)baseUrl andPathUrl:(NSString *)pathUrl;



#pragma mark 请求方法

/*!
 *  @brief  发送Get请求
 *
 *  @param urlString       接口地址
 *  @param succeedCallback 请求成功的回调
 *  @param failedCallback  请求失败的回调
 *
 *  @return AFHTTPRequestOperation
 */
+(AFHTTPRequestOperation *)sendGetRequestWithPathUrl:(NSString *)urlString
                                          andToken:(BOOL)tokenStr
                                          andParaDic:(NSDictionary *)paraDic
                                  andSucceedCallback:(HttpServiceBasicSucessBackBlock)succeedCallback
                                   andFailedCallback:(HttpServiceBasicFailBackBlock)failedCallback;


/*!
 *  @brief  发送Post请求，不带token
 *
 *  @param urlString       接口地址
 *  @param paramDic        请求参数
 *  @param succeedCallback 请求成功的回调
 *  @param failedCallback  请求失败的回调
 *
 *  @return AFHTTPRequestOperation
 */
+(AFHTTPRequestOperation *)sendPostRequestWithPathUrl:(NSString *)urlString
                                      andParameterDic:(id)paramDic
                                     andPatameterType:(HttpRequestParameterType)parameterType
                                   andSucceedCallback:(HttpServiceBasicSucessBackBlock)succeedCallback
                                    andFailedCallback:(HttpServiceBasicFailBackBlock)failedCallback;


/*!
 *  @brief  发送Post请求，带Token
 *
 *  @param urlString       接口地址
 *  @param paramDic        请求参数
 *  @param succeedCallback 请求成功的回调
 *  @param failedCallback  请求失败的回调
 *
 *  @return AFHTTPRequestOperation
 */
+(AFHTTPRequestOperation *)sendPostRequestWithPathUrl:(NSString *)urlString
                                             andToken:(BOOL)tokenStr
                                      andParameterDic:(id)paramDic
                                     andParameterType:(HttpRequestParameterType)parameterType
                                   andSucceedCallback:(HttpServiceBasicSucessBackBlock)succeedCallback
                                    andFailedCallback:(HttpServiceBasicFailBackBlock)failedCallback;



/*!
 *  @brief  发送Post上传图片请求，带Token
 *
 *  @param urlString       接口地址
 *  @param paramDic        请求参数
 *  @param imageArray      上传的图片data数组（NSArray里面只能放NSData对象）
 *  @param succeedCallback 请求成功的回调
 *  @param failedCallback  请求失败的回调
 *
 *  @return AFHTTPRequestOperation
 */
+(NSURLSessionUploadTask *)sendPostUploadImageRequestWithPathUrl:(NSString *)urlString

                                                        andToken:(NSString *)tokenStr

                                                 andParameterDic:(id)paramDic

                                                   andImageArray:(NSDictionary *)imageArray

                                              andSucceedCallback:(void(^)(id response))succeedCallback

                                               andFailedCallback:(void(^)(NSError *error))failedCallback;




/*!
 *  @brief  Base数据请求
 *
 *  @param urlString       接口地址
 *  @param addHeaders      添加httpRequestHeader信息
 *  @param methodType      请求的方法名 （支持： GET, POST, PUT, DELETE）
 *  param  parameterType   参数类型    （支持： PATH, KEYVAULE , JSON）
 *  @param paramDic        请求参数
 *  @param imageArray      上传的图片data数组（NSArray里面只能放NSData对象）
 *  @param succeedCallback 请求成功的回调
 *  @param failedCallback  请求失败的回调
 *
 *  @return AFHTTPRequestOperation
 */
+(AFHTTPRequestOperation *)sendBaseRequestWithPathUrl:(NSString *)urlString
                                       addHeaderField:(NSDictionary *)addHeaders
                                        andMethodType:(HttpRequestMethodType)methodType
                                     andParameterType:(HttpRequestParameterType)parameterType
                                      andParameterDic:(id)paramDic
                                        andImageArray:(NSArray *)imageArray
                                   andSucceedCallback:(HttpServiceBasicSucessBackBlock)succeedCallback
                                    andFailedCallback:(HttpServiceBasicFailBackBlock)failedCallback;



#pragma mark 数据解析
/*!
 *  @brief  判断业务层操作是否成功
 *
 *  @param resultDic 请求返回的object
 *
 *  @return BOOL
 */
+ (BOOL)isRequestSucceed:(NSDictionary *)resultDic;


/*!
 *  @brief  判断业务层操作Token是否成功
 *
 *  @param resultDic 请求返回的object
 *
 *  @return BOOL
 */
+ (BOOL)isSessionInvaild:(NSDictionary *)resultDic;


/*!
*  @brief  判断业务层返回是否为空
*
*  @param resultDic 请求返回的object
*
*  @retur
*/

+ (BOOL)isServerCrash:(id )response;

/*!
 *  @brief  获取请求响应的MsgKey
 *
 *  @param resultDic 请求返回的object
 *
 *  @return MessageKey
 */
+ (NSString *)getRequestResponseMsgKey:(NSDictionary *)resultDic;


/*!
 *  @brief  获取Content数据
 *
 *  @param resultDic 请求返回的object
 *
 *  @return BOOL
 */
+ (id)getContentFromResponseData:(NSDictionary *)resultDic;


/*!
 *  @brief  解析cookie
 *
 *  @param request 请求对象
 *
 *  @return NSString
 */
+ (NSString *)analyticCookieValueFromRequest:(AFHTTPRequestOperation *)request;



+ (void)updataLoadingUrl:(NSString *)url andParameters:(NSDictionary *)paramter
            andFiledData:(NSData *)data
         andSucessCalled:(HttpServiceBasicSucessBackBlock)scuceess
                     and:(HttpServiceBasicFailBackBlock)failed;

#pragma mark 提示信息

/*!
 *  @brief  请求超时的提示
 */
+ (void)showHttpRequestTimeoutAlert;

/*!
 *  @brief  服务器停止服务的提示
 */
+ (void)showHttpRequestStopTheServer;

@end

