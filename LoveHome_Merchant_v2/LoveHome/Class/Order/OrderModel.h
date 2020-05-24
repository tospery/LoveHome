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
//11 新增没相应  2 新增  12 收衣服 未响应
@property (nonatomic, assign) NSUInteger status;    // 不使用该字段
@property (nonatomic, assign) NSInteger attitude;  // 评论星级
//订单号
@property (nonatomic, strong) NSString *orderid;
//预约提货时间
@property (nonatomic, strong) NSString *appointTime;
//客户姓名
@property (nonatomic, strong) NSString *customerName;
//店名
@property (nonatomic, strong) NSString *shopName;
//收货地址
@property (nonatomic, strong) NSString *customerAddress;
//电话号码
@property (nonatomic, strong) NSString *customerTelephone;
// 评论内容
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *remark;
// 拒绝理由
@property (nonatomic, strong) NSString *servingRemark;

@property (nonatomic, strong) NSString *orderTime;
@property (nonatomic, strong) NSString *receiptTime;
@property (nonatomic, strong) NSString *rejectTime;
@property (nonatomic, strong) OrderPayModel *orderPayDto;
@property (nonatomic, strong) NSArray *orderDetailList;

@property (nonatomic, assign) BOOL selected;

#pragma mark - 新修改的订单状态
// 0 为默认状态 1 为商家点击了确认按钮 2 为客户点击了确认按钮
@property (nonatomic, assign) NSInteger collectedByMerchant;
//0 为不允许 1 为允许
@property (nonatomic, assign) NSInteger cancelable;
// 1为普通订单 2 为活动订单
@property (nonatomic, assign) NSInteger orderType;

//新增 活动商品字段 -- 活动名

@property (nonatomic, strong) NSString *activityName;

//新增 活动图标 

@property (nonatomic, strong) NSString *activityIcon;

@end
