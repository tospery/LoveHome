//
//  AppDelegate.h
//  iOSBase02（获取尺寸信息）
//
//  Created by Thundersoft on 10/17/14.
//  Copyright (c) 2014 Thundersoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, UITabBarControllerDelegate, BMKGeneralDelegate>
@property (nonatomic, assign) BOOL updated;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UITabBarController *tabBarController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)entryHomeWithAnimated:(BOOL)animated;

+ (AppDelegate *)appDelegate;
@end
