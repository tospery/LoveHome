//
//  HttpServiceManageObject.m
//  LoveHome
//
//  Created by MRH on 14/11/20.
//  Copyright (c) 2014年 卡莱博尔. All rights reserved.
//

#import "HttpServiceManageObject.h"
#import "AFNetworkReachabilityManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSString+StringManage.h"
#import "AFURLSessionManager.h"
#import "LHError.h"
#import "ErrorHandleTool.h"


const NSTimeInterval HttpServerManage_RequestTimeoutInterval  = 60;//请求超时时间限制
const NSTimeInterval HttpServerManage_RequestContent_PageSize = 10;//请求一页的数据条数


@interface HttpServiceManageObject()


@end


@implementation HttpServiceManageObject


#pragma mark 网络判断
/*!
 *  @brief  判断网络是否可用（不区分具体网络类型）
 *
 *  @return BOOL
 */
+ (BOOL)isInternetAvailable
{
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}


/*!
 *  @brief  判断Wifi是否可用
 *
 *  @return BOOL
 */
+ (BOOL)IsEnableWIFI
{
    return [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
}


/*!
 *  @brief  判断运营商网络是否可用
 *
 *  @return BOOL
 */
+ (BOOL)IsEnableWWAN
{
    return [[AFNetworkReachabilityManager sharedManager] isReachableViaWWAN];
}


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
                                 andConditions:(NSDictionary *)conditionDic
{
    if (conditionDic && [[conditionDic allKeys] count] > 0)
    {
        NSDictionary *queryParaDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:currentPage],@"current",
                                      [NSNumber numberWithInt:pageSize],@"pageCapacity",
                                      conditionDic,@"conditions", nil];
        
        return queryParaDic;
    }
    return nil;
}


/*!
 *  @brief  生成图片地址
 *
 *  @param baseUrl
 *  @param pathUrl
 *
 *  @return 图片地址
 */
+ (NSString *)generateImageUrlWithBaseUrl:(NSString *)baseUrl andPathUrl:(NSString *)pathUr
{
    if (baseUrl && pathUr && [baseUrl length] > 0 && [pathUr length] > 0)
    {
        NSString *addressStr = [[NSURL URLWithString:pathUr relativeToURL:[NSURL URLWithString:baseUrl]] absoluteString];
        
        return addressStr;
    }
    return nil;
}


/*!
 *  @brief  获取公共的请求header参数
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)getCommonRequestHeaderParameter
{
    NSString *appVersionStr    = GetAppVersionCodeInfo();
    NSString *appDeviceInfoStr = GetCurrentDeviceBaseInfo();
    
    NSDictionary *commonHeaderParaDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"IOS_BIZUSER",@"app_patch",
                                         (appVersionStr && [appVersionStr length] > 0)?[NSString stringWithFormat:@"%@ RELEASE",appVersionStr]:@"没有获取到版本号",@"app_version",
                                         appDeviceInfoStr,@"app_device_info", nil];
    
    return commonHeaderParaDic;
}

#pragma mark - 请求方法
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
                                   andFailedCallback:(HttpServiceBasicFailBackBlock)failedCallback
{
    NSDictionary *headerDic = nil;
    if (tokenStr)
    {
        NSString *token = [UserTools sharedUserTools].userModel.token;
        headerDic = @{@"token": (0 != token.length) ? token : @""};
    }

    if (urlString && [urlString length] > 0)
    {
        return [HttpServiceManageObject sendBaseRequestWithPathUrl:urlString
                                                    addHeaderField:headerDic
                                                     andMethodType:kHttpRequestMethodType_Get
                                                  andParameterType:kHttpRequestParameterType_None
                                                   andParameterDic:paraDic
                                                     andImageArray:nil
                                                andSucceedCallback:succeedCallback
                                                 andFailedCallback:failedCallback];
    }
    return nil;
}


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
                                    andFailedCallback:(HttpServiceBasicFailBackBlock)failedCallback
{
    if (urlString && [urlString length] > 0)
    {
        return [HttpServiceManageObject sendPostRequestWithPathUrl:urlString
                                                          andToken:nil
                                                   andParameterDic:paramDic
                                                  andParameterType:parameterType
                                                andSucceedCallback:succeedCallback
                                                 andFailedCallback:failedCallback];
    }
    return nil;
}


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
                                    andFailedCallback:(HttpServiceBasicFailBackBlock)failedCallback
{
    NSDictionary *headerDic = nil;
    if (tokenStr)
    {
        NSString *token = [UserTools sharedUserTools].userModel.token;
        headerDic = @{@"token": (0 != token.length) ? token : @""};
    }
    
    if (urlString && [urlString length] > 0)
    {
        return [HttpServiceManageObject sendBaseRequestWithPathUrl:urlString
                                                    addHeaderField:headerDic
                                                     andMethodType:kHttpRequestMethodType_Post
                                                  andParameterType:parameterType
                                                   andParameterDic:paramDic
                                                     andImageArray:nil
                                                andSucceedCallback:succeedCallback
                                                 andFailedCallback:failedCallback];
    }
    
    return nil;
}


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

                                               andFailedCallback:(void(^)(NSError *error))failedCallback
{
    NSDictionary *headerDic = nil;
    if (tokenStr)
    {
        //        NSString *token = [UserTools sharedUserTools].userModel.token;
        headerDic = @{@"token": tokenStr};
    }
    
    if (urlString && [urlString length] > 0)
    {
        NSString *requestUrlStr = [NSString stringWithFormat:@"%@%@",kHTTPServer,urlString];
        
        TTRSLog(@"图片上传的url: %@",requestUrlStr);
        
        
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestUrlStr parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                        {
                                            
                                            for (NSString *key in imageArray.allKeys) {
                                                id imageObject = imageArray[key];
                                                if ([imageObject isKindOfClass:[NSData class]])
                                                {
                                                    [formData appendPartWithFileData:imageObject name:key fileName:@"filename.jpg" mimeType:@"image/jpeg"];
                                                    
                                                }
                                            }
                                            
                                            
                                        } error:nil];
        
        //添加公共的header信息
        NSDictionary *commonHeaderParaDic = [HttpServiceManageObject getCommonRequestHeaderParameter];
        if (commonHeaderParaDic && [[commonHeaderParaDic allKeys] count] > 0)
        {
            for (NSString* key in [commonHeaderParaDic allKeys])
            {
                [request addValue:[commonHeaderParaDic objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        // 添加TokenHeard
        if (headerDic)
        {
            for (NSString* key in [headerDic allKeys])
            {
                [request addValue:[headerDic objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.timeoutIntervalForRequest  = HttpServerManage_RequestTimeoutInterval;
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
        NSProgress *progress = nil;
        
        NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error)
            {
                failedCallback(error);
            } else
            {
                
                succeedCallback(responseObject);
            }
        }];
        
        [uploadTask resume];
        
        return uploadTask;
    }
    
    return nil;
}


/*!
 *  @brief  Base数据请求
 *
 *  @param urlString       接口地址
 *  @param addHeaders      添加httpRequestHeader信息
 *  @param methodType      请求的方法名 （支持： GET, POST, PUT, DELETE）
 *  param  parameterType   参数类型    （支持： PATH, KEYVAULE , JSON）
 *  @param paramDic        请求参数
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
                                    andFailedCallback:(HttpServiceBasicFailBackBlock)failedCallback
{
    if (urlString && [urlString length] > 0)
    {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kHTTPServer]];
        
        //设置请求参数类型
        if (methodType == kHttpRequestMethodType_Post && parameterType == kHttpRequestParameterType_JSON)
        {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
        }
        
        
        //设置请求超时时间限制
        manager.requestSerializer.timeoutInterval = HttpServerManage_RequestTimeoutInterval;
        
        
        //设置请求方法
        NSString *requestMethodsStr = @"POST";
        switch (methodType)
        {
            case kHttpRequestMethodType_Get:{
                requestMethodsStr = @"GET";
                break;}
            case kHttpRequestMethodType_Post:{
                requestMethodsStr = @"POST";
                break;}
            case kHttpRequestMethodType_Put:{
                requestMethodsStr = @"PUT";
                break;}
            case kHttpRequestMethodType_Delete:{
                requestMethodsStr = @"DELETE";
                break;}
            default:
                break;
        }
        
        
        NSMutableURLRequest *request = nil;
        if (imageArray && [imageArray count] > 0)
        {
            request = [manager.requestSerializer multipartFormRequestWithMethod:requestMethodsStr URLString:[[NSURL URLWithString:urlString relativeToURL:manager.baseURL] absoluteString] parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
                
                for (int i=0; i<[imageArray count]; i++) {
                    id imageObject = [imageArray objectAtIndex:i];
                    if ([imageObject isKindOfClass:[NSData class]])
                    {
                        [formData appendPartWithFileData:imageObject name:@"modelid" fileName:@"21312" mimeType:@"image/png"];
                        
                    }
                }
            }
                                                                          error:
                       nil];
        }else
        {
            request = [manager.requestSerializer requestWithMethod:requestMethodsStr
                                                         URLString:[[NSURL URLWithString:urlString relativeToURL:manager.baseURL] absoluteString]
                                                        parameters:paramDic error:nil];
        }
        
        
        //添加图片
        
        
        //添加RequestHeaderField信息
        if (addHeaders && [[addHeaders allKeys] count] > 0)
        {
            for (NSString* key in [addHeaders allKeys])
            {
                [request addValue:[addHeaders objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        //添加公共的header信息
        //        NSDictionary *commonHeaderParaDic = [HttpServiceManageObject getCommonRequestHeaderParameter];
        //        if (commonHeaderParaDic && [[commonHeaderParaDic allKeys] count] > 0)
        //        {
        //            for (NSString* key in [commonHeaderParaDic allKeys])
        //            {
        //                [request addValue:[commonHeaderParaDic objectForKey:key] forHTTPHeaderField:key];
        //            }
        //        }
        
        
        
        NSLog(@"请求: \nservice = %@\nparams = %@", urlString, paramDic);
        AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"成功响应: %@", responseObject);
            NSDictionary *dic = responseObject;
            NSInteger code = [[dic objectForKey:@"code"] integerValue];
            if (200 != code) {
                
                NSError *erro = [LHError errorWithCode:code description:dic[@"description"]];
                failedCallback(operation,erro);
                
            }
            else
            {
              //  NSLog(@"%@", operation);
                succeedCallback(operation, [responseObject objectForKey:@"data"]);
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"失败响应: %@", error);
            NSError *myError = error;
            
            if (error.code == -1004 ) {
                myError = [JXError errorWithCode:JXErrorCodeNetworkDisable description:@"不能连接到服务器,请稍后再试"];
            }
            else
            {
                
                myError = [ErrorHandleTool errorWithCode:error];
                
            }
            
            
            
            failedCallback(operation,myError);
        }];
        [manager.operationQueue addOperation:operation];
        
        return operation;
    }
    return nil;
}


#pragma mark - 数据解析

+(NSDictionary *)getCommonRequestHeaderParamWithToken:(NSString *)tokenStr
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    return paramDic;
    
}


/*!
 *  @brief  判断业务层操作是否成功
 *
 *  @param resultDic 请求返回的object
 *
 *  @return BOOL
 */
+ (BOOL)isRequestSucceed:(NSDictionary *)resultDic
{
    BOOL isSuccced = NO;
    
    if (resultDic && [[resultDic allKeys] count] > 0)
    {
        NSNumber *statusNumber = [NSNumber numberWithInteger:[[resultDic objectForKey:@"status"] integerValue]];
        if ([statusNumber isEqualToNumber:[NSNumber numberWithInteger:1]])
        {
            isSuccced = YES;
        }
    }
    
    return isSuccced;
}


/*!
 *  @brief  判断业务层操作是否成功Token
 *
 *  @param resultDic 请求返回的object
 *
 *  @return BOOL
 */
+ (BOOL)isSessionInvaild:(NSDictionary *)resultDic
{
    NSString *msgKeyStr = [HttpServiceManageObject getRequestResponseMsgKey:resultDic];
    
    if (msgKeyStr && [msgKeyStr length] > 0)
    {
        if ([msgKeyStr isEqualToString:HttpRequestFailed_MsgKey_SessionInvaild])
        {
            return YES;
        }
    }
    
    return NO;
}

/*!
 *  @brief  判断业务层返回是否为空
 *
 *  @param resultDic 请求返回的object
 *
 *  @return BOOL
 */

+ (BOOL)isServerCrash:(id )response
{
    BOOL sccess = NO;
    if (response == nil) {
        sccess = YES;
        
        ShowAlertView(@"提示", @"服务器异常请稍后再试", @"确定", nil);
        
        return sccess;
        
    }
    else
    {
        return sccess;
    }
    
    
}


/*!
 *  @brief  获取请求响应的MsgKey
 *
 *  @param resultDic 请求返回的object
 *
 *  @return MessageKey
 */
+ (NSString *)getRequestResponseMsgKey:(NSDictionary *)resultDic
{
    if (resultDic && [[resultDic allKeys] count] > 0)
    {
        NSString *msgKeyStr = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"msgKey"]];
        
        if (msgKeyStr && [msgKeyStr length] > 0)
        {
            return msgKeyStr;
        }
    }
    return nil;
}


/*!
 *  @brief  获取Content数据
 *
 *  @param resultDic 请求返回的object
 *
 *  @return BOOL
 */
+ (id)getContentFromResponseData:(NSDictionary *)resultDic
{
    if (resultDic && [[resultDic allKeys] count] > 0)
    {
        return [resultDic objectForKey:@"content"];
    }
    return nil;
}


/*!
 *  @brief  解析cookie
 *
 *  @param request 请求对象
 *
 *  @return NSString
 */
+ (NSString *)analyticCookieValueFromRequest:(AFHTTPRequestOperation *)request
{
    NSString *setCookiesStr       = [[[request response] allHeaderFields] objectForKey:@"Set-Cookie"];
    TTRSLog(@"%@",[[request response] allHeaderFields]);
    NSString *cookiesStr          = [[[request response] allHeaderFields] objectForKey:@"Cookie"];
    NSString *resonseCookieString = (setCookiesStr && [setCookiesStr length] > 0)?setCookiesStr:cookiesStr;
    
    if (resonseCookieString && [resonseCookieString length] > 0)
    {
        NSRange range          = [resonseCookieString rangeOfString:@"JSESSIONID="];
        
        NSString *string       = [[resonseCookieString componentsSeparatedByString:@";"] objectAtIndex:0];
        
        NSString *resultString = [string substringFromIndex:range.location+range.length];
        
        return resultString;
    }
    
    return nil;
}

+ (void)updataLoadingUrl:(NSString *)url andParameters:(NSDictionary *)paramter
            andFiledData:(NSData *)data
         andSucessCalled:(HttpServiceBasicSucessBackBlock)scuceess
                     and:(HttpServiceBasicFailBackBlock)failed
{
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kHTTPServer]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = HttpServerManage_RequestTimeoutInterval;
    
    [manager POST:[[NSURL URLWithString:url relativeToURL:manager.baseURL] absoluteString] parameters:paramter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"modelid" fileName:@"21312" mimeType:@"image/png"];
    } success:scuceess failure:failed];
    
    
}


#pragma mark 提示信息

/*!
 *  @brief  请求超时的提示
 */
+ (void)showHttpRequestTimeoutAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据请求超时，请重试。" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alertView show];
}

/*!
 *  @brief  服务器停止服务的提示
 */
+ (void)showHttpRequestStopTheServer
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器异常，请稍后再试。" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alertView show];
}

@end
