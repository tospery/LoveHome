//
//  JXConst.h
//  MyiOS
//
//  Created by Thundersoft on 10/20/14.
//  Copyright (c) 2014 Thundersoft. All rights reserved.
//

#ifndef MyiOS_JXConst_h
#define MyiOS_JXConst_h

/********************************************************************************************************
 量度
 ********************************************************************************************************/
// 屏幕尺寸
#define kJXScreenWidth                              ([UIScreen mainScreen].bounds.size.width)
#define kJXScreenHeight                             ([UIScreen mainScreen].bounds.size.height)
#define kJXFrameWidth                               ([UIScreen mainScreen ].applicationFrame.size.width)
#define kJXFrameHeight                              ([UIScreen mainScreen ].applicationFrame.size.height)
#define kJXStsBarHeight                             (20.0f)
#define kJXNavBarHeight                             (44.0f)
#define kJXTabBarHeight                             (49.0f)
// 边框
#define kJXBorderMin                                (0.1)
#define kJXBorderSmall                              (1.2)
#define kJXBorderMiddle                             (2.0)
#define kJXBorderLarge                              (4.0)
#define kJXBorderMax                                (8.0)
// 角度
#define kJXRadiusMin                                (2.0)
#define kJXRadiusSmall                              (4.0)
#define kJXRadiusMiddle                             (8.0)
#define kJXRadiusLarge                              (12.0)
#define kJXRadiusMax                                (20.0)
// 系统默认
#define kJXStandardPadding                          (8.0f)
#define kJXStandardCellHeight                       (44.0f)
#define kJXStandardPageHeight                       (37.0f)


/********************************************************************************************************
 上下文
 ********************************************************************************************************/
#ifdef JXEnableMagicalRecord
#define kJXContextMR                            ([NSManagedObjectContext MR_defaultContext])
#endif


// 待整理
//define this constant if you want to enable auto-boxing for default syntax
//#define MAS_SHORTHAND_GLOBALS

// Format
#define kJXFormatDatetimeNormal                     (@"YYYY-MM-dd HH:mm:ss")
#define kJXFormatDatetimeStyle2                     (@"YYYY-MM-dd HH:mm")
#define kJXFormatDatetimeStyle3                     (@"MM月dd日")

// 备份
#define kJXFormatDateItYYMMDD                       (@"YY-MM-dd")
#define kJXFormatForDateInternational               (@"YYYY-MM-dd")
#define kJXFormatForDateChinese                     (@"YYYY年MM月dd日")
#define kJXFormatForTimeInternational               (@"HH:mm:ss")
#define kJXFormatForTimeChinese                     (@"HH时mm分ss秒")
#define kJXFormatForDatetimeChinese                 (@"YYYY年MM月dd日 HH时mm分ss秒")
#define kJXFormatForDatetimeNormal                  (@"yyyy-MM-dd HH:mm")
#define kJXFormatForDatetimeAll                     (@"YYYY-MM-dd HH:mm:ss.SSS")
#define kJXFormatJPG                                (@".jpg")
#define kJXFormatPNG                                (@".png")


// Locale
#define kJXLocaleZhCN                                   (@"zh_CN")
#define kJXLocaleEnUS                                   (@"en_US")

// Identifier
#pragma mark - Identifier
#define kJXIdentifierCellSystem                     (@"kJXIdentifierCellSystem")
#define kJXIdentifierHeaderFooter                   (@"kJXIdentifierHeaderFooter")

// Animation
#pragma mark - Animation
#define kJXAnimationForKeyboard                     (@"kJXAnimationForKeyboard")
#define kJXAnimationForMainInterface                (@"kJXAnimationForMainInterface")

// Metric
// Metric Standard
#define kJXMetricPhoneNumber                                    (11)
#define kJXMetricCustomPadding                                 (20.0)
#define kJXMetricSecondsInMinute                               (60)



// Literal
#define kJXLiteralForNullWithSmallBrackets                           (@"(null)")

// UserDefault
#define kJXUdVersion                                        (@"kJXUdVersion")
#define kJXUdAccount                                        (@"kJXUdAccount")
#define kJXUdPassword                                       (@"kJXUdPassword")

// HTTP
#define kHTTPTimeout                                        (60)

// Time
#define kTimeTips                                           (1.2)

// Charset
#define kJXCharsetNumbers                             (@"0123456789")
#define kJXCharsetLetters                             (@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

#endif









