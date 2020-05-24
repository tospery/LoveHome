//
//  JXConfigManager.m
//  TianlongHome
//
//  Created by 杨建祥 on 15/4/21.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "JXConfigManager.h"
#import "JXApple.h"

#ifdef JXEnableMagicalRecord
#import "CoreData+MagicalRecord.h"
#endif

#ifdef JXEnableCocoaLumberjack
#import "CocoaLumberjack.h"
#endif

#ifdef JXEnableIQKeyboardManager
#import "IQKeyboardManager.h"
#endif

#ifdef JXEnableAFNetworking
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#endif

#ifdef JXEnableCocoaLumberjack
#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif
#endif

@implementation JXConfigManager
+ (void)configDatabase {
#if JXEnableMagicalRecord
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"LoveHome.sqlite"];
#endif
}

+ (void)configLog {
#if JXEnableCocoaLumberjack
    JXLogFormatter *formatter = [[JXLogFormatter alloc] init];
    
    [[DDASLLogger sharedInstance] setLogFormatter:formatter];
    [DDLog addLogger:[DDASLLogger sharedInstance] withLevel:ddLogLevel];
    
    [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
    [DDTTYLogger sharedInstance].colorsEnabled = YES;
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:ddLogLevel];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *logsDirectory = [baseDir stringByAppendingPathComponent:@"Logs"];
    DDLogFileManagerDefault *logFileManagerDefault = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:logsDirectory];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManagerDefault];
    fileLogger.logFormatter = formatter;
    fileLogger.rollingFrequency = 60 * 60 * 24;
    fileLogger.maximumFileSize  = 1024 * 1024 * 1;
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
#endif
}

+ (void)configKeyboard {
#ifdef JXEnableIQKeyboardManager
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.shouldShowTextFieldPlaceholder = NO;
    manager.toolbarManageBehaviour = IQAutoToolbarByPosition;
#endif
}

+ (void)configBarWithNavBarColor:(UIColor *)navBarColor
                navBarTitleColor:(UIColor *)navBarTitleColor
                     tabBarColor:(UIColor *)tabBarColor
             tabBarSelectedColor:(UIColor *)tabBarSelectedColor
                  statusBarStyle:(UIStatusBarStyle)statusBarStyle {
    if (navBarColor) {
        if (JXiOSVersionGreaterThanOrEqual(7.0)) {
            [UINavigationBar appearance].barTintColor = navBarColor;
        }else {
            [[UINavigationBar appearance] setBackgroundImage:[UIImage exImageWithColor:navBarColor]
                                               forBarMetrics:UIBarMetricsDefault];
        }
    }
    
    [UINavigationBar appearance].translucent = NO;
    [UITabBar appearance].translucent = NO;
    
    [UINavigationBar appearance].titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:navBarTitleColor, NSForegroundColorAttributeName, nil];
    [UITabBar appearance].barTintColor = tabBarColor;
    [UITabBar appearance].selectedImageTintColor = tabBarSelectedColor;
    [[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle];
}

+ (void)configNetwork {
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:50 * 1024 * 1024 diskCapacity:50 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
#ifdef JXEnableAFNetworking
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
#endif
}
@end