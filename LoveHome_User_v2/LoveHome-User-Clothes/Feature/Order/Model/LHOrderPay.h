//
//  LHOrderPay.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/7.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

//"payId": "P15090809062501283950",
//"payment": "1",
//"payPrice": 0.12,
//"totalPrice": 0.12

@interface LHOrderPay : NSObject
@property (nonatomic, strong) NSString *payId;
@property (nonatomic, assign) CGFloat cash;
@property (nonatomic, assign) CGFloat payPrice;
@property (nonatomic, assign) CGFloat totalPrice;

@property (nonatomic, assign) LHPayWay payment;
@property (nonatomic, assign) CGFloat couponPrice;
@property (nonatomic, assign) CGFloat creditsPrice;

@end
