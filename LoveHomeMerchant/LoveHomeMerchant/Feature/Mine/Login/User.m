//
//  User.m
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/19.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "User.h"
#import "MemoryCache.h"

@implementation User
+ (instancetype)userForCurrent {
    User *user = [[MemoryCache sharedInstance] objectForKey:MemoryCacheUser];
    static BOOL onceToken = NO;
    if (!onceToken && !user) {
        onceToken = YES;
        user = [User fetch];
        [[MemoryCache sharedInstance] setObject:user forKey:MemoryCacheUser toCached:YES];
    }
    return user;
}
@end
