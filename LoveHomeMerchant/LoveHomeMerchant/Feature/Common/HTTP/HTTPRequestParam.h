//
//  HTTPRequestParam.h
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/18.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPRequestParam : NSObject
@property (nonatomic, copy, readonly) NSString *pathURLString;         // 服务的路径

#pragma mark - 通用接口参数
/**
 *  获取验证码
 *
 *  @param phone 手机号
 *
 *  @return 请求参数
 */
+ (instancetype)paramObtainCaptchaWithPhone:(NSString *)phone;

#pragma mark - 账户接口参数
/**
 *  用户登录
 *
 *  @param phone   手机号
 *  @param captcha 验证码
 *
 *  @return 请求参数
 */
+ (instancetype)paramLoginWithPhone:(NSString *)phone captcha:(NSString *)captcha;

/**
 *  未读消息个数
 *
 *  @return 请求参数
 */
+ (instancetype)paramObtainUnreadCount;

/**
 *  昨日访问量
 *
 *  @return 请求参数
 */
+ (instancetype)paramObtainVisitCountYesterday;

#pragma mark - 订单接口参数
/**
 *  订单数目
 *
 *  @return 请求参数
 */
+ (instancetype)paramObtainOrderCount;


/**
 *  某种状态的订单列表
 *
 *  @param page   分页
 *  @param status 状态
 *
 *  @return 请求参数
 */
+ (instancetype)paramObtainOrdersWithPage:(JXPage *)page status:(HTTPReqOrderStatus)status;

@end






