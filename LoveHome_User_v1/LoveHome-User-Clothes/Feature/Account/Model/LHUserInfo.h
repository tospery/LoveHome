//
//  LHUserInfo.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/3.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LHUserSex){
    LHUserSexMale,
    LHUserSexfemale
};

@interface LHUserInfo : NSObject
@property (nonatomic, assign) NSInteger isSetWalletPwdState; // 1已设置，2未设置
@property (nonatomic, assign) NSInteger redisAuthTypeEnum;
@property (nonatomic, assign) NSInteger accountState;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger userLevel;
@property (nonatomic, assign) NSInteger shopCount;
@property (nonatomic, assign) NSInteger orderToPayCount;
@property (nonatomic, assign) NSInteger orderToAcceptCount;
@property (nonatomic, assign) NSInteger orderAcceptedCount;
@property (nonatomic, assign) NSInteger orderFinishCount;
@property (nonatomic, assign) NSInteger collectingCount;
@property (nonatomic, assign) CGFloat accountBalance;         // 账户余额
@property (nonatomic, assign) NSInteger saleRoll;               // 优惠劵
@property (nonatomic, assign) NSInteger loveBean;               // 爱豆
@property (nonatomic, assign) CGFloat loveBeanMoney;               // 爱豆
@property (nonatomic, assign) LHUserSex sex;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *terminalType;
@property (nonatomic, copy) NSString *lastLoginIp;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *provincialCity;
@property (nonatomic, copy) NSString *receiptAddr;
@property (nonatomic, strong) NSString *lastActiveDateTime;
@property (nonatomic, strong) NSString *registerDate;
@property (nonatomic, strong) NSString *lastLoginDate;
@property (nonatomic, strong) NSString *dateOfBirth;

+ (LHUserInfo *)fetch;
+ (void)storage:(LHUserInfo *)userInfo;

@end















