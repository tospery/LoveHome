//
//  JXTool.h
//  MyiOS
//
//  Created by Thundersoft on 10/17/14.
//  Copyright (c) 2014 Thundersoft. All rights reserved.
//

#ifndef MyiOS_JXTool_h
#define MyiOS_JXTool_h

/********************************************************************************************************
 导入头文件
 ********************************************************************************************************/
#import "JXApple.h"

#ifdef JXEnableToast
#import "UIView+Toast.h"
#endif

#ifdef JXEnableCocoaLumberjack
#import "CocoaLumberjack.h"
#endif


/********************************************************************************************************
 提示框
 ********************************************************************************************************/
// Alert
#define JXAlert(title, msg)                                     [[[UIAlertView alloc] initWithTitle:(title) message:(msg) delegate:self cancelButtonTitle:kStringOK otherButtonTitles: nil] show]
#define JXAlertParams(title, msg, cancelBtn, otherBtns)         [[[UIAlertView alloc] initWithTitle:(title) message:(msg) delegate:self cancelButtonTitle:(cancelBtn) otherButtonTitles:otherBtns, nil] show]
// Toast
#ifdef JXEnableToast
#define JXToast(msg)                                            [self.view makeToast:(msg) duration:2.0f position:CSToastPositionCenter]
#define JXToastParams(msg, duration, position)                  [self.view makeToast:(msg) duration:(duration) position:(position)]
#else
#define JXToast(msg)                                            ShowWaringAlertHUD(msg, nil);
#endif




// 待整理
// Window
#define kJXWindow                           ([[UIApplication sharedApplication].delegate window])

// Localize
#ifdef JXLOCALIZATION_ON
#define JXT(local, display)                   local
#else
#define JXT(local, display)                   display
#endif

// System version
#define JXiOSVersionGreaterThanOrEqual(x)   ([[[UIDevice currentDevice] systemVersion] floatValue] >= (x))

// Degree&Radian
#define JXDegreeToRadian(x)                 (M_PI * (x) / 180.0)
#define JXRadianToDegree(x)                 (180.0 * (x) / M_PI)

// Color
#define JXColorHex(rgbValue)               [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define JXColorRGB(r, g, b)                [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define JXRGBAColor(r, g, b, a)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]
#define JXHexRGBAColor(rgbValue,a)          [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

// Loading
#define JXShowProcessing(superview)         [JXLoadingView showProcessingAddedTo:(superview) activityProcessingViewColor:nil gifProcessingImageName:nil]
#define JXShowFailed(superview, statements) [JXLoadingView showFailedAddedTo:(superview) failedMessage:nil failedImageName:nil retry:^{statements;}]
#define JXHideLoading(superview)            [JXLoadingView hideForView:(superview)]


// HUD
#define JXHUD(msg)                                                          \
[MBProgressHUD showHUDAddedTo:self.view animated:YES hideAnimated:YES hideDelay:1.2 mode:MBProgressHUDModeText type:0 customView:nil labelText:nil detailsLabelText:(msg) square:NO dimBackground:NO color:nil removeFromSuperViewOnHide:NO labelFont:18.0f detailsLabelFont:14.0f];
#define JXHUDProcessing(msg)                                                \
[MBProgressHUD showHUDAddedTo:self.view animated:YES hideAnimated:YES hideDelay:0 mode:MBProgressHUDModeIndeterminate type:0 customView:nil labelText:(msg) detailsLabelText:nil square:NO dimBackground:NO color:nil removeFromSuperViewOnHide:NO labelFont:16.0f detailsLabelFont:12.0f];
#define JXHUDHide()                                                         \
[MBProgressHUD hideAllHUDsForView:self.view animated:YES];

#define JXHUDParams(view, mode, msg, msgFont, detail, detailFont, delay)    \
[MBProgressHUD showHUDAddedTo:(view) animated:YES hideAnimated:YES hideDelay:(delay) mode:(mode) type:0 customView:nil labelText:(msg) detailsLabelText:(detail) square:NO dimBackground:NO color:nil removeFromSuperViewOnHide:NO labelFont:(msgFont) detailsLabelFont:(detailFont)];

// Status
#define JXStatus(msg)                                                       \
[JDStatusBarNotification showWithStatus:(msg) dismissAfter:1.2 styleName:JDStatusBarStyleDefault]
#define JXStatusSuccess(msg)                                                \
[JDStatusBarNotification showWithStatus:(msg) dismissAfter:1.2 styleName:JDStatusBarStyleSuccess]
#define JXStatusFailure(msg)                                                \
[JDStatusBarNotification showWithStatus:(msg) dismissAfter:1.2 styleName:JDStatusBarStyleError]


// Log
#ifdef JXEnableCocoaLumberjack
#define JXLogError(fmt, ...)            DDLogError((fmt), ##__VA_ARGS__)
#define JXLogWarn(fmt, ...)             DDLogWarn((fmt), ##__VA_ARGS__)
#define JXLogInfo(fmt, ...)             DDLogInfo((fmt), ##__VA_ARGS__)
#define JXLogDebug(fmt, ...)            DDLogDebug((fmt), ##__VA_ARGS__)
#define JXLogVerbose(fmt, ...)          DDLogVerbose((fmt), ##__VA_ARGS__)
#else
#define JXLogError(fmt, ...)            //NSLog((fmt), ##__VA_ARGS__)
#define JXLogWarn(fmt, ...)             //NSLog((fmt), ##__VA_ARGS__)
#define JXLogInfo(fmt, ...)             //NSLog((fmt), ##__VA_ARGS__)
#define JXLogDebug(fmt, ...)            //NSLog((fmt), ##__VA_ARGS__)
#define JXLogVerbose(fmt, ...)          //NSLog((fmt), ##__VA_ARGS__)
//#define JXLogError(fmt, ...)            //NSLog(@"【ERROR】%s->" fmt"", __func__, ##__VA_ARGS__)
//#define JXLogWarn(fmt, ...)             //NSLog(@"【WARNING】%s->" fmt"", __func__, ##__VA_ARGS__)
//#define JXLogInfo(fmt, ...)             //NSLog(@"【INFO】%s->" fmt"", __func__, ##__VA_ARGS__)
//#define JXLogDebug(fmt, ...)            //NSLog(@"【DEBUG】%s->" fmt"", __func__, ##__VA_ARGS__)
//#define JXLogVerbose(fmt, ...)          //NSLog(@"【VERBOSE】%s->" fmt"", __func__, ##__VA_ARGS__)
#endif


#define JXTerminate(msg)             \
NSAssert(NO, @"%@%@", kStringErrorWithGuillemet, msg)

// Device
#define JXDeviceIsPad                  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define JXDeviceIsPhone                (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

// String
#define JXStringFromFormat(fmt, ...)        ([NSString stringWithFormat:(fmt), ##__VA_ARGS__])
#define JXStringFromInteger(x)              ([NSString stringWithFormat:@"%llu", ((unsigned long long)x)])
#define JXStringFromFloat(x)                ([NSString stringWithFormat:@"%.2f", (x)])

// Integer
//#define JXIntegerFromString(x)              ([])

// Random
#define JXRandomNumber(x, y)        ((NSInteger)((x) + (arc4random() % ((y) - (x) + 1))))


// @interface
#define singleton_interface(className) \
+ (className *)shared##className;


// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}

// Singleton
#define JXSingletonInterface(className, methodName)             + (className *)shared##methodName;
#define JXSingletonImplementation(className, methodName)        \
static className *_instance;                        \
+ (id)allocWithZone:(NSZone *)zone                  \
{                                                   \
static dispatch_once_t onceToken;                   \
dispatch_once(&onceToken, ^{                        \
_instance = [super allocWithZone:zone];             \
});                                                 \
return _instance;                                   \
}                                                   \
+ (className *)shared##methodName                    \
{                                                   \
static dispatch_once_t onceToken;                   \
dispatch_once(&onceToken, ^{                        \
_instance = [[[self class] alloc] init];                    \
});                                                 \
return _instance;                                   \
}


#endif









