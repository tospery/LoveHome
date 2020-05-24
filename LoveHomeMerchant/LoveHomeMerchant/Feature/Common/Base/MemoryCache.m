//
//  MemoryCache.m
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/21.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "MemoryCache.h"

@implementation MemoryCache
- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (NSInteger)unreadCount {
    static BOOL onceToken = NO;
    if (!onceToken && !_unreadCount) {
        onceToken = YES;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        _unreadCount = [ud integerForKey:kUdUnreadCount];
    }
    return _unreadCount;
}

- (NSInteger)visitCount {
    static BOOL onceToken = NO;
    if (!onceToken && !_visitCount) {
        onceToken = YES;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        _visitCount = [ud integerForKey:kUdVisitCount];
    }
    return _visitCount;
}

- (void)saveToLocal {
    [super saveToLocal];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:_unreadCount forKey:kUdUnreadCount];
    [ud setInteger:_visitCount forKey:kUdVisitCount];
    [ud synchronize];
}

+ (instancetype)sharedInstance {
    static MemoryCache *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MemoryCache alloc] init];
    });
    return instance;
}
@end


