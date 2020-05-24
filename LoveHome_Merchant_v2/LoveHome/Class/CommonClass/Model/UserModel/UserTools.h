//
//  UserTools.h
//  LoveHome
//
//  Created by MRH-MAC on 15/8/5.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "BaseDataModel.h"
#import  "UserDataModel.h"
#import "RegistShopModel.h"
typedef void(^LHLoginDidFinishedBlock)();       // 登录成功，已经dismiss完成
@class AFHTTPRequestOperation;

/*!
 *  @brief  用户登录请求Block
 *
 *  @param id
 */



@interface UserTools : BaseDataModel
singleton_interface(UserTools)

@property (nonatomic,strong) UserDataModel *userModel;
@property (nonatomic,strong) RegistShopModel *registShopModel;

@property (nonatomic,assign) BOOL isLoginWindow;



/**
 *  获取验证码
 *
 *  @param phone   手机号码
 *  @param success 成功回调
 *  @param failure 失败回调
 *
 *  @return 请求操作
 */
+ (AFHTTPRequestOperation *)getcodeWithPhone:(NSString *)phone
                                     success:(HttpServiceBasicSucessBackBlock)success
                                     failure:(HttpServiceBasicFailBackBlock)failure;


/**
 *  注册
 *
 *  @param phone   手机号码
 *  @param code    短信验证码
 *  @param success 成功回调
 *  @param failure 失败回调
 *
 *  @return 请求操作
 */
+ (AFHTTPRequestOperation *)signinWithPhone:(NSString *)phone
                                       code:(NSString *)code
                                    success:(HttpServiceBasicSucessBackBlock)success
                                    failure:(HttpServiceBasicFailBackBlock)failure;




/*!
 *  @brief  调用登录请求
 *
 *  @param userName     用户名
 *  @param password     密码
 *  @param succeedBlock 成功的回调
 *  @param failedBlock  失败的回调
 *
 *  @return AFHTTPRequestOperation
 */
+ (AFHTTPRequestOperation *)loginWithPhone:(NSString *)phone
                                      code:(NSString *)code
                                    device:(NSNumber *)device
                                   success:(HttpServiceBasicSucessBackBlock)success
                                   failure:(HttpServiceBasicFailBackBlock)failure;


/*!
 *  @brief  是否需要重新登录
 *
 *  @param target      当前控制器
 *  @param error       服务端返回Erro
 *  @param didFinished
 *
 *  @return
 */
- (BOOL)loginIfNeedWithTarget:(UIViewController *)target  error:(NSError *)error didFinished:(LHLoginDidFinishedBlock)didFinished;


@end
