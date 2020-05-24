//
//  HTTPRequestParam.m
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/18.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "HTTPRequestParam.h"

@interface HTTPRequestParam ()
@property (nonatomic, copy, readwrite) NSString *pathURLString;         // 服务的路径

@property (nonatomic, copy)     NSString        *token;
@property (nonatomic, copy)     NSString        *mobile;
@property (nonatomic, copy)     NSString        *code;
@property (nonatomic, assign)   ClientType      device;

@property (nonatomic, assign)   NSInteger       status;
@property (nonatomic, assign)   NSInteger       currentPage;
@property (nonatomic, assign)   NSInteger       pageSize;

@end

@implementation HTTPRequestParam
- (instancetype)initWithPath:(NSString *)path needToken:(BOOL)needToken {
    if (self = [super init]) {
        _pathURLString = path;
        if (needToken) {
            _token = [User userForCurrent].token;
        }
        
        _device = kJXHTTPParamValueIgnoreNum;
        _status = kJXHTTPParamValueIgnoreNum;
        _currentPage = kJXHTTPParamValueIgnoreNum;
        _pageSize = kJXHTTPParamValueIgnoreNum;
    }
    return self;
}

#pragma mark - 通用接口参数
+ (instancetype)paramObtainCaptchaWithPhone:(NSString *)phone {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] initWithPath:@"general/getCode" needToken:NO];
    param.mobile = phone;
    return param;
}

#pragma mark - 账户接口参数
+ (instancetype)paramLoginWithPhone:(NSString *)phone captcha:(NSString *)captcha {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] initWithPath:@"accountMerchant/login" needToken:NO];
    param.mobile = phone;
    param.code = captcha;
    param.device = ClientTypeiOS;
    return param;
}

+ (instancetype)paramObtainUnreadCount {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] initWithPath:@"general/getOrderMsgUnreadTotal" needToken:YES];
    return param;
}

+ (instancetype)paramObtainVisitCountYesterday {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] initWithPath:@"report/getUserReport" needToken:YES];
    return param;
}

#pragma mark - 订单接口参数
+ (instancetype)paramObtainOrderCount {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] initWithPath:@"merchantorder/getshopordercount" needToken:YES];
    return param;
}

+ (instancetype)paramObtainOrdersWithPage:(JXPage *)page status:(HTTPReqOrderStatus)status {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] initWithPath:@"merchantorder/getshoporder" needToken:YES];
    param.currentPage = page.index;
    param.pageSize = page.size;
    param.status = status;
    return param;
}

@end







