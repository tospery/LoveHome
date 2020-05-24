//
//  AppDelegate.h
//  LoveHome
//
//  Created by Joe Chen on 14/11/3.
//  Copyright (c) 2014年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKMapView.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate>

@property (strong, nonatomic          ) UIWindow                     *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext       *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel         *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic          ) AFHTTPRequestOperation       *catagoryRequest;
@property (strong, nonatomic) ModelViewController *myController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
