//
//  JXAssetManager.h
//  AuraU
//
//  Created by 杨建祥 on 15/3/21.
//  Copyright (c) 2015年 Thundersoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXAssetPhotoGroup.h"

@interface JXAssetManager : NSObject
+ (JXAssetManager *)sharedInstance;

- (void)setupPhotoGroupBlocksWithStart:(void(^)())startBlock
                               success:(void(^)(NSArray *groups))successBlock
                               failure:(void(^)(NSError *error))failureBlock
                            completion:(void(^)())completionBlock;
- (void)fetchPhotoGroup;
@end
