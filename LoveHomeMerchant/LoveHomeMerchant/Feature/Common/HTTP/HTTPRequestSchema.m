//
//  HTTPRequestSchema.m
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/18.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "HTTPRequestSchema.h"

@interface HTTPRequestSchema ()
@property (nonatomic, assign, readwrite) JXHTTPRequestMethodType requestMethodType;        // 请求方法
@property (nonatomic, assign, readwrite) JXHTTPRequestContentType requestContentType;      // 请求数据的类型
@property (nonatomic, assign, readwrite) JXHTTPResponseContentType responseContentType;    // 响应数据的类型
@end

@implementation HTTPRequestSchema
+ (instancetype)schemaGet {
    HTTPRequestSchema *schema = [[HTTPRequestSchema alloc] init];
    schema.requestMethodType = JXHTTPRequestMethodTypeGet;
    schema.requestContentType = JXHTTPRequestContentTypeNone;
    schema.responseContentType = JXHTTPResponseContentTypeJSON;
    return schema;
}

+ (instancetype)schemaPost {
    HTTPRequestSchema *schema = [[HTTPRequestSchema alloc] init];
    schema.requestMethodType = JXHTTPRequestMethodTypePost;
    schema.requestContentType = JXHTTPRequestContentTypeFormURLEncoded;
    schema.responseContentType = JXHTTPResponseContentTypeJSON;
    return schema;
}

+ (instancetype)schemaDft {
    return [[self class] schemaPost];
}

@end
