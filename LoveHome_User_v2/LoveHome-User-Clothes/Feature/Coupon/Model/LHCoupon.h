//
//  LHCoupon.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/2.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LHCouponStatus){
    LHCouponStatusNormal,
    LHCouponStatusUsed,
    LHCouponStatusExpired,
    LHCouponStatusHavenot
};

typedef NS_ENUM(NSInteger, LHCouponType){
    LHCouponTypePlatform = 1,
    LHCouponTypeShop,// 多店
    LHCouponTypeChannel // 单店
};

//"accountId": 565,
//"couponId": 99,
//"couponScope": "平台通用",
//"shopId": null,
//"couponType": "直接可使用",
//"effectiveDate": "2015-09-17",
//"expiryDate": "2015-10-03",
//"status": 0,
//"price": 0.03,
//"fullPrice": 0,
//"useScope": "全品类",
//"kind": 1


@interface LHCoupon : NSObject
@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *couponId;
@property (nonatomic, strong) NSString *couponScope;
@property (nonatomic, strong) NSString *couponType;
@property (nonatomic, strong) NSString *effectiveDate;
@property (nonatomic, strong) NSString *expiryDate;
@property (nonatomic, assign) LHCouponStatus status;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat fullPrice;
@property (nonatomic, strong) NSString *useScope;
@property (nonatomic, assign) LHCouponType kind;
@property (nonatomic, strong) NSArray *shopId;
@property (nonatomic, strong) NSArray *goodsId;


@end
