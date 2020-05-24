//
//  UserModel.h
//  LoveHome
//
//  Created by MRH on 14/11/24.
//  Copyright (c) 2014年 卡莱博尔. All rights reserved.
//

#import "BaseDataModel.h"
#import <CoreLocation/CoreLocation.h>
@class UserAlipayAccount;
@class UserBankAccount;


#define USERMODULE_USERID @"userid"


@interface UserDataModel : NSObject

@property (nonatomic,copy)   NSString *token;
@property (nonatomic,copy)   NSString *phoneNumber;
@property (nonatomic,strong) NSString *businessScopes;
@property (nonatomic,strong) NSString *shopName;
@property (nonatomic,strong) NSString *serviceTime;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *shopLogo;
@property (nonatomic,assign) NSInteger authStatus;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic, assign) NSInteger shopId;

@property (nonatomic, assign) NSInteger shopState;

@property (nonatomic, assign) NSInteger sleeping;

#warning 认证失败返回的字段
#pragma mark - 认证失败返回的字段
@property (nonatomic, strong) NSString *authDescription;






+ (UserDataModel *)fetch;
+ (void)storage:(UserDataModel *)user;

@end
