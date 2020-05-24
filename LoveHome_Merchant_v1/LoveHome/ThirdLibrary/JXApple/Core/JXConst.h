//
//  JXConst.h
//  MyiOS
//
//  Created by Thundersoft on 10/20/14.
//  Copyright (c) 2014 Thundersoft. All rights reserved.
//

#ifndef MyiOS_JXConst_h
#define MyiOS_JXConst_h

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

// Format
#define kJXFormatDatetimeNormal                        (@"YYYY-MM-dd HH:mm:ss")
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
// Metric Border
#define kJXMetricBorderMin                                 (0.1)
#define kJXMetricBorderSmall                               (1.2)
#define kJXMetricBorderMiddle                              (2.0)
#define kJXMetricBorderLarge                               (4.0)
#define kJXMetricBorderMax                                 (8.0)
// Metric Corner
#define kJXMetricRadiusMin                                (2.0)
#define kJXMetricRadiusSmall                              (4.0)
#define kJXMetricRadiusMiddle                             (8.0)
#define kJXMetricRadiusLarge                              (12.0)
#define kJXMetricRadiusMax                                (20.0)
// Metric Standard
#define kJXMetricStandardPadding                                (8)
#define kJXMetricStandardCellHeight                             (44)
#define kJXMetricStandardPageHeight                             (37)

#define kJXMetricPhoneNumber                                    (11)
#define kJXMetricCustomPadding                                 (20.0)
#define kJXMetricSecondsInMinute                               (60)
// 屏幕尺寸
#define kJXMetricScreenWidth                            ([UIScreen mainScreen].bounds.size.width)
#define kJXMetricScreenHeight                           ([UIScreen mainScreen].bounds.size.height)
#define kJXMetricStsBarHeight                           (20.0f)
#define kJXMetricNavBarHeight                           (44.0f)
#define kJXMetricTabBarHeight                           (49.0f)



// Literal
#define kJXLiteralForNullWithSmallBrackets                           (@"(null)")

// UserDefault
#define kJXUdVersion                                        (@"kJXUdVersion")
#define kJXUdAccount                                        (@"kJXUdAccount")
#define kJXUdPassword                                       (@"kJXUdPassword")

// HTTP
#define kHTTPTimeout                                        (60)

#endif









