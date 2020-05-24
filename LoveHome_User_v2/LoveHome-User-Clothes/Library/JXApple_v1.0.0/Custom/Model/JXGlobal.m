//
//  JXGlobal.m
//  LoveHome-User
//
//  Created by 杨建祥 on 15/7/3.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "JXGlobal.h"

@implementation JXGlobal
JXSingletonImplementation(JXGlobal, Global)

#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _version = [userDefaults objectForKey:kJXUdVersion];
        _account = [userDefaults objectForKey:kJXUdAccount];
        _password = [userDefaults objectForKey:kJXUdPassword];
    }
    return self;
}

#pragma mark - Public methods
- (void)storage {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_version forKey:kJXUdVersion];
    [userDefaults setObject:_account forKey:kJXUdAccount];
    [userDefaults setObject:_password forKey:kJXUdPassword];
    [userDefaults synchronize];
}

- (void)cleanupUserinfo {
    _password = nil;
}
@end
