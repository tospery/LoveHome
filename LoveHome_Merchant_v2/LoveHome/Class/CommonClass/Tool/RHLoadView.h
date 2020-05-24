//
//  RHLoadView.h
//  LoveHome
//
//  Created by MRH on 15/8/11.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHLoadView : UIView
@property (nonatomic, copy) void (^callback)(void);
/*!
 *  @brief  显示LoadView
 *
 *  @param view 加载的View
 *  @param rect 如果View是TabeView类型 rect必须传TableView大小 其余传CGRextZero即可
 */
+ (void)showProcessingAddedTo:(UIView *)view rect:(CGRect)rect;

/*!
 *  @brief  根据erro显示错误图片或重新登录
 *
 *  @param view     加载的View
 *  @param rect     如果View是TabeView类型 rect必须传TableView大小 其余传CGRextZero即可
 *  @param error    网络请求失败返回Error
 *  @param callback 点击重重试,或重新登录成功回调
 */
+ (void)showResultAddedTo:(UIView *)view
                     rect:(CGRect)rect
                    error:(NSError *)error
                 callback:(void(^)(void))callback;

/*!
 *  @brief  自定义生成遮罩图片(例如：tableView没有数据时)
 *
 *  @param view              加载的View
 *  @param rect             如果View是TabeView类型 rect必须传TableView大小 其余传CGRextZero即可
 *  @param image            展示的图片
 *  @param message          标示提示
 *  @param functitle        重试按钮title(传nill为默认)
 *  @param callbackcallback 点击重重试,或重新登录成功回调
 */

+ (void)showResultAddedTo:(UIView *)view
                     rect:(CGRect)rect
                    image:(UIImage *)image
                  message:(NSString *)message
                functitle:(NSString *)functitle
                 callback:(void(^)(void))callbackcallback;

+ (void)hideForView:(UIView *)view;
@end
