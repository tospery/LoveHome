//
//  MemoryCache.h
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/21.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "JXMemoryCache.h"

#define MemoryCacheUser                     (@"MemoryCacheUser")
#define MemoryCacheOrderCount               (@"MemoryCacheOrderCount")
#define MemoryCacheUnreadCount              (@"MemoryCacheUnreadCount")

// #define CachedUser

@interface MemoryCache : JXMemoryCache
@property (nonatomic, assign) NSInteger unreadCount;
@property (nonatomic, assign) NSInteger visitCount;

+ (instancetype)sharedInstance;

@end
