//
//  UserTools.m
//  LoveHome
//
//  Created by MRH-MAC on 15/8/5.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "UserTools.h"
#import "LoginsViewController.h"
#import "BaseNavigationController.h"
@implementation UserTools
singleton_implementation(UserTools)


@synthesize userModel = _userModel;

- (UserDataModel *)userModel
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _userModel = [UserDataModel fetch];
        
    });
    
    return _userModel;
}


- (void)setUserModel:(UserDataModel *)userModel
{
    _userModel = userModel;
    [UserDataModel storage:_userModel];
    
}



- (RegistShopModel *)registShopModel
{
    if (!_registShopModel) {
        _registShopModel = [[RegistShopModel alloc] init];
    }
    return _registShopModel;
}

#pragma mark - 登录注册相关


+ (AFHTTPRequestOperation *)getcodeWithPhone:(NSString *)phone
                                     success:(HttpServiceBasicSucessBackBlock)success
                                     failure:(HttpServiceBasicFailBackBlock)failure {
    NSDictionary *params = @{@"mobile": phone};
    
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"general/getCode" andParameterDic:params andPatameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:success andFailedCallback:failure];
    return operation;
    
}


//注册

+ (AFHTTPRequestOperation *)signinWithPhone:(NSString *)phone
                                       code:(NSString *)code
                                    success:(HttpServiceBasicSucessBackBlock)success
                                    failure:(HttpServiceBasicFailBackBlock)failure {
    NSDictionary *params = @{@"mobile": phone,
                             @"code": code};
    
    
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"accountMerchant/checkCode" andParameterDic:params andPatameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:success andFailedCallback:failure];
    
    return operation;
}

+ (AFHTTPRequestOperation *)loginWithPhone:(NSString *)phone
                                      code:(NSString *)code
                                    device:(NSNumber *)device
                                   success:(HttpServiceBasicSucessBackBlock)success
                                   failure:(HttpServiceBasicFailBackBlock)failure {
    NSDictionary *params = @{@"mobile": phone,
                             @"code": code,
                             @"device": device};
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"accountMerchant/login" andToken:NO andParameterDic:params andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:success andFailedCallback:failure];
    
    return operation;
    
}

/*!
 *  @brief  是否需要重新登录
 *
 *  @param target      当前控制器
 *  @param error       服务端返回Erro
 *  @param didFinished
 *
 *  @return
 */
- (BOOL)loginIfNeedWithTarget:(UIViewController *)target  error:(NSError *)error didFinished:(LHLoginDidFinishedBlock)didFinished
{
    
    BOOL isNeddLogin = NO;
    
    if (![UserTools sharedUserTools].userModel) {
        isNeddLogin = YES;
    }
    
    if (error) {
        if (error.code == 401)
        {
            isNeddLogin = YES;
        }
    }
    if (isNeddLogin) {
        [UserTools sharedUserTools].userModel = nil;
        LoginsViewController *login = [[LoginsViewController alloc] init];
        login.loginSucessBlock = didFinished;
        BaseNavigationController *nav =[[BaseNavigationController alloc] initWithRootViewController:login];
        [target presentViewController:nav animated:YES completion:nil];
        [UserTools  sharedUserTools].isLoginWindow = YES;
        ;
    }
    return isNeddLogin;
}
@end
