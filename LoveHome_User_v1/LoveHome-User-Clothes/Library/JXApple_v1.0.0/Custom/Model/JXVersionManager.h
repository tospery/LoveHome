//
//  JXVersionManager.h
//  TianlongHome
//
//  Created by 杨建祥 on 15/4/21.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXVersionManager : NSObject
@property (nonatomic, strong, readonly) NSString *current;

#ifdef JXEnableAFNetworking
- (void)checkUpdateWithAppID:(NSString *)appID
                   beginning:(void(^)())beginning
                  completion:(void(^)(BOOL updated, NSString *newVersion, NSString *releaseNote, NSString *openURL, NSError *error))completion;
#endif

+ (JXVersionManager *)sharedInstance;
@end
