//
//  RHVersionManager.h
//  LoveHome
//
//  Created by MRH on 14/10/4.
//  Copyright © 2014年 卡莱博尔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHVersionManager : NSObject
@property (nonatomic, strong, readonly) NSString *current;

/*!
 *  @brief  检测是否有新版本更新
 *
 *  @param appID        AppID
 *  @param beginning    开始检测时
 *  @param completion   检测完成
 */
- (void)checkUpdateWithAppID:(NSString *)appID
                   beginning:(void(^)())beginning
                  completion:(void(^)(BOOL updated, NSString *newVersion, NSString *releaseNote, NSString *openURL, NSError *error))completion;

+ (RHVersionManager *)sharedInstance;
@end
