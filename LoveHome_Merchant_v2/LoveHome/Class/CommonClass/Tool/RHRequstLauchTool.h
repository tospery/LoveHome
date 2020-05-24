//
//  RHRuqestLauchTool.h
//  LoveHome
//
//  Created by MRH on 15/10/9.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RHType.h"

@interface RHRequstLauchTool : NSObject


/*!
 *  @brief  开始请求时的方式
 *
 *  @param lauchType 请求显示的方式
 *  @param view      加载到哪个View
 */
+(void)showLauchWithType:(RHWebLaunchType)lauchType toView:(UIView *)view;

/*!
 *  @brief  请求成功后Loading界面处理
 *
 *  @param lauchType 显示方式
 *  @param view      被显示的View层
 */
+ (void)handleSuceessRequestType:(RHWebLaunchType)lauchType toView:(UIView *)view;


/*!
 *  @brief  请求失败后的处理
 *
 *  @param view      被显示的View层
 *  @param lauchType 显示方式
 *  @param way       提示错误的类型
 *  @param error     error
 *  @param callback  retry或登录成功后的回调
 */
+ (void)handleErrorFailureForView:(UIView *)view  lauchType:(RHWebLaunchType)lauchType ToastWay:(RHErrorShowType)way error:(NSError *)error callback:(RHLoadResultCallback)callback;
@end
