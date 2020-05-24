//
//  User.h
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/19.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "JXObject.h"
#import "Type.h"
#import "JXArchiveObject.h"

//"token": "ACCOUNT_MERCHANT_LOGIN_c0f168ce8900fa56e57789e2a2f2c9d0_611B0A78746E4FDD8D50165DD0326ACF",
//"phoneNumber": "13678013283",
//"nickName": null,
//"merchatRole": 0,
//"authStatus": 3,
//"authDescription": "",
//"shopName": "Beautiful store",
//"serviceTime": "09:00:00-21:00:00",
//"businessScopes": "洗衣,洗鞋,皮具洗护,奢侈品洗护,其他",
//"shopLogo": "http://img.appvworks.com/4355a64f7c77474fb40a0df154d1adc5",
//"shopId": 378,
//"shopState": 1,
//"sleeping": 1,
//"latitude": 30.54635684951646,
//"longitude": 104.0751194836681,
//"shopDescription": null,
//"shopTelPhone": "028-87859623"

@interface User : JXArchiveObject
@property (nonatomic, assign) UserRole merchatRole;
@property (nonatomic, assign) AccountStatus authStatus;
@property (nonatomic, assign) NSInteger shopId;
@property (nonatomic, assign) ShopStatus shopState;
@property (nonatomic, assign) BusinessStatus sleeping;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *authDescription;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *serviceTime;
@property (nonatomic, copy) NSString *businessScopes;
@property (nonatomic, copy) NSString *shopLogo;
@property (nonatomic, copy) NSString *shopDescription;
@property (nonatomic, copy) NSString *shopTelPhone;

+ (instancetype)userForCurrent;
@end






