//
//  AppDelegate.m
//  LoveHome
//
//  Created by MRH on 14/11/3.
//  Copyright (c) 2014年 卡莱博尔. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkReachabilityManager.h"
#import "RootController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "BaseNavigationController.h"
#import "SettShopBaseInfoController.h"
#import "IQKeyboardManager.h"
#import "RegistShopModel.h"
#import "AutoShopViewController.h"
#import "HomeTool.h"
#import "HttpSessionManager.h"
#import "SettingAccoutViewController.h"
#import "RHVersionManager.h"
//新增友盟分享
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialData.h"
#import "UMSocialControllerService.h"
#import "UMSocialDataService.h"
#import "WXApi.h"

#define kUMAppkey                       (@"564957b8e0f55aa261000ca1") //(@"55e06c72e0f55a91500006b7")
#define kWXAppID                        (@"wx6e23d0e0ba2d18fa")
#define kWXAppSecret                    (@"e74b16ee5713c87cb8f26391aaf700dc")
#define kAppKey                         (@"8f3206d0b73ea8fe")
#define kAppSecret                      (@"68de6fd28f3206d0b73ea8feb7f4b7ec")
#define kWebOfficialSite   (@"http://www.appvworks.com")
#define kStringShareTitle (@"爱为家商家版")

BMKMapManager *mapManager;

@interface AppDelegate ()<UIAlertViewDelegate, UIScrollViewDelegate>
{
    BOOL isOut;
}
@property (nonatomic, copy) NSString *trackViewUrl;
/**
 *  引导页page
 */
@property (nonatomic, strong) UIPageControl *page;

@end

@implementation AppDelegate

@synthesize managedObjectContext       = _managedObjectContext;
@synthesize managedObjectModel         = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    //网络指示标志
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    //网络监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    //使用存储数据初始化user

    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.shouldShowTextFieldPlaceholder = YES;
    manager.enableAutoToolbar = YES;
    
    [UMSocialData setAppKey:kUMAppkey];
    [UMSocialWechatHandler setWXAppId:kWXAppID appSecret:kWXAppSecret url:kWebOfficialSite];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = kStringShareTitle;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = kStringShareTitle;
   
    isOut = NO;

       RootController*root = [[RootController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:root];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    //判断是不是第一次启动应用
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        NSLog(@"第一次启动");
        [self makeLaunchView];
        
    }
    else
    {
        NSLog(@"不是第一次启动");
        //如果不是第一次启动的话,使用LoginViewController作为根视图
        [self gotoMain];
        
    }

//    //请求类别数据
//    
//    MyComment *c1 = [MyComment new];
//    c1.uid = 1;
//    MyComment *c2 = [MyComment new];
//    c2.uid = 2;
//    MyComment *c3 = [MyComment new];
//    c3.uid = 3;
//    MyComment *c4 = [MyComment new];
//    c4.uid = 4;
//    MyComment *c5 = [MyComment new];
//    c5.uid = 5;
//    
//    NSMutableArray *arr = [NSMutableArray array];
//    [arr addObject:c1];
//    [arr addObject:c2];
//    [arr addObject:c3];
//    [arr addObject:c4];
//    [arr addObject:c5];
//    
//    MyComment *c6 = [MyComment new];
//    c6.uid = 5;
//    MyComment *c7 = [MyComment new];
//    c7.uid = 5;
//    
//    NSArray *arrRefresh1 = @[c6, c7, c1, c2, c3];
//    NSArray *arrRefresh2 = @[c6, c7, c3, c4, c5];
//    
//    int a = 0;
    
    [self setupBMap];
    [self checkUpdateVersion];
    
    
    
    
    return YES;
}

- (void)setupBMap {
    mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [mapManager start:@"6ycnbrGj2GXBgbrXGNmszzv1" generalDelegate:self];
    if (!ret) {
//        //NSLog(@"【百度地图】manager start failed!");
    }
}

#pragma mark - 更新版本
- (void)checkUpdateVersion{
    

    [[RHVersionManager sharedInstance] checkUpdateWithAppID:@"979831889" beginning:nil completion:^(BOOL updated, NSString *newVersion, NSString *releaseNote, NSString *openURL, NSError *error) {
        if (updated) {
            _trackViewUrl = openURL;
            JXAlertParams(([NSString stringWithFormat:@"有新版本 %@", newVersion]), releaseNote, @"以后再说", @"立即更新");
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex &&
        _trackViewUrl.length != 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_trackViewUrl]];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [UMSocialSnsService handleOpenURL:url];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
//        return  [WXApi handleOpenURL:url delegate:self];
//    }
    
    return [UMSocialSnsService handleOpenURL:url];
}
- (void)sendLoginRequestIfNeed
{
    
}

//假引导页面
- (void)makeLaunchView{
    NSArray *arr=[NSArray arrayWithObjects:@"1.jpg",@"2.jpg",@"3.jpg", nil];//数组内存放的是我要显示的假引导页面图片
    //通过scrollView 将这些图片添加在上面，从而达到滚动这些图片
    UIScrollView *scr=[[UIScrollView alloc] initWithFrame:self.window.bounds];
    scr.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width*arr.count, self.window.frame.size.height);
    scr.pagingEnabled=YES;
    scr.tag=7000;
    scr.delegate=self;
    [self.window addSubview:scr];
    for (int i=0; i<arr.count; i++) {
        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(i*[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, self.window.frame.size.height)];
        img.image=[UIImage imageNamed:arr[i]];
        [scr addSubview:img];
        
    }
    [self addPage];
}
#pragma mark scrollView的代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //这里是在滚动的时候判断 我滚动到哪张图片了，如果滚动到了最后一张图片，那么
    //如果在往下面滑动的话就该进入到主界面了，我这里利用的是偏移量来判断的，当
    //一共四张图片，所以当图片全部滑完后 又像后多滑了30 的时候就做下一个动作
    if (scrollView.contentOffset.x > 2*[UIScreen mainScreen].bounds.size.width+30) {
        isOut=YES;//这是我声明的一个全局变量Bool 类型的，初始值为no，当达到我需求的条件时将值改为yes
    }
}

/* 创建page */
- (void)addPage
{
    self.page = [[UIPageControl alloc]initWithFrame:CGRectMake(self.window.frame.size.width / 2 - 50, self.window.frame.size.height - 80, 100, 40)];
    [self.window addSubview:self.page];
    self.page.currentPage = 0;
    self.page.numberOfPages = 3;
    self.page.backgroundColor = [UIColor clearColor];
    
}
//停止滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    self.page.currentPage = index;
    //判断isout为真 就要进入主界面了
    if (isOut) {
        //这里添加了一个动画，（可根据个人喜好）
        [UIView animateWithDuration:1 animations:^{
            scrollView.alpha=0;//让scrollview 渐变消失
        }completion:^(BOOL finished) {
            [scrollView  removeFromSuperview];//将scrollView移除
            [self gotoMain];//进入主界面
        } ];
    }
}
//去主页
- (void)gotoMain{
    //            //如果第一次进入没有文件，我们就创建这个文件
    //            NSFileManager *manager=[NSFileManager defaultManager];
    //            //判断 我是否创建了文件，如果没创建 就创建这个文件（这种情况就运行一次，也就是第一次启动程序的时候）
    //            if (![manager fileExistsAtPath:[NSHomeDirectory() stringByAppendingString:@"YDY.txt"]]) {
    //                [manager createFileAtPath:[NSHomeDirectory() stringByAppendingString:@"YDY.txt"] contents:nil attributes:nil];
    //            }
    [self.page removeFromSuperview];
    //_window.rootViewController = _yrSliderVC;
    //    NSUserDefaults
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    [UserTools sharedUserTools].userModel = [UserTools sharedUserTools].userModel;
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LoveHome" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LoveHome.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark BMKGeneralDelegate
- (void)onGetNetworkState:(int)iError {
    if (0 == iError) {
//        //NSLog(@"【百度地图】联网成功");
    } else{
//        //NSLog(@"【百度地图】onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError {
    if (0 == iError) {
//        //NSLog(@"【百度地图】授权成功");
    }else {
//        //NSLog(@"【百度地图】onGetPermissionState %d",iError);
    }
}


@end
