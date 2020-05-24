//
//  LHCaptchaButton.h
//  LoveHome-User-Clothes
//
//  Created by 李俊辉 on 15/7/22.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//  封装了的验证码按钮

#import <UIKit/UIKit.h>

@class LHCaptchaButton;
@protocol LHCaptchaButtonDelegate <NSObject>
@optional
//是否要开始倒计时
- (BOOL)LHCaptchaButtonShouldStartCountDown;

//开始倒计时
- (void)LHCaptchaButtonDidStartCountDown;

//结束倒计时
- (void)LHCaptchaButtonDidEndCountDown;
@end

@interface LHCaptchaButton : UIView


/**
*  快速创建一个验证码按钮
*
*  @param timeInterval     时间
*  @param themColor        验证码按钮颜色
*  @param disableTextColor 不可用状态下文字颜色
*  @param disableBGColor   不可用状态下背景颜色
*
*  @return 验证码按钮
*/
- (instancetype)initWithCountTime:(NSInteger)timeInterval themeColor:(UIColor *)themColor disableTextColor:(UIColor *)disableTextColor disableBGColor:(UIColor *)disableBGColor;
@property (strong, nonatomic) NSTimer *timer; //定时器刷新界面
@property (weak, nonatomic) id<LHCaptchaButtonDelegate> delegate;

/**
 *  手动停止倒计时
 */
- (void)finish;

/**
 *  重置UI
 */
- (void)resetCodeState:(BOOL)retry;
@end
