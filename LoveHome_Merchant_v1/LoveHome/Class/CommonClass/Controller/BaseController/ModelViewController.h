//
//  BSJ_ModelViewController.h
//  BangBang
//
//  Created by Joe Chen on 9/12/13.
//  Copyright (c) 2013 卡莱博尔. All rights reserved.
//
/*
 *  此类是modelViewController
 *
 *  Discussion:
 *
 *  1、自定义navgationBar的leftItem和rightItem
 */

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperation.h"
#import <objc/message.h>

static const NSUInteger UserManage_LoginRequestFailedLimitTime = 3;  //请求登录失败限制次数

@interface ModelViewController : UIViewController
{
}

/*Network Request Object*/
@property (strong, nonatomic) AFHTTPRequestOperation *currentDataRequest;
@property (strong, nonatomic) AFHTTPRequestOperation *userLoginRequest;//用户登录请求



/*!
 *  @brief  用于订单界面业务失败限制次数(特殊处理)
 */
@property (assign, nonatomic) NSUInteger orderRequestFailedLimitTimes;


- (void)setLeftButton;



- (void)setLeftNavgationItem;


/*!
 *  @brief  NavigationBar的leftItem点击事件
 *
 *  @param sender
 */
- (void)leftButtonAction:(id)sender;


/*!
 *  @brief  NavigationBar的rightItem点击事件
 *
 *  @param sender 
 */
- (void)rightButtonAction:(UIBarButtonItem *)sender;



/*!
 *  @brief  发送登录请求(默认密码不加密，也没有回调处理)
 *
 *  @param userName  用户名
 *  @param password  密码
 */
- (void)sendLoginRequestWithUserName:(NSString *)userName
                         andPassward:(NSString *)password;


/*!
 *  @brief  发送登录请求(可设置密码是否加密传送，没有回调处理)
 *
 *  @param userName  用户名
 *  @param password  密码
 *  @param isSecret  是否加密传送
 */
- (void)sendLoginRequestWithUserName:(NSString *)userName
                         andPassward:(NSString *)password
                         andIsSecret:(BOOL)isSecret;



/*!
 *  @brief  发送登录请求 (有回调，适用于直接传参数方法调用)
 *
 *  @param userName 用户名
 *  @param password 密码
 *  @param isSecret 是否加密传送
 *  @param sucess   token请求成功回调
 */
- (void)sendLoginRequestWithUserName:(NSString *)userName
andPassward:(NSString *)password
                         andIsSecret:(BOOL)isSecret andSucess:(void(^)(void))sucess;


/*!
 *  @brief  发送登录请求(可设置密码是否加密传送，有回调处理)
 *
 *  @param userName  用户名
 *  @param password  密码
 *  @param isSecret  是否加密传送
 *  @param childController 子类对象
 *  @param action          子类方法
 */
- (void)sendLoginRequestWithUserName:(NSString *)userName
                         andPassward:(NSString *)password
                         andIsSecret:(BOOL)isSecret
                  andChildController:(UIViewController *)childController
                     andChildMenthod:(SEL)action;


#pragma mark 登录请求结束的回调
/*!
 *  @brief  登录请求成功
 */
- (void)loginRequestSucceed;


/*!
 *  @brief  登录请求失败
 *
 *  @param error 失败原因
 */
- (void)loginRequestFailed:(id)error;


#pragma mark 请求响应成功和失败的处理
/*!
 *  @brief  处理请求响应成功失败以及Token失效
 *
 *  @param response        获取的参数
 *  @param childController 子类
 *  @param action          子类方法
 *  @param success         业务成功回调
 *  @param failed          业务失败回调
 */
- (void)operateResponseSucceed:(id)response
            andChildController:(UIViewController *)childController
               andChildMenthod:(SEL)action
         andSucessedCompletion:(void(^)(id contentObject))success
                     andFailed:(void(^)(id responseObject))failed;


/*!
 *  @brief  请求响应失败的处理
 *
 *  @param response 响应返回的对象
 */
- (void)operateResponseFiailed:(id)response;

#pragma mark 数据处理
/*!
 *  @brief  重置User的信息
 *
 *  @param userInfoObject 用户对象
 */
- (void)resetUserInfoAndRequest:(AFHTTPRequestOperation *)operation andUserInfoObject:(NSDictionary *)userInfoObject;


#pragma mark -- yjx


@end
