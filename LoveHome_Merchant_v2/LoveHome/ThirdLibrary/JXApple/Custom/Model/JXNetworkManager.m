//
//  JXNetworkManager.m
//  LoveHome-User
//
//  Created by 杨建祥 on 15/7/6.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "JXNetworkManager.h"
#import "JXApple.h"

#ifdef JXEnableAFNetworking
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#endif

@implementation JXNetworkManager
+ (BOOL)isEnableInternet {
#ifdef JXEnableAFNetworking
    return [AFNetworkReachabilityManager sharedManager].isReachable;
#else
    JXLogError(@"未导入AFNetworking");
    return NO;
#endif
}

+ (BOOL)IsEnableWIFI {
#ifdef JXEnableAFNetworking
    return [AFNetworkReachabilityManager sharedManager].isReachableViaWiFi;
#else
    JXLogError(@"未导入AFNetworking");
    return NO;
#endif
}

+ (BOOL)IsEnableWWAN {
#ifdef JXEnableAFNetworking
    return [AFNetworkReachabilityManager sharedManager].isReachableViaWWAN;
#else
    JXLogError(@"未导入AFNetworking");
    return NO;
#endif
}
@end
