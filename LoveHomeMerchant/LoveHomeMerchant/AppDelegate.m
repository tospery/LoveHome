//
//  AppDelegate.m
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/16.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "AppDelegate.h"
#import "JXViewModelServicesImpl.h"
#import "JXNavigationControllerStack.h"
#import "JXNavigationController.h"
#import "LoginViewModel.h"
#import "LoginViewController.h"
#import "MainViewModel.h"

@interface AppDelegate ()
@property (nonatomic, strong) JXViewModelServicesImpl *services;
@property (nonatomic, strong) JXViewModel *viewModel;
@property (nonatomic, strong) Reachability *reachability;

@property (nonatomic, strong, readwrite) JXNavigationControllerStack *navigationControllerStack;
@property (nonatomic, assign, readwrite) NetworkStatus networkStatus;
@property (nonatomic, copy, readwrite) NSString *adURL;

//@property (nonatomic, strong, readwrite) JXCoreDataHelper *coreDataHelper;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [JXVendorManager configKeyboard];
    [JXVendorManager configNetwork];
    [JXVendorManager configJSPatch];
//    [JXVendorManager configAlert];
//    
//    [self config];
//    [self initWeixin];
//    [self initBPushWithOptions:launchOptions];
//    [self checkUpdate];
//    
    // [self loadViews];
    //[self entryLogin];
//    [self entryMainWithAnimated:NO];
//    [self configAppearance];
    
    
    self.services = [[JXViewModelServicesImpl alloc] init];
    self.navigationControllerStack = [[JXNavigationControllerStack alloc] initWithServices:self.services];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.services resetRootViewModel:[self createInitialViewModel]];
//    LoginViewController *loginVC = [[LoginViewController alloc] init];
//    JXNavigationController *loginNav = [[JXNavigationController alloc] initWithRootViewController:loginVC];
//    self.window.rootViewController = loginNav;
    [self.window makeKeyAndVisible];
    
//    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
//    if ([a conformsToProtocol:@protocol(UIAppearance)]) {
//        int bbb = 0;
//    }
//    
//    [UIAppearance
    
//    UIAppearance *a = [UINavigationBar appearance];
//    a.translucent = NO;
////    if ([a isKindOfClass:[UINavigationBar class]]) {
////        int b = 0;
////    }
////    if ([a respondsToSelector:@selector(setBarTintColor:)]) {
////        int b = 0;
////    }
    
    [self configAppearance];
    
    
//    NSString *docPath = [NSString stringWithFormat:@"room/%ld", (long)room.formerid];
//    NSString *locPath = [NSString exFilepathStringWithFilename:docPath];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath:locPath]) {
//        [fileManager createDirectoryAtPath:locPath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    return [documents stringByAppendingPathComponent:filename];
    
    JXLogDebug(@"%@", NSHomeDirectory());
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    // [UserData storage];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[MemoryCache sharedInstance] saveToLocal];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
    [[MemoryCache sharedInstance] saveToLocal];
}

//#pragma mark - Core Data stack
//
//@synthesize managedObjectContext = _managedObjectContext;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
//
//- (NSURL *)applicationDocumentsDirectory {
//    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.appvworks.LoveHomeMerchant" in the application's documents directory.
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//}
//
//- (NSManagedObjectModel *)managedObjectModel {
//    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AppData" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
//}
//
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
//    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
//    if (_persistentStoreCoordinator != nil) {
//        return _persistentStoreCoordinator;
//    }
//    
//    // Create the coordinator and store
//    
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AppData.sqlite"];
//    NSError *error = nil;
//    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//        // Report any error we got.
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
//        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
//        dict[NSUnderlyingErrorKey] = error;
//        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
//        // Replace this with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    
//    return _persistentStoreCoordinator;
//}
//
//
//- (NSManagedObjectContext *)managedObjectContext {
//    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
//    if (_managedObjectContext != nil) {
//        return _managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (!coordinator) {
//        return nil;
//    }
//    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
//    return _managedObjectContext;
//}
//
//#pragma mark - Core Data Saving support
//
//- (void)saveContext {
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        NSError *error = nil;
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//}


#pragma mark - Custom
//- (JXCoreDataHelper *)coreDataHelper {
//    if (!_coreDataHelper) {
//        _coreDataHelper = [[JXCoreDataHelper alloc] init];
//        [_coreDataHelper setupCoreData];
//    }
//    return _coreDataHelper;
//}

- (void)loadViews {
    // Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
//
//    // Main
//    WebViewController *homeVC = [[WebViewController alloc] init];
//    homeVC.webTitle = [JXApp name];
//    homeVC.webURL = [WebSite homeURL];
//    homeVC.canNew = YES;
//    homeVC.canCache = YES;
//    
//    WebViewController *newsVC = [[WebViewController alloc] init];
//    newsVC.webTitle = @"资讯";
//    newsVC.webURL = [WebSite newsURL];
//    newsVC.canCache = YES;
//    NSArray *controllers = @[homeVC,
//                             [[ActivityViewController alloc] init],
//                             newsVC,
//                             [[MineViewController alloc] init]];
//    
//    NSArray *titles = @[@"利彩", @"活动", @"资讯", @"我的"];
//    NSArray *normalImages = @[[UIImage imageNamed:@"ic_tab_home_normal"],
//                              [UIImage imageNamed:@"ic_tab_activity_normal"],
//                              [UIImage imageNamed:@"ic_tab_news_normal"],
//                              [UIImage imageNamed:@"ic_tab_mine_normal"]];
//    NSArray *selectedImages = @[[UIImage imageNamed:@"ic_tab_home_selected"],
//                                [UIImage imageNamed:@"ic_tab_activity_selected"],
//                                [UIImage imageNamed:@"ic_tab_news_selected"],
//                                [UIImage imageNamed:@"ic_tab_mine_selected"]];
//    NSMutableArray *navControllers = [NSMutableArray array];
//    for (NSInteger i = 0; i < controllers.count; ++i) {
//        JXNavigationController *navController = [[JXNavigationController alloc] initWithRootViewController:controllers[i]];
//        ConfigNavBarStyle1(navController.navigationBar);
//        [navController.tabBarItem exConfigWithTitle:titles[i] selectedTitleColor:kColorRed normalImage:normalImages[i] selectedImage:selectedImages[i]];
//        [navControllers addObject:navController];
//    }
//    self.tabBarController = [[UITabBarController alloc] init];
//    self.tabBarController.viewControllers = navControllers;
//    [self.tabBarController.tabBar exConfigWithTranslucent:NO barTintColor:nil tintColor:nil];
}

- (void)configAppearance {
    // [UINavigationBar exAppearanceWithTranslucent:NO barColor:kColorBlack titleColor:[UIColor whiteColor] font:[UIFont exDeviceFontOfSize:17.0f]];
    [UINavigationBar exAppearanceWithTranslucent:NO barColor:nil titleColor:kColorBlack font:[UIFont exDeviceFontOfSize:17.0f]];
    [UITabBar exAppearanceWithTranslucent:NO barTintColor:nil tintColor:JXColorHex(0xFC461E)];
    [UIBarButtonItem exAppearanceWithColor:[UIColor whiteColor] font:[UIFont exDeviceFontOfSize:16.0f]];
}

- (void)entryIntro {
    
}

- (void)entryLogin {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    self.window.rootViewController = loginVC;
    [self.window makeKeyAndVisible];
}

- (void)entryMainWithAnimated:(BOOL)animated {
//    if (animated) {
//        CATransition *animation = [CATransition animation];
//        animation.delegate = self;
//        animation.duration = 0.5;
//        animation.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];;
//        animation.type = kCATransitionFade;
//        NSUInteger pre = [self.window.subviews indexOfObject:self.window.rootViewController.view];
//        NSUInteger cur = [self.window.subviews indexOfObject:self.tabBarController.view];
//        [self.window exchangeSubviewAtIndex:pre withSubviewAtIndex:cur];
//        [self.window.layer addAnimation:animation forKey:kJXAnimationForMainInterface];
//    }
//    
//    self.window.rootViewController = self.tabBarController;
//    [self.window makeKeyAndVisible];
}

- (JXViewModel *)createInitialViewModel {
//    // The user has logged-in.
//    if ([SSKeychain rawLogin].isExist && [SSKeychain accessToken].isExist) {
//        // Some OctoKit APIs will use the `login` property of `OCTUser`.
//        OCTUser *user = [OCTUser JX_userWithRawLogin:[SSKeychain rawLogin] server:OCTServer.dotComServer];
//        
//        OCTClient *authenticatedClient = [OCTClient authenticatedClientWithUser:user token:[SSKeychain accessToken]];
//        self.services.client = authenticatedClient;
//        
//        return [[JXHomepageViewModel alloc] initWithServices:self.services params:nil];
//    } else {
//        return [[JXLoginViewModel alloc] initWithServices:self.services params:nil];
//    }
    
    if ([User userForCurrent]) {
        return [[MainViewModel alloc] initWithServices:self.services params:nil];
    }else {
        return [[LoginViewModel alloc] initWithServices:self.services params:@{@"title": @"登录"}]; // YJX_TODO params -> model
    }
}

@end












