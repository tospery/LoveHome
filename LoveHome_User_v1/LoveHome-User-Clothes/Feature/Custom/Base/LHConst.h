//
//  LHConst.h --- 该文件用于定义宏常量
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/16.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//


#ifndef LoveHome_User_Clothes_LHConst_h
#define LoveHome_User_Clothes_LHConst_h
#import "LHTool.h"
#import "AppDelegate.h"
#define kContentx [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]
/*************************************************************************************
 第三方开发键
 *************************************************************************************/
#define kBaiduMap                       (@"oNVaUudUzDkANzojbrHkvVDD")
#define kUMAppkey                       (@"564957b8e0f55aa261000ca1") //(@"55e06c72e0f55a91500006b7")
#define kWXAppID                        (@"wx0c08ba32c0167339")
#define kWXAppSecret                    (@"a9cfa74f575907aec0039ebb1dd2aab3")
#define kAppKey                         (@"8f3206d0b73ea8fe")
#define kAppSecret                      (@"68de6fd28f3206d0b73ea8feb7f4b7ec")
#define kAppkeyUMAnalytics              (@"564957b8e0f55aa261000ca1")

#define kStatisticPageActivity          (@"活动页")

/*************************************************************************************
 支付宝SDK相关
 *************************************************************************************/

/*************************************************************************************
 颜色常量（Color）
*************************************************************************************/
#define kColorNavBar                    (ColorHex(0xF8F8F8))   // 用于导航栏颜色
#define kColorBack                      (ColorRGB(244, 244, 244)) // 背景色
#define kColorTheme                     (ColorHex(0x29d8d6)) // 主题色

#define kCellLineColor                  (ColorRGB(225, 225, 225))    //分割线颜色
#define kPlaceHolderColor               (ColorHex(0xbbbbbb))   //文本框placeHolder颜色

#define kCaptchaDisableTextColor        (ColorHex(0xAAAAAA)) //验证码不可用时文字颜色
#define kCaptchaDisableButtonBGColor    (ColorHex(0xe5e5e5)) //验证码不可用时按钮背景颜色

#define kPlainTextColor                 (ColorHex(0x333333)) 
#define kPlainTextLightColor            (ColorHex(0x666666))

/*************************************************************************************
 存储键值（UserDefault）
 ************************************************************************************/
#define kUdLongitude                    (@"kUdLongitude")       // 经度
#define kUdLatitude                     (@"kUdLatitude")        // 纬度
#define kUdLogined                      (@"kUdLogined")         // 登录
#define kUdCity                         (@"kUdCity")            // 城市
#define kUdVersion                      (@"kUdVersion")         // 版本
#define kUdAccount                      (@"kUdAccount")         // 账号

/*************************************************************************************
 屏幕尺寸（Screen）
 ************************************************************************************/
#define kScreenWidth        ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight       ([UIScreen mainScreen].bounds.size.height)

/*************************************************************************************
 CoreData
 ************************************************************************************/
#define CoreDataContext   [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]
#define kMRContext          ([NSManagedObjectContext MR_defaultContext])

/*************************************************************************************
 网路参数（HTTP）
 ************************************************************************************/
//#define kHTTPServer                     (@"https://api.appvworks.com") // 443
//#define kHTTPServer                 (@"http://183.220.1.29:40800")
//#define kHTTPServer                 (@"http://192.168.10.235:8080")
//#define kHTTPServer                 (@"http://192.168.2.70:8080")
//#define kHTTPServer                 (@"http://192.168.2.58:8080")
//#define kHTTPServer                 (@"http://192.168.2.61:8080")
//#define kHTTPServer                 (@"http://192.168.199.123:8080")


//#define kHTTPBase                   ([NSString stringWithFormat:@"%@/appvworks.portal/", kHTTPServer])


#define kHTTPBase                   (@"https://api.appvworks.com")                            // 阿里云
//#define kHTTPBase                 (@"http://183.220.1.29:40800/appvworks.portal")               // 公司外网
//#define kHTTPBase                 (@"http://192.168.10.235:8080/appvworks.portal")            // 公司内网
//#define kHTTPBase                 (@"http://192.168.2.61:8080/appvworks.portal")              // 陈思政


#define kHTTPTimeout                (60)
#define kHTTPSuccess                (200)
#define kHTTPData                   (@"data")
#define kHTTPPageSize               (20)
#define kHTTPLovebean               (@"http://www.appvworks.com/lovebean/index.html")
#define kHTTPTerm                   (@"http://www.appvworks.com/user_agree.html")

#define kWebOfficialSite            (@"http://www.appvworks.com")
#define kWebDownloadSite            (@"http://www.appvworks.com/app-ios-android-download.html") // (@"http://www.appvworks.com/app-download.html")
/*************************************************************************************
 时间常量 (Time)
 ************************************************************************************/
#define kCaptchaTime        60  //验证码循环时间

/*************************************************************************************
 版本号 (Version)
 ************************************************************************************/
#define kVersionString [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

/*************************************************************************************
 错误码 (ErrorCode)
 ************************************************************************************/
//#define kErrorCodeInvalidToken              (401)


/*************************************************************************************
 默认图片 (placeholder)
 ************************************************************************************/
#define kImageWaitingRectangle      ([UIImage imageNamed:@"placeholder_loading"])
#define kImagePHShopLogo            ([UIImage imageNamed:@"ic_placeholder_shop"])
#define kImagePHProductIcon         ([UIImage imageNamed:@"ic_placeholder_product"])
#define kImagePHUserAvatar          ([UIImage imageNamed:@"ic_placeholder_avatar"])
#define kImageAppIcon               ([UIImage imageNamed:@"my_appicon"])


// 通知（notify）
#define kNotifyReceiptChanged               (@"kNotifyReceiptChanged")
#define kNotifyReceiptSelected              (@"kNotifyReceiptSelected")
#define kNotifyAlipayRecharge               (@"kNotifyAlipayRecharge")
#define kNotifyAlipayPayment                (@"kNotifyAlipayPayment")
#define kNotifyCouponSelected               (@"kNotifyCouponSelected")
#define kNotifyOrderPayed                   (@"kNotifyOrderPayed")
#define kNotifyOrderCanceled                (@"kNotifyOrderCanceled")
#define kNotifyOrderConfirm                 (@"kNotifyOrderConfirm")
#define kNotifyOrderReceived                (@"kNotifyOrderReceived")
#define kNotifyOrderDeleted                 (@"kNotifyOrderDeleted")
#define kNotifyOrderCommented               (@"kNotifyOrderCommented")
#define kNotifyCouponReceived               (@"kNotifyCouponReceived")
#define kNotifyAutoLogin                    (@"kNotifyAutoLogin")

#define kPageSize                   (20)


// 方案（scheme）
#define  kSchemeAlipay             (@"appvworks-LoveHomeClothes")

#endif






