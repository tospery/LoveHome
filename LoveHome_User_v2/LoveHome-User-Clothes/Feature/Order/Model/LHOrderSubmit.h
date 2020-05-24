//
//  LHOrderSubmit.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/7.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHOrderSubmitOrderDetail : NSObject
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *specId;
@property (nonatomic, strong) NSString *specName;
@property (nonatomic, assign) CGFloat specPrice;
@property (nonatomic, assign) NSInteger count;
@end

@interface LHOrderSubmitOrderList : NSObject
@property (nonatomic, assign) CGFloat activityPrice;
@property (nonatomic, assign) NSInteger activityId;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSArray *orderDetailList;
@end


@interface LHOrderSubmit : NSObject
@property (nonatomic, assign) NSInteger shopId;
@property (nonatomic, assign) NSInteger orderType;
@property (nonatomic, strong) NSString *customerName;
@property (nonatomic, strong) NSString *customerTelephone;
@property (nonatomic, strong) NSString *customerAddress;
@property (nonatomic, strong) NSString *addressId;

@property (nonatomic, strong) NSDecimalNumber *orderTotalPrice;
@property (nonatomic, assign) NSInteger creditsCount; // 爱豆

@property (nonatomic, assign) LHPayWay payment;

@property (nonatomic, strong) NSString *couponId;
@property (nonatomic, strong) NSString *cardNo;
@property (nonatomic, strong) NSString *appointTime;

@property (nonatomic, strong) NSArray *orderList;
@end
