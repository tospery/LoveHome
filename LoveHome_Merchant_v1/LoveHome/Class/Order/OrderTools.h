//
//  OrderTools.h
//  LoveHome
//
//  Created by 杨建祥 on 15/8/27.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "BaseDataModel.h"
#import "OrderCollectionModel.h"
#import "OrderModel.h"
#import "OrderCount.h"

@class AFHTTPRequestOperation;

typedef NS_ENUM(NSInteger, OrderType){
    OrderTypeNone,
    OrderTypeAdded,         // 新增
    OrderTypeUnhandled,     // 未响应
    OrderTypeRectClothes,   // 去收衣
    OrderTypehandled,       // 已受理
    OrderTypeFinished,      // 已完成
    OrderTypeRejected,      // 已拒绝
    OrderTypeAll
};

@interface OrderTools : BaseDataModel
singleton_interface(OrderTools)

- (NSString *)orderNameWithType:(OrderType)type;

- (NSArray *)fetchOrdersWithType:(OrderType)type;
- (void)storeOrders:(NSArray *)orders type:(OrderType)type;


- (OrderCount *)fetchOrderCount;
- (void)storeOrderCount:(OrderCount *)ordercount;

/**
 *  获取订单列表
 *
 *  @param type    订单类型
 *  @param page    当前分页，从1开始
 *  @param size    分页大小，固定为10
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return 操作
 */
+ (AFHTTPRequestOperation *)getListWithType:(OrderType)type
                                       page:(NSUInteger)page
                                       size:(NSUInteger)size
                                    success:(HttpServiceBasicSucessBackBlock)success
                                    failure:(HttpServiceBasicFailBackBlock)failure;

/**
 *  接单
 *
 *  @param orderid 订单号
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return 操作
 */
+ (AFHTTPRequestOperation *)acceptWithOrderid:(NSString *)orderid
                                      success:(HttpServiceBasicSucessBackBlock)success
                                      failure:(HttpServiceBasicFailBackBlock)failure;

/**
 *  批量接单
 *
 *  @param orderids 订单号集合
 *  @param success  成功
 *  @param failure  失败
 *
 *  @return 操作
 */
+ (AFHTTPRequestOperation *)acceptWithOrderids:(NSArray *)orderids
                                       success:(HttpServiceBasicSucessBackBlock)success
                                       failure:(HttpServiceBasicFailBackBlock)failure;

/**
 *  拒单
 *
 *  @param orderid 订单号
 *  @param reason  拒绝理由
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return 操作
 */
+ (AFHTTPRequestOperation *)rejectWithOrderid:(NSString *)orderid
                                       reason:(NSString *)reason
                                      success:(HttpServiceBasicSucessBackBlock)success
                                      failure:(HttpServiceBasicFailBackBlock)failure;

/**
 *  获取订单详情
 *
 *  @param orderid 订单号
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return 操作
 */
+ (AFHTTPRequestOperation *)getDetailWithOrderid:(NSString *)orderid
                                         success:(HttpServiceBasicSucessBackBlock)success
                                         failure:(HttpServiceBasicFailBackBlock)failure;


/**
 *  查询各种订单的总数
 *
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return 操作
 */
+ (AFHTTPRequestOperation *)getCountWithSuccess:(HttpServiceBasicSucessBackBlock)success
                                         failure:(HttpServiceBasicFailBackBlock)failure;




/*!
 *  @brief  拒绝收衣
 *
 *  @param orderid
 *  @param reason
 *  @param success
 *  @param failure
 *
 *  @return 
 */
+ (AFHTTPRequestOperation *)rejectClothesWithOrderid:(NSString *)orderid
                                              reason:(NSString *)reason
                                             success:(HttpServiceBasicSucessBackBlock)success
                                             failure:(HttpServiceBasicFailBackBlock)failure;


/*!
 *  @brief  确认收衣(去收衣的)
 *
 *  @param orderid 订单id
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return
 */
+ (AFHTTPRequestOperation *)confirmOrderClothes:(NSString *)orderid
                                        success:(HttpServiceBasicSucessBackBlock)success
                                        failure:(HttpServiceBasicFailBackBlock)failure;




/*!
 *  @brief  确认收衣(未响应的)
 *
 *  @param orderid 订单id
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return
 */
+ (AFHTTPRequestOperation *)confirmOrderClothesWithWating:(NSString *)orderid
                                        success:(HttpServiceBasicSucessBackBlock)success
                                        failure:(HttpServiceBasicFailBackBlock)failure;



@end
