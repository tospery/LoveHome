//
//  HTTPRequestSchema.h
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/18.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPRequestSchema : NSObject
@property (nonatomic, assign, readonly) JXHTTPRequestMethodType requestMethodType;        // 请求方法
@property (nonatomic, assign, readonly) JXHTTPRequestContentType requestContentType;      // 请求数据的类型
@property (nonatomic, assign, readonly) JXHTTPResponseContentType responseContentType;    // 响应数据的类型

+ (instancetype)schemaGet;
+ (instancetype)schemaPost;

+ (instancetype)schemaDft;

@end
