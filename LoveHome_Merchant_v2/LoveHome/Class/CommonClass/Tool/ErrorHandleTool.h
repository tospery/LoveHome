//
//  ErrorHandleTool.h
//  LoveHome
//
//  Created by MRH-MAC on 15/9/23.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^CompleteBlock)();
@interface ErrorHandleTool : NSObject





+ (NSError *)errorWithCode:(NSError *)code;

/*!
 *  @brief  生成错误Error
 *
 *  @param code
 *  @param description
 *
 *  @return
 */
+ (NSError *)errorWithCode:(RHErrorCode)code description:(NSString *)description;


/*!
 *  @brief  显示HUD警示框
 *
 *  @param code
 *  @param toShow 
 */
+ (void)handleErrorWithCode:(NSError *)error toShowView:(UIView *)toShow didFinshi:(CompleteBlock)didFinsh cancel:(CompleteBlock)cancel;



/*!
 *  @brief  显示遮罩层警示图
 *
 *  @param error    错误
 *  @param toShow   显示的View
 *  @param didFinsh 事件操作回调
 *  @param cancel   取消操作回调
 */
+(void)handleLoadViewWithCode:(NSError *)error toShowView:(UIView *)toShow didFinshi:(CompleteBlock)didFinsh cancel:(CompleteBlock)cancel;

@end
