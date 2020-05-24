//
//  AppDelegate.h
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/16.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "JXNavigationControllerStack.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//
//- (void)saveContext;
//- (NSURL *)applicationDocumentsDirectory;


@property (nonatomic, strong, readonly) JXNavigationControllerStack *navigationControllerStack;
@property (nonatomic, assign, readonly) NetworkStatus networkStatus;
@property (nonatomic, copy, readonly) NSString *adURL;

//@property (nonatomic, strong, readonly) JXCoreDataHelper *coreDataHelper;

@end

