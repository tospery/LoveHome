//
//  LHWXPayResponse.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 16/2/16.
//  Copyright © 2016年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHWXPayResponse : NSObject
@property (nonatomic, assign) NSInteger retcode;
@property (nonatomic, assign) NSUInteger timestamp;
@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *noncestr;
@property (nonatomic, copy) NSString *packages;
@property (nonatomic, copy) NSString *partnerid;
@property (nonatomic, copy) NSString *prepayid;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *retmsg;
@end
