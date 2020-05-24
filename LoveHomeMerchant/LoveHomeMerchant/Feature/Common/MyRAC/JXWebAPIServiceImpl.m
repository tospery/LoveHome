//
//  JXWebAPIServiceImpl.m
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/17.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "JXWebAPIServiceImpl.h"
#import "HTTPResponseBase.h"

#define JXWebAPIServiceImplDataKey                  (@"data")

@implementation JXWebAPIServiceImpl
#pragma mark - Private
- (void)handleResponse:(id)response subscriber:(id<RACSubscriber>)subscriber class:(Class)cls {
    HTTPResponseBase *base = [HTTPResponseBase mj_objectWithKeyValues:response];
    if (kHTTPResponseSuccess != base.code) {
        [subscriber sendError:[NSError exErrorWithCode:base.code description:base.des]];
        return;
    }
    
    id data = [response objectForKey:JXWebAPIServiceImplDataKey];
    id obj = data;
    
    if (cls) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            obj = [cls mj_objectWithKeyValues:data];
        }else if ([data isKindOfClass:[NSArray class]]) {
            obj = [cls mj_objectArrayWithKeyValuesArray:data];
        }
    }
    
    //    if ([cls isSubclassOfClass:NSManagedObject.class]) {
    ////        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    ////        NSArray *fetchedObjects = [_coreDataHelper.context executeFetchRequest:request error:nil];
    ////        for (Item *item in fetchedObjects) {
    ////            [_coreDataHelper.context deleteObject:item];
    ////        }
    //       // NSString *bb = NSStringFromClass(cls);
    //
    //    }else if (!cls) {
    //        if ([data isKindOfClass:[NSDictionary class]]) {
    //            obj = [cls mj_objectWithKeyValues:data];
    //        }else if ([data isKindOfClass:[NSArray class]]) {
    //            obj = [cls mj_objectArrayWithKeyValuesArray:data];
    //        }
    //    }else {
    //        obj = data;
    //    }
    
    [subscriber sendNext:obj];
    [subscriber sendCompleted];
}

- (void)handleError:(NSError *)error subscriber:(id<RACSubscriber>)subscriber {
    if (3840 == error.code ||
        -1011 == error.code) {
        error = [NSError exErrorWithCode:JXErrorCodeServerException];
    }
    // YJX_TODO 登录失效的error
    [subscriber sendError:error];
}

#pragma mark - Public
- (RACSignal *)requestWithParam:(HTTPRequestParam *)param {
    return [self requestWithParam:param schema:[HTTPRequestSchema schemaDft] class:nil];
}

- (RACSignal *)requestWithParam:(HTTPRequestParam *)param schema:(HTTPRequestSchema *)schema {
    return [self requestWithParam:param schema:schema class:nil];
}

- (RACSignal *)requestWithParam:(HTTPRequestParam *)param class:(Class)cls {
    return [self requestWithParam:param schema:[HTTPRequestSchema schemaDft] class:cls];
}

- (RACSignal *)requestWithParam:(HTTPRequestParam *)param schema:(HTTPRequestSchema *)schema class:(Class)cls {
#ifndef kHTTPBaseURLString
    JXLogError(@"未定义kHTTPBaseURLString！！！");
    return nil;
#endif
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[param mj_JSONObject]];
    [params removeObjectForKey:@"pathURLString"]; // YJX_TODO 这些方法应该封装到HTTPRequestParam中
    [params exRemoveObjectsWithValue:@(kJXHTTPParamValueIgnoreNum)];
    NSDictionary *headers = [params exRemoveObjectsForKeys:@[@"token"]];
    
    id urlParams = nil;
    id bodyParams = nil;
    if (JXHTTPRequestMethodTypeGet == schema.requestMethodType) {
        urlParams = params;
    }else if (JXHTTPRequestMethodTypePost == schema.requestMethodType) {
        bodyParams = params;
    }
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *operation = [JXHTTPClient sendBaseRequestWithBaseURLString:kHTTPBaseURLString pathURLString:param.pathURLString methodType:schema.requestMethodType requestContentType:schema.requestContentType responseContentType:schema.responseContentType pathVariable:nil urlParams:urlParams headerParams:headers bodyParams:bodyParams retryTimes:kJXRetryTimes success:^(AFHTTPRequestOperation *operation, id response) {
            JXLogDebug(@"响应【成功】-> %@：\n%@", param.pathURLString, response);
            [self handleResponse:response subscriber:subscriber class:cls];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            JXLogDebug(@"响应【失败】-> %@：\n%@", param.pathURLString, error);
            [self handleError:error subscriber:subscriber];
        } progress:NULL];
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
}

@end









