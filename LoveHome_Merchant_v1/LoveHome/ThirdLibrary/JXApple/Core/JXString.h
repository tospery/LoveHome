//
//  JXString.h
//  MyiOS
//
//  Created by Thundersoft on 10/19/14.
//  Copyright (c) 2014 Thundersoft. All rights reserved.
//

#ifndef MyiOS_JXString_h
#define MyiOS_JXString_h

#import "JXTool.h"

// 1字
#define kStringNone                                                         \
JXT(NSLocalizedString(@"None", @"无"), @"无")
#define kStringiPhone                                                       \
JXT(NSLocalizedString(@"iPhone", @"iPhone"), @"iPhone")


// 2个字
#define kStringOK                                                           \
JXT(NSLocalizedString(@"OK", @"确定"), @"确定")
#define kStringCancel                                                       \
JXT(NSLocalizedString(@"Cancel", @"取消"), @"取消")
#define kStringTips                                                         \
JXT(NSLocalizedString(@"Tips", @"提示"), @"提示")
#define kStringNumCharsWithEMark                                            \
JXT(NSLocalizedString(@"chars", @"个字！"), @"个字！")
#define kStringErrorWithGuillemet                                           \
JXT(NSLocalizedString(@"【Error】", @"【错误】"), @"【错误】")
#define kStringDismiss                                                      \
JXT(NSLocalizedString(@"Dismiss", @"忽略"), @"忽略")
#define kStringReport                                                       \
JXT(NSLocalizedString(@"Report", @"报告"), @"报告")
#define kStringExit                                                         \
JXT(NSLocalizedString(@"Exit", @"退出"), @"退出")
#define kStringSetting                                                         \
JXT(NSLocalizedString(@"Setting", @"设置"), @"设置")
#define kStringError                                                         \
JXT(NSLocalizedString(@"Error", @"错误"), @"错误")


// 3个字
#define kStringPleaseInput                                                  \
JXT(NSLocalizedString(@"Please input", @"请输入"), @"请输入")


// 4个字
#define kStringParameterExceptionWithEMark                                  \
JXT(NSLocalizedString(@"Parameter exception!", @"参数异常！"), @"参数异常！")
#define kStringSoSorry                                                      \
JXT(NSLocalizedString(@"So sorry", @"非常抱歉"), @"非常抱歉")
#define kStringExceptionReport                                              \
JXT(NSLocalizedString(@"Exception report", @"异常报告"), @"异常报告")
#define kStringHandling                                                     \
JXT(NSLocalizedString(@"Handling ", @"正在处理"), @"正在处理")
#define kStringReload                                                                                    \
JXT(NSLocalizedString(@"kStringReload", @"重新加载"), @"重新加载")


// More
#define kStringExceptionExitAtPreviousRuningWithEMark                                                               \
JXT(NSLocalizedString(@"An error occurred on the previous run", @"程序在上次异常退出！"), @"程序在上次异常退出！")
#define kStringLoadFailedWithCommaClickToRetryWithExclam                                                            \
JXT(NSLocalizedString(@"Load failed, click to retry!", @"加载失败，点击重试！"), @"加载失败，点击重试！")
#define kStringYourDeviceNotSupportCallFunction                                                                     \
JXT(NSLocalizedString(@"kStringYourDeviceNotSupportCallFunction", @"您的设备不支持电话功能"), @"您的设备不支持电话功能")
#define kStringYourDeviceNotSupportMessageFunction                                                                     \
JXT(NSLocalizedString(@"kStringYourDeviceNotSupportMessageFunction", @"您的设备不支持短信功能"), @"您的设备不支持短信功能")
#define kStringNotSupportThisDevice                                                                       \
JXT(NSLocalizedString(@"kStringNotSupportThisDevice", @"不支持该设备"), @"不支持该设备")
#define kStringPleaseInputAtLeast                                                                                   \
JXT(NSLocalizedString(@"PleaseInput", @"请输入至少"), @"请输入至少")
//#define kStringCantIsAllWhitespaceCharsWithEMark                                                                    \
//JXT(NSLocalizedString(@"CantIsAllWhitespaceCharWithEMark", @"不能全为空格或换行"), @"不能全为空格或换行")
#define kStringUnhandledError                                                                                       \
JXT(NSLocalizedString(@"Unhandled error", @"未处理错误"), @"未处理错误")
#define kStringPleaseInputPhoneNumber                                                                               \
JXT(NSLocalizedString(@"PleaseInputPhoneNumber", @"请输入手机号码"), @"请输入手机号码")
#define kStringPhoneNumberCantAllWhitespace                    \
JXT(NSLocalizedString(@"kStringPhoneNumberCantAllWhitespace", @"手机号码不能全为空格"), @"手机号码不能全为空格")
#define kStringPhoneNumberNeedNotSame                                                                                   \
JXT(NSLocalizedString(@"PhoneNumberNeedNotSame", @"请输入与原手机号码不一样的号码"), @"请输入与原手机号码不一样的号码")
#define kStringPhoneNumberMustBe11Count                                                                     \
JXT(NSLocalizedString(@"PhoneNumberMustBe11Count", @"手机号码必须是11位"), @"手机号码必须是11位")
#define kStringPhoneNumberFormatError          \
JXT(NSLocalizedString(@"PhoneNumberFormatError", @"手机号码格式错误"), @"手机号码格式错误")
#define kStringPhoneNumberInvalidChar          \
JXT(NSLocalizedString(@"kStringPhoneNumberInvalidChar", @"手机号码不能包含无效字符"), @"手机号码不能包含无效字符")

#define kStringUnhandledCase                    \
JXT(NSLocalizedString(@"UnhandledCase", @"未处理的case！"), @"未处理的case！")
#define kStringCantAllWhitespace                    \
JXT(NSLocalizedString(@"kStringCantAllWhitespace", @"不能全为空格或换行"), @"不能全为空格或换行")
#define kStringCantLTWhitespace                    \
JXT(NSLocalizedString(@"kStringCantLTWhitespace", @"首尾不能包含空格或换行"), @"首尾不能包含空格或换行")
#define kStringMustASCIIChars                    \
JXT(NSLocalizedString(@"kStringMustASCIIChars", @"只能为字母或数字"), @"只能为字母或数字")
#define kStringLocationServiceIsClosedPleaseToOpenInSetting                    \
JXT(NSLocalizedString(@"kStringLocationServiceIsClosedPleaseToOpenInSetting", @"定位服务已关闭，请前往设置页面打开"), @"定位服务已关闭，请前往设置页面打开")
#define kStringLocationServiceIsRejectedPleaseToOpenInSetting                    \
JXT(NSLocalizedString(@"kStringLocationServiceIsRejectedPleaseToOpenInSetting", @"定位服务已拒绝，请前往设置页面打开"), @"定位服务已拒绝，请前往设置页面打开")
//#define kStringNetworkDisable                    \
//JXT(NSLocalizedString(@"kStringNetworkDisable", @"亲，您的网路貌似不可用哦"), @"亲，您的网路貌似不可用哦")

#endif






