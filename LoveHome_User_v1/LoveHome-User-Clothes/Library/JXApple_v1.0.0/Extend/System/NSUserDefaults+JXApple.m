//
//  NSUserDefaults+JXApple.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/12.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "NSUserDefaults+JXApple.h"

@implementation NSUserDefaults (JXApple)
/**
 *  清理用户设置
 */
- (void)exClean {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}
@end
