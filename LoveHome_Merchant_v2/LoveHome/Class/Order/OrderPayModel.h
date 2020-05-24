//
//  OrderPayModel.h
//  LoveHome
//
//  Created by 杨建祥 on 15/8/27.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>

//    "orderPayDto": {
//        "payment": "1",
//        "totalPrice": 0.02
//    },

@interface OrderPayModel : NSObject
@property (nonatomic, assign) NSUInteger payment;
// 总价
@property (nonatomic, assign) CGFloat totalPrice;
// 实际支付
@property (nonatomic, assign) CGFloat payPrice;
@property (nonatomic, assign) CGFloat couponPrice;
// 爱豆
@property (nonatomic, assign) CGFloat creditsPrice;






@end
