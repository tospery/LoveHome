//
//  LHUtil.h --- 用于实现一些便捷的全局C函数
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/16.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  @brief  判断是否为正常充值金额
 *
 *  @return
 */
BOOL isNormalMoney(NSString* money);

/*!
 *  @brief  获取当前时间 精确到微妙
 */
NSString * getCurrentTime(void);

/**
 *  判断容器是否为空或nil
 *
 *  @param container NSArray、NSDictionary、NSString或NSNumber类型的变量
 *
 *  @return YES为空，反之不为空
 */
BOOL JudgeContainerIsEmptyOrNull(id container);


/**
 *  创建一个表示返回的导航项，它的action方法为leftBarItemPressed:
 *
 *  @param target 视图控制器
 *
 *  @return 导航项
 */
UIBarButtonItem * CreateBackBarItem(id target);


///**
// *  判断是否需要重新登录，如果需要则显示登录界面
// *
// *  @param target     当前的控制器
// *  @param message    打开登录界面后显示的提示消息内容
// *  @param ^presented 打开登录界面后的回调
// *  @param ^cancelled 直接返回->关闭登录界面后的回调
// *  @param ^finished 登录成功->关闭登录界面后的回调
// *
// *  @return YES为需要重新登录
// */
//BOOL ShowLoginIfNeed(UIViewController *target, NSString *message, void (^presented)(void), void (^cancelled)(void), void (^finished)(void));
//
//
///**
// *  执行关闭登录界面后的block
// */
//void ExecuteLoginCancelledBlock();
//void ExecuteLoginFinishedBlock();


/**
 *  配置登录、注册、修改等界面中按钮的统一风格
 *
 *  @param button 被配置的按钮
 */
void ConfigButtonStyle(UIButton *button);

void ConfigButtonRedStyle(UIButton *button);

/**
 *  计算两点之间的距离
 *
 *  @param point1 点1
 *  @param point2 点2
 *
 *  @return 距离
 */
CGFloat DistanceBetweenPoints(CGPoint point1, CGPoint point2);


/**
 *  计算两点之间的角度
 *
 *  @param first  点1
 *  @param second 点2
 *
 *  @return 角度
 */
CGFloat DegreeBetweenPoints(CGPoint first, CGPoint second);

/**
 *  MD5 16位加密方法
 *
 *  @param original 原始字符串
 *
 *  @return 加密结果
 */
NSString * MD5Bit32Encrypt(NSString *original);


