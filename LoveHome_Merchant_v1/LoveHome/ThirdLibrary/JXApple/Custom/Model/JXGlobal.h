//
//  JXGlobal.h
//  LoveHome-User
//
//  Created by 杨建祥 on 15/7/3.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXApple.h"

@interface JXGlobal : NSObject
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *password;

- (void)storage;
- (void)cleanupUserinfo;

+ (JXGlobal *)sharedGlobal;
@end
