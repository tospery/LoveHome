//
//  JXNetworkManager.h
//  LoveHome-User
//
//  Created by 杨建祥 on 15/7/6.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXNetworkManager : NSObject
+ (BOOL)isEnableInternet;
+ (BOOL)IsEnableWIFI;
+ (BOOL)IsEnableWWAN;
@end
