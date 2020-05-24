//
//  AppDelegate.m
//  iOSBase02（获取尺寸信息）
//
//  Created by Thundersoft on 10/17/14.
//  Copyright (c) 2014 Thundersoft. All rights reserved.
//

#import "AppDelegate.h"
#import "LHHomeViewController.h"
#import "LHMineViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UMSocialWechatHandler.h"
#import "LHMessageViewController.h"
#import "LHCartViewController.h"
#import "LHIntroViewController.h"
#import "UMCheckUpdate.h"

LHGlobal *gLH;
BMKMapManager *mapManager;

@interface AppDelegate ()
@property (nonatomic, copy) NSString *trackViewUrl;
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupJPush:launchOptions];
    [self setupBMap];
    [self setupUM];
    [self setupUMAnalytics];
    [self setupJSPatch];
    
    [JXConfigManager configLog];
    [JXConfigManager configKeyboard];
    [JXConfigManager configNetwork];
    
    gLH = [LHGlobal sharedGlobal];
    [self loadViews];
    
//    NSString *appVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *version = [userDefaults objectForKey:kAppVersion];
//    if ([version isEqualToString:appVersion]) {
//        [self makeController];
//    } else {
//        isFirstStartAfterInstall = YES;
//        [self loadAdvertiseView];
//    }
    
    NSString *preVersion = gLH.version;
    NSString *curVersion = [JXApp version];
    if ([preVersion isEqualToString:curVersion]) {
        [self entryHomeWithAnimated:NO];
    }else {
        [self entryIntro];
    }
    
    //[self entryHomeWithAnimated:NO];
    
//    NSString *a1 = @"2015-07-20 08:30";
//    NSDate *a2 = [a1 exDateWithFormat:kJXFormatDatetimeStyle2];
//    NSString *a3 = [a2 exStringWithFormat:kJXFormatDatetimeStyle2];
    
    //[self handlePush:[launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey]];
    [self autoGetUserinfoIfNeed];
    
    //JXLogDebug(@"%@", NSHomeDirectory());
    
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //   如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            //NSLog(@"支付宝支付结构：%@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyAlipayRecharge object:nil userInfo:resultDic];
            [[NSNotificationCenter defaultCenter]  postNotificationName:kNotifyAlipayPayment object:nil userInfo:resultDic];
        }];
    }
    
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            //NSLog(@"支付宝支付结构：%@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyAlipayRecharge object:nil userInfo:resultDic];
            
        }];
    }
    
    return [UMSocialSnsService handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [gLH storage];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self checkUpdate];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //[MagicalRecord cleanUp];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [APService registerDeviceToken:deviceToken];
//    NSString *code = [APService registrationID];
//    if (code.length != 0) {
//        [LHHTTPClient postPushCodeWithCode:code success:NULL failure:NULL];
//    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    if (UIApplicationStateActive == application.applicationState) {
        return;
    }
    [self handlePush:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [UMSocialSnsService handleOpenURL:url];
}

#pragma mark - Core Data stack
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.appvworks.test" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LoveHome" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LoveHome.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Private methods
+ (AppDelegate *)appDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

/**
 *  加载视图控制器和窗口
 */
- (void)loadViews {
    // Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // Home
    NSArray *controllers = @[[[LHHomeViewController alloc] init],
                             [[LHCartViewController alloc] init],
                             [[LHMineViewController alloc] init]];
    
    NSArray *imagesNormal = @[[UIImage imageNamed:@"tabbar_home"],
                              [UIImage imageNamed:@"tabbar_cart"],
                              [UIImage imageNamed:@"tabbar_mine"]];
    NSArray *imagesSelected = @[[UIImage imageNamed:@"tabbar_home_selected"],
                                [UIImage imageNamed:@"tabbar_cart_selected"],
                                [UIImage imageNamed:@"tabbar_mine_selected"]];
    NSMutableArray *navControllers = [NSMutableArray array];
    for (NSInteger i = 0; i < controllers.count; ++i) {
        LHNavigationController *navController = [[LHNavigationController alloc] initWithRootViewController:controllers[i]];
        
        navController.navigationBar.translucent = NO;
        navController.navigationBar.barTintColor = kColorNavBar;
        navController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                           ColorRGB(51, 51, 51), NSForegroundColorAttributeName,
                                                           [UIFont systemFontOfSize:18],NSFontAttributeName ,nil];
        
        navController.tabBarItem.tag = i;
        [navController.tabBarItem setImage:[imagesNormal[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [navController.tabBarItem setSelectedImage:[imagesSelected[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [navController.tabBarItem setImageInsets:UIEdgeInsetsMake(4, 0, -4, 0)];
        [navControllers addObject:navController];
    }
    _tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    _tabBarController.tabBar.translucent = YES;
    _tabBarController.tabBar.barTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    //_tabBarController.tabBar.alpha = 0.7;
    _tabBarController.viewControllers = navControllers;
    
    //    if (iOSVersionGreaterThanOrEqual(8.0)) {
    //        [UINavigationBar appearance].translucent = NO;
    //        [UINavigationBar appearance].barTintColor = kColorNavBar;
    //        [UINavigationBar appearance].titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
    //                                                            ColorRGB(51, 51, 51), NSForegroundColorAttributeName,
    //                                                            [UIFont systemFontOfSize:18],NSFontAttributeName ,nil];
    //
    //        [UITabBar appearance].translucent = NO;
    //        [UITabBar appearance].barTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    //        [UITabBar appearance].alpha = 0.7;
    //    }
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = kPlainTextLightColor;
    attrs[NSFontAttributeName]            = [UIFont systemFontOfSize:14];
    NSShadow *shadow                      = [[NSShadow alloc] init];
    shadow.shadowOffset                   = CGSizeZero;
    attrs[NSShadowAttributeName]          = shadow;
    [[UIBarButtonItem appearance] setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:attrs forState:UIControlStateHighlighted];
    
    NSMutableDictionary *disabledAttrs = [NSMutableDictionary dictionary];
    disabledAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [[UIBarButtonItem appearance] setTitleTextAttributes:disabledAttrs forState:UIControlStateDisabled];
}

/**
 *  进入主界面
 */
- (void)entryHomeWithAnimated:(BOOL)animated {
    if (animated) {
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.5;
        animation.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];;
        animation.type = kCATransitionFade;
        NSUInteger pre = [self.window.subviews indexOfObject:self.window.rootViewController.view];
        NSUInteger cur = [self.window.subviews indexOfObject:_tabBarController.view];
        [self.window exchangeSubviewAtIndex:pre withSubviewAtIndex:cur];
        [self.window.layer addAnimation:animation forKey:kJXAnimationForMainInterface];
    }
    
    self.window.rootViewController = _tabBarController;
    [self.window makeKeyAndVisible];
}

- (void)entryIntro {
    LHIntroViewController *introVC = [[LHIntroViewController alloc] init];
    self.window.rootViewController = introVC;
    [self.window makeKeyAndVisible];
}

- (void)setupJPush:(NSDictionary *)launchOptions {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    [APService setupWithOption:launchOptions];
}

- (void)setupBMap {
    mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [mapManager start:kBaiduMap generalDelegate:self];
    if (!ret) {
        //LogWarn(@"【百度地图】manager start failed!");
    }
}

- (void)setupUM {
    [MobClick setLogEnabled:YES];
    [UMSocialData setAppKey:kUMAppkey];
    [UMSocialWechatHandler setWXAppId:kWXAppID appSecret:kWXAppSecret url:kWebOfficialSite];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = kStringShareTitle;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = kStringShareTitle;
}

- (void)setupUMAnalytics {
    [MobClick setAppVersion:XcodeAppVersion];
    [MobClick startWithAppkey:kAppkeyUMAnalytics reportPolicy:(ReportPolicy)REALTIME channelId:nil];
    [MobClick updateOnlineConfig];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}

- (void)setupJSPatch {
    [JPEngine startEngine];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.appvworks.com/download/app-ios-patch.js"]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *script = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ([script hasPrefix:@"/* 爱为家-iOS-Patch */"]) {
            [JPEngine evaluateScript:script];
        }
    }];
}

- (void)checkUpdate {
    [[JXVersionManager sharedInstance] checkUpdateWithAppID:@"1041921285" beginning:^{
        
    } completion:^(BOOL updated, NSString *newVersion, NSString *releaseNote, NSString *openURL, NSError *error) {
        if (updated) {
            _trackViewUrl = openURL;
            NSString *later = @"以后再说";
            if ([releaseNote containsString:@"【重要】"]) {
                later = nil;
            }
            JXAlertParams(([NSString stringWithFormat:@"有新版本 %@", newVersion]), releaseNote, later, @"立即更新");
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex &&
        _trackViewUrl.length != 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_trackViewUrl]];
    }
}

- (void)handlePush:(NSDictionary *)dict {
    if (!dict) {
        return;
    }
    
    [self.tabBarController.selectedViewController showLoginIfNotLoginedWithFinish:^() {
        LHMessageViewController *messageVC = [[LHMessageViewController alloc] init];
        messageVC.hidesBottomBarWhenPushed = YES;
        [(UINavigationController *)self.tabBarController.selectedViewController pushViewController:messageVC animated:YES];
    }];
}

- (void)autoGetUserinfoIfNeed {
    if (!gLH.logined) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LHHTTPClient getUserinfoWithSuccess:^(AFHTTPRequestOperation *operation, LHUserInfo *userinfo) {
            gLH.user.info = userinfo;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        } retryTimes:3];
    });
}

#pragma mark - Notification
- (void)onlineConfigCallBack:(NSNotification *)note {
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

#pragma mark - Delegate
#pragma mark UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

#pragma mark BMKGeneralDelegate
- (void)onGetNetworkState:(int)iError {
    if (0 == iError) {
        //LogInfo(@"【百度地图】联网成功");
    } else{
        //LogWarn(@"【百度地图】onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError {
    if (0 == iError) {
        //LogInfo(@"【百度地图】授权成功");
    }else {
        //LogWarn(@"【百度地图】onGetPermissionState %d",iError);
    }
}
@end



