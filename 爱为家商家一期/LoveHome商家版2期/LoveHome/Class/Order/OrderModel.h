//
//  OrderModel.h
//  LoveHome
//
//  Created by 杨建祥 on 15/8/27.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderPayModel.h"
#import "OrderDetailModel.h"

//{
//    "id": "O15082713575307808346",
//    "status": 1,
//    "appointTime": "2015-9-2 9:00~12:00",
//    "customerName": "csz",
//    "customerAddress": "富华南路",
//    "customerTelephone": "13418628307",
//    "orderPayDto": {
//        "payment": "1",
//        "totalPrice": 0.02
//    },
//    "orderDetailList": [
//                        {
//                            "specPrice": 0.02,
//                            "count": 1,
//                            "productName": "9.9洗衣",
//                            "imageUrl": "1131"
//                        }
//                        ]
//},


@interface OrderModel : NSObject
@property (nonatomic, assign) NSUInteger status;    // 不使用该字段
@property (nonatomic, assign) NSInteger attitude;  // 评论星级
@property (nonatomic, strong) NSString *orderid;
@property (nonatomic, strong) NSString *appointTime;
@property (nonatomic, strong) NSString *customerName;
@property (nonatomic,strong)  NSString *shopName;
@property (nonatomic, strong) NSString *customerAddress;
@property (nonatomic, strong) NSString *customerTelephone;
@property (nonatomic, strong) NSString *content;    // 评论内容
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *servingRemark;// 拒绝理由
@property (nonatomic,strong)  NSString *orderTime;
@property (nonatomic, strong) NSString *receiptTime;
@property (nonatomic, strong) NSString *rejectTime;
@property (nonatomic, strong) OrderPayModel *orderPayDto;
@property (nonatomic, strong) NSArray *orderDetailList;

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL collectedByMerchant;

@end
