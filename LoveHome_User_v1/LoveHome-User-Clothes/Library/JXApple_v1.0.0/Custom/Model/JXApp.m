//
//  JXApp.m
//  LoveHome-User
//
//  Created by 杨建祥 on 15/7/4.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "JXApp.h"

@implementation JXApp
+ (NSString *)version {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)identifier {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)name {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}
@end