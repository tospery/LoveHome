//
//  UserModel.h
//  LoveHome
//
//  Created by Joe Chen on 14/11/24.
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





+ (UserDataModel *)fetch;
+ (void)storage:(UserDataModel *)user;

@end
