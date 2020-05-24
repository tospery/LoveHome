//
//  AppDelegate.m
//  LoveHome
//
//  Created by Joe Chen on 14/11/3.
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

BMKMapManager *mapManager;

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
//    
//    LoginViewController *loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
//    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginController];
//    nav.navigationBar.hidden = YES;
//    
//    
//    self.window.rootViewController = nav;
    
//    [self.window makeKeyAndVisible];
//    return YES;
    
//    if (IsTheApplicationNewVersion())
//    {
//        GuideViewController *rootController                             = [[GuideViewController alloc] initWithNibName:@"GuideViewController" bundle:[NSBundle mainBundle]];
//        self.window.rootViewController = rootController;
//    }else
//    {
//        if (![UserUtility shareUserUtility].isAutoLogin)
//        {
//            
//            //重新登录
//            [self sendLoginRequestIfNeed];
//            
//            
//            RootViewController *rootController                             = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:[NSBundle mainBundle]];
//            
//            self.window.rootViewController = rootController;
//        }else
//        {
//            
//            LoginViewController *loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
//            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginController];
//            nav.navigationBar.hidden = YES;
//            
//            self.window.rootViewController = loginController;
//        }
//    }
////
//    AFHTTPRequestOperation *oprea =  [HomeTool sendSelctWalletetShopNearly7daysIncome:^(AFHTTPRequestOperation *operation, id responsObject) {
//        
//
//
//        
//        
//        
//    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//    }];
//    
//  
//    
//    NSMutableURLRequest * request = [[AFJSONRequestSerializer serializer] multipartFormRequestWithMethod:nil URLString:nil parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//    } error:nil];
//    
//     AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    
//
//    
//    
//
//    NSOperationQueue *que = [[NSOperationQueue alloc] init];
//    [que addOperation:oprea];
//    
    
   
    RootController *root = [[RootController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:root];
    self.window.rootViewController = nav;

    
    [self.window makeKeyAndVisible];
    
    
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
    
    return YES;
}

- (void)setupBMap {
    mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [mapManager start:@"6ycnbrGj2GXBgbrXGNmszzv1" generalDelegate:self];
    if (!ret) {
//        //NSLog(@"【百度地图】manager start failed!");
    }
}


- (void)sendLoginRequestIfNeed
{
    
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
