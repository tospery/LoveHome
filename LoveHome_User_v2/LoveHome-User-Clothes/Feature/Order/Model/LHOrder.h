//
//  LHOrder.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/7.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHOrderPay.h"
#import "LHOrderProduct.h"


//{
//    "orderType": 1普通/2活动
//    "id": "O15091009470109238427",
//    "shopId": 67,
//    "status": 1,
//    "orderTime": null,
//    "appointTime": null,
//    "receiptTime": null,
//    "rejectTime": null,
//    "customerName": null,
//    "customerAddress": null,
//    "customerTelephone": null,
//    "remark": null,
//    "deleted": null,
//    "createTime": null,
//    "updateTime": null,
//    "servingRemark": null,
//    "cancelable": 0,
//    "shopName": "yjx洗衣店",
//    "orderPayDto": {
//        "orderId": null,
//        "payId": "P15091009470109275862",
//        "payment": null,
//        "payPrice": 0.02,
//        "creditsPrice": null,
//        "walletPrice": null,
//        "couponPrice": null,
//        "couponId": null,
//        "cardNo": null,
//        "totalPrice": 0.02
//    },
//    "orderDetailList": [
//                        {
//                            "id": null,
//                            "orderId": null,
//                            "productId": "94",
//                            "specPrice": 0.02,
//                            "specUnit": null,
//                            "specDiscount": null,
//                            "specName": null,
//                            "count": 1,
//                            "createTime": null,
//                            "productName": null,
//                            "description": null,
//                            "imageUrl": null
//                        }
//                        ],
//    "attitude": null,
//    "content": null
//}

@interface LHOrder : NSObject
@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, copy) NSString *activityName;
@property (nonatomic, copy) NSString *activityIcon;

@property (nonatomic, assign) NSInteger orderType;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, assign) BOOL cancelable;
@property (nonatomic, assign) NSInteger status; // 81用户取消；82商家拒绝
@property (nonatomic, strong) LHOrderPay *pay;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, assign) BOOL collectedByMerchant; // 商家是否已收衣

@property (nonatomic, strong) NSString *orderTime;
@property (nonatomic, strong) NSString *appointTime; // 预约时间
@property (nonatomic, strong) NSString *receiptTime;
@property (nonatomic, strong) NSString *rejectTime;
@property (nonatomic, strong) NSString *customerName;
@property (nonatomic, strong) NSString *customerTelephone;
@property (nonatomic, strong) NSString *customerAddress;
@property (nonatomic, strong) NSString *servingRemark;  // 拒绝理由

@property (nonatomic, strong) NSString *remark; // 留言内容

@property (nonatomic, assign) NSInteger cancelFlag; // 1,用户取消(未支付)   2,用户取消(已支付),3,爱为家管理员拒绝,4商家拒绝
@end






