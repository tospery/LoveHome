////
////  LHUser.h
////  LoveHome-User-Clothes
////
////  Created by 杨建祥 on 15/7/23.
////  Copyright (c) 2015年 艾维科思. All rights reserved.
////
//
#import <Foundation/Foundation.h>
#import "LHUserInfo.h"

@interface LHUser : NSObject
@property (nonatomic, copy) NSString *token;
@property (nonatomic, strong) LHUserInfo *info;

+ (LHUser *)fetch;
+ (void)storage:(LHUser *)user;
@end
