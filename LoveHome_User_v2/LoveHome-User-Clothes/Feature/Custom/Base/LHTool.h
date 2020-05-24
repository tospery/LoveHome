//
//  LHTool.h --- 用于定义便捷的宏工具
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/16.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#ifndef LoveHome_User_Clothes_LHTool_h
#define LoveHome_User_Clothes_LHTool_h

// 图片
#define ImageWithColor(x)               ([UIImage exImageWithColor:(x)])

// 颜色
#define ColorRGB(r, g, b)   [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define ColorHex(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 版本
#define iOSVersionGreaterThanOrEqual(x)   ([[[UIDevice currentDevice] systemVersion] floatValue] >= (x))

// HUD
#define HUDProcessing(msg)  [MBProgressHUD showHUDAddedTo:self.view animated:YES hideAnimated:YES hideDelay:0 mode:MBProgressHUDModeIndeterminate type:0 customView:nil labelText:(msg) detailsLabelText:nil square:NO dimBackground:NO color:nil removeFromSuperViewOnHide:NO labelFont:16.0f detailsLabelFont:12.0f];
#define HUDHide()           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

// Toast
#define Toast(msg)          [[UIApplication sharedApplication].keyWindow makeToast:(msg) duration:2.0f position:CSToastPositionCenter]

// Alert
#define Alert(title, msg)                                     [[[UIAlertView alloc] initWithTitle:(title) message:(msg) delegate:self cancelButtonTitle:kStringOK otherButtonTitles: nil] show]
#define AlertParams(title, msg, cancelBtn, otherBtns)         [[[UIAlertView alloc] initWithTitle:(title) message:(msg) delegate:self cancelButtonTitle:(cancelBtn) otherButtonTitles:otherBtns, nil] show]

// 适配
#define kScaleFrom_iPhone5_Desgin(_X_) (_X_ * (kScreenWidth/320))

// Log
#ifdef JXEnableCocoaLumberjack
#define LogError(fmt, ...)            DDLogError((fmt), ##__VA_ARGS__)
#define LogWarn(fmt, ...)             DDLogWarn((fmt), ##__VA_ARGS__)
#define LogInfo(fmt, ...)             DDLogInfo((fmt), ##__VA_ARGS__)
#define LogDebug(fmt, ...)            DDLogDebug((fmt), ##__VA_ARGS__)
#define LogVerbose(fmt, ...)          DDLogVerbose((fmt), ##__VA_ARGS__)
#else
#define LogError(fmt, ...)            NSLog((fmt), ##__VA_ARGS__)
#define LogWarn(fmt, ...)             NSLog((fmt), ##__VA_ARGS__)
#define LogInfo(fmt, ...)             NSLog((fmt), ##__VA_ARGS__)
#define LogDebug(fmt, ...)            NSLog((fmt), ##__VA_ARGS__)
#define LogVerbose(fmt, ...)          NSLog((fmt), ##__VA_ARGS__)
//#define JXLogError(fmt, ...)            NSLog(@"【ERROR】%s->" fmt"", __func__, ##__VA_ARGS__)
//#define JXLogWarn(fmt, ...)             NSLog(@"【WARNING】%s->" fmt"", __func__, ##__VA_ARGS__)
//#define JXLogInfo(fmt, ...)             NSLog(@"【INFO】%s->" fmt"", __func__, ##__VA_ARGS__)
//#define JXLogDebug(fmt, ...)            NSLog(@"【DEBUG】%s->" fmt"", __func__, ##__VA_ARGS__)
//#define JXLogVerbose(fmt, ...)          NSLog(@"【VERBOSE】%s->" fmt"", __func__, ##__VA_ARGS__)
#endif

#endif
