//
//  LHHTTPClient.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/16.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHResponseBase.h"
#import "LHResponseCollection.h"
#import "LHActivity.h"
#import "LHReceipt.h"
#import "LHFavorite.h"
#import "LHBalance.h"
#import "LHShopBusiness.h"
#import "LHOrderSubmit.h"
#import "LHOrderPay.h"
#import "LHShop.h"
#import "LHComment.h"
#import "LHBasicData.h"
#import "LHLovebeanSign.h"

@interface LHHTTPClient : NSObject
#pragma mark - Web APIs
#pragma mark - 个人
#pragma mark 用户反馈
+ (AFHTTPRequestOperation *)requestCheckUserJionActCountWithActId:(NSString *)actId
                                                        productId:(NSString *)productId
                                               success:(LHHTTPRequestSuccessBlock)success
                                               failure:(LHHTTPRequestFailureBlock)failure;

+ (AFHTTPRequestOperation *)requestFeedbackWithContent:(NSString *)content
                                               success:(LHHTTPRequestSuccessBlock)success
                                               failure:(LHHTTPRequestFailureBlock)failure;
#pragma mark 收藏-店铺-检查
+ (AFHTTPRequestOperation *)requestFavoriteCheckWithShopid:(NSString *)shopid
                                                   success:(LHHTTPRequestSuccessBlock)success
                                                   failure:(LHHTTPRequestFailureBlock)failure;
#pragma mark 收藏-店铺-删除-根据收藏ID
+ (AFHTTPRequestOperation *)requestFavoriteDeleteWithFavoriteId:(NSString *)favoriteId
                                                        success:(LHHTTPRequestSuccessBlock)success
                                                        failure:(LHHTTPRequestFailureBlock)failure;
#pragma mark 收藏-店铺-删除-根据店铺ID
+ (AFHTTPRequestOperation *)requestFavoriteDeleteWithShopid:(NSString *)shopid
                                                    success:(LHHTTPRequestSuccessBlock)success
                                                    failure:(LHHTTPRequestFailureBlock)failure;
#pragma mark 退出登录
+ (AFHTTPRequestOperation *)requestExitWithSuccess:(LHHTTPRequestSuccessBlock)success
                                           failure:(LHHTTPRequestFailureBlock)failure;


#pragma mark - 活动
#pragma mark 获取参与活动的店铺列表
+ (AFHTTPRequestOperation *)requestGetActivityShopsWithActivityid:(NSString *)activityid
                                                    baseProductId:(NSString *)baseProductId
                                                              lng:(CGFloat)lng
                                                              lat:(CGFloat)lat
                                                            range:(CGFloat)range
                                                             sort:(NSInteger)sort
                                                             page:(NSInteger)page
                                                             rows:(NSInteger)rows
                                                          success:(LHHTTPRequestSuccessBlock)success
                                                          failure:(LHHTTPRequestFailureBlock)failure;

#pragma mark 分享得爱豆
+ (AFHTTPRequestOperation *)requestGetLovebeanWhenSharedWithTaskid:(NSInteger)taskid
                                                           success:(LHHTTPRequestSuccessBlock)success
                                                           failure:(LHHTTPRequestFailureBlock)failure;

// 待整理
+ (AFHTTPRequestOperation *)queryShopCommentsWithShopId:(NSUInteger)shopId
                                                   page:(NSUInteger)page
                                                   rows:(NSUInteger)rows
                                                success:(LHHTTPRequestSuccessBlock)success
                                                failure:(LHHTTPRequestFailureBlock)failure;

+ (AFHTTPRequestOperation *)postPushCodeWithCode:(NSString *)code
                                         success:(LHHTTPRequestSuccessBlock)success
                                         failure:(LHHTTPRequestFailureBlock)failure;

+ (AFHTTPRequestOperation *)signinWithPhone:(NSString *)phone
                                       code:(NSString *)code
                                    success:(LHHTTPRequestSuccessBlock)success
                                    failure:(LHHTTPRequestFailureBlock)failure;

+ (AFHTTPRequestOperation *)loginWithPhone:(NSString *)phone
                                      code:(NSString *)code
                                    device:(NSString *)device
                                   success:(LHHTTPRequestSuccessBlock)success
                                   failure:(LHHTTPRequestFailureBlock)failure;
#pragma mark general
// 获取短信验证码
+ (AFHTTPRequestOperation *)getcodeWithPhone:(NSString *)phone
                                     success:(LHHTTPRequestSuccessBlock)success
                                     failure:(LHHTTPRequestFailureBlock)failure;

#pragma mark account
// 验证手机号码
+ (AFHTTPRequestOperation *)validateMobileWithCode:(NSString *)code
                                             phone:(NSString *)phone
                                           success:(LHHTTPRequestSuccessBlock)success
                                           failure:(LHHTTPRequestFailureBlock)failure;

// 修改手机号码
+ (AFHTTPRequestOperation *)modifyMobileWithPhonenumber:(NSString *)phonenumber
                                                   code:(NSString *)code
                                                success:(LHHTTPRequestSuccessBlock)success
                                                failure:(LHHTTPRequestFailureBlock)failure;

#pragma mark favorite
// 用户收藏的所有店铺
+ (AFHTTPRequestOperation *)getFavoritesWithLatitude:(double)latitude
                                           longitude:(double)longitude
                                             success:(LHHTTPRequestSuccessBlock)success
                                             failure:(LHHTTPRequestFailureBlock)failure;

+ (AFHTTPRequestOperation *)requestFavoriteShopWithUid:(NSInteger)uid
                                               success:(LHHTTPRequestSuccessBlock)success
                                               failure:(LHHTTPRequestFailureBlock)failure;

#pragma mark wallet
// 设置支付密码
+ (AFHTTPRequestOperation *)setPayword:(NSString *)password
                               success:(LHHTTPRequestSuccessBlock)success
                               failure:(LHHTTPRequestFailureBlock)failure;

// 获取账户流水
+ (AFHTTPRequestOperation *)getBalanceFlowsWithPage:(NSUInteger)page
                                               size:(NSUInteger)size
                                            success:(LHHTTPRequestSuccessBlock)success
                                            failure:(LHHTTPRequestFailureBlock)failure;

// 获取账户余额
+ (AFHTTPRequestOperation *)getBalanceWithSuccess:(LHHTTPRequestSuccessBlock)success
                                          failure:(LHHTTPRequestFailureBlock)failure;



/**
 *  获取推送消息
 *
 *  @param type    1系统消息；2订单消息
 *  @param page    分页
 *  @param rows    条目
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return 操作
 */
+ (AFHTTPRequestOperation *)getMessagesWithType:(NSInteger)type
                                           page:(NSUInteger)page
                                           rows:(NSUInteger)rows
                                        success:(LHHTTPRequestSuccessBlock)success
                                        failure:(LHHTTPRequestFailureBlock)failure;

/**
 *  获取活动列表
 *
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return 操作
 */
+ (AFHTTPRequestOperation *)getActivitiesWithSuccess:(LHHTTPRequestSuccessBlock)success
                                             failure:(LHHTTPRequestFailureBlock)failure
                                          retryTimes:(NSUInteger)retryTimes;

// 获取用户信息
+ (AFHTTPRequestOperation *)getUserinfoWithSuccess:(LHHTTPRequestSuccessBlock)success
                                           failure:(LHHTTPRequestFailureBlock)failure
                                        retryTimes:(NSUInteger)retryTimes ;

// 上传图片
+ (NSURLSessionUploadTask *)uploadWithImage:(UIImage *)image
                                    success:(JXHTTPTaskSuccessBlock)success
                                    failure:(JXHTTPTaskFailureBlock)failure
                                   progress:(LHHTTPProgressBlock)progress;

// 修改昵称
+ (AFHTTPRequestOperation *)modifyNickname:(NSString *)nickname
                                   success:(LHHTTPRequestSuccessBlock)success
                                   failure:(LHHTTPRequestFailureBlock)failure;

// 收货地址
+ (AFHTTPRequestOperation *)getReceiptsWithSuccess:(LHHTTPRequestSuccessBlock)success
                                            failure:(LHHTTPRequestFailureBlock)failure;

// 删除收货地址
+ (AFHTTPRequestOperation *)delReceiptWithUid:(NSInteger)uid
                                      success:(LHHTTPRequestSuccessBlock)success
                                      failure:(LHHTTPRequestFailureBlock)failure;
// 更新收货地址
+ (AFHTTPRequestOperation *)updateReceipt:(LHReceipt *)receipt
                                  success:(LHHTTPRequestSuccessBlock)success
                                  failure:(LHHTTPRequestFailureBlock)failure;

// 添加收货地址
+ (AFHTTPRequestOperation *)addReceipt:(LHReceipt *)receipt
                               success:(LHHTTPRequestSuccessBlock)success
                               failure:(LHHTTPRequestFailureBlock)failure;

// 设置默认收货地址
+ (AFHTTPRequestOperation *)setDefaultReceiptWithUid:(NSNumber *)uid
                                             success:(LHHTTPRequestSuccessBlock)success
                                             failure:(LHHTTPRequestFailureBlock)failure;

// 获取爱豆流水
+ (AFHTTPRequestOperation *)getLovebeanFlowsWithPage:(NSInteger)page
                                                size:(NSInteger)size
                                             success:(LHHTTPRequestSuccessBlock)success
                                             failure:(LHHTTPRequestFailureBlock)failure;

+ (AFHTTPRequestOperation *)getLovebeanSignWithSuccess:(LHHTTPRequestSuccessBlock)success
                                               failure:(LHHTTPRequestFailureBlock)failure;
#pragma mark 测试
+ (AFHTTPRequestOperation *)getMordersWithPage:(NSInteger)page
                                          size:(NSInteger)size
                                       isError:(BOOL)isError
                                       success:(LHHTTPRequestSuccessBlock)success
                                       failure:(LHHTTPRequestFailureBlock)failure;

#pragma mark - 充值/支付
+ (AFHTTPRequestOperation *)rechargeWithMoney:(CGFloat)money
                                          way:(NSInteger)way
                                      success:(LHHTTPRequestSuccessBlock)success
                                      failure:(LHHTTPRequestFailureBlock)failure;

#pragma mark - 优惠券
+ (AFHTTPRequestOperation *)requestGetCouponsWithShopids:(NSArray *)shopids
                                                 success:(LHHTTPRequestSuccessBlock)success
                                                 failure:(LHHTTPRequestFailureBlock)failure;

+ (AFHTTPRequestOperation *)requestGetBasicDataForOrderConfirmWithSuccess:(LHHTTPRequestSuccessBlock)success
                                                                  failure:(LHHTTPRequestFailureBlock)failure;

+ (AFHTTPRequestOperation *)requestGetUsableCouponCountWithShopids:(NSArray *)shopids
                                                           success:(LHHTTPRequestSuccessBlock)success
                                                           failure:(LHHTTPRequestFailureBlock)failure;

+ (AFHTTPRequestOperation *)getMyCouponsWithSuccess:(LHHTTPRequestSuccessBlock)success
                                            failure:(LHHTTPRequestFailureBlock)failure;

+ (AFHTTPRequestOperation *)getSuppliedCouponsWithSuccess:(LHHTTPRequestSuccessBlock)success
                                                  failure:(LHHTTPRequestFailureBlock)failure;

+ (AFHTTPRequestOperation *)receiveCounponWithCounponid:(NSString *)couponid
                                                success:(LHHTTPRequestSuccessBlock)success
                                                failure:(LHHTTPRequestFailureBlock)failure;

#pragma mark - 店铺/商品
+ (AFHTTPRequestOperation *)getProductsWithShopid:(NSInteger)shopid
                                          success:(LHHTTPRequestSuccessBlock)success
                                          failure:(LHHTTPRequestFailureBlock)failure;


#pragma mark - 订单
+ (AFHTTPRequestOperation *)requestSubmitOrderWithModel:(LHOrderSubmit *)model
                                                success:(LHHTTPRequestSuccessBlock)success
                                                failure:(LHHTTPRequestFailureBlock)failure;

+ (AFHTTPRequestOperation *)requestNewPayidWithOrderid:(NSString *)orderid
                                               success:(LHHTTPRequestSuccessBlock)success
                                               failure:(LHHTTPRequestFailureBlock)failure;

#pragma mark 收货
+ (AFHTTPRequestOperation *)requestReceiveWithOrderid:(NSString *)orderid
                                              success:(LHHTTPRequestSuccessBlock)success
                                              failure:(LHHTTPRequestFailureBlock)failure;

#pragma mark 确认取件
+ (AFHTTPRequestOperation *)requestConfirmCollectedWithOrderid:(NSString *)orderid
                                                       success:(LHHTTPRequestSuccessBlock)success
                                                       failure:(LHHTTPRequestFailureBlock)failure;

#pragma mark 获取默认的收货地址
+ (AFHTTPRequestOperation *)requestGetDefaultReceiptWithSuccess:(LHHTTPRequestSuccessBlock)success
                                                        failure:(LHHTTPRequestFailureBlock)failure;

#pragma mark 根据ID获取店铺详情
+ (AFHTTPRequestOperation *)getShopWithShopid:(NSInteger)shopid
                                      success:(LHHTTPRequestSuccessBlock)success
                                      failure:(LHHTTPRequestFailureBlock)failure;

#pragma mark 查询店铺列表
+ (AFHTTPRequestOperation *)queryShopsWithLatitude:(CGFloat)latitude
                                         longitude:(CGFloat)longitude
                                              type:(NSUInteger)type
                                          distance:(CGFloat)distance
                                              sort:(NSUInteger)sort
                                             index:(NSInteger)index
                                              size:(NSInteger)size
                                           success:(LHHTTPRequestSuccessBlock)success
                                           failure:(LHHTTPRequestFailureBlock)failure;

+ (AFHTTPRequestOperation *)searchShopsWithName:(NSString *)name
                                        success:(LHHTTPRequestSuccessBlock)success
                                        failure:(LHHTTPRequestFailureBlock)failure;

+ (AFHTTPRequestOperation *)searchShopsWithLatitude:(CGFloat)latitude
                                          longitude:(CGFloat)longitude
                                               name:(NSString *)name
                                           distance:(CGFloat)distance
                                               sort:(NSUInteger)sort
                                              index:(NSInteger)index
                                               size:(NSInteger)size
                                            success:(LHHTTPRequestSuccessBlock)success
                                            failure:(LHHTTPRequestFailureBlock)failure;

#pragma mark 查询订单详情
+ (AFHTTPRequestOperation *)requestGetOrderDetailWithOrderid:(NSString *)orderid
                                                     success:(LHHTTPRequestSuccessBlock)success
                                                     failure:(LHHTTPRequestFailureBlock)failure;

#pragma mark 取消订单(已支付)
+ (AFHTTPRequestOperation *)requestCancelPayedOrderWithOrderid:(NSString *)orderId
                                                       success:(LHHTTPRequestSuccessBlock)success
                                                       failure:(LHHTTPRequestFailureBlock)failure;

#pragma mark 取消订单(收衣中)
+ (AFHTTPRequestOperation *)requestCancelCollectingOrderWithOrderid:(NSString *)orderId
                                                            success:(LHHTTPRequestSuccessBlock)success
                                                            failure:(LHHTTPRequestFailureBlock)failure;

#pragma mark 获取用户订单
+ (AFHTTPRequestOperation *)requestGetUserOrdersWithType:(LHOrderRequestType)type
                                                    page:(NSInteger)page
                                                    size:(NSInteger)size
                                                 success:(LHHTTPRequestSuccessBlock)success
                                                 failure:(LHHTTPRequestFailureBlock)failure;

#pragma mark 取消订单(未支付)
+ (AFHTTPRequestOperation *)requestCancelNopayedOrderWithOrderid:(NSString *)orderId
                                                         success:(LHHTTPRequestSuccessBlock)success
                                                         failure:(LHHTTPRequestFailureBlock)failure;

#pragma mark 点评店铺
+ (AFHTTPRequestOperation *)requestCommentShopWithContent:(NSString *)content
                                                   shopId:(NSString *)shopId
                                                  orderId:(NSString *)orderId
                                            descriptLevel:(NSInteger)descriptLevel
                                             serviceLevel:(NSInteger)serviceLevel
                                               speedLevel:(NSInteger)speedLevel
                                                  success:(LHHTTPRequestSuccessBlock)success
                                                  failure:(LHHTTPRequestFailureBlock)failure;

#pragma mark - 支付
+ (AFHTTPRequestOperation *)requestVerifyPayword:(NSString *)payword
                                         success:(LHHTTPRequestSuccessBlock)success
                                         failure:(LHHTTPRequestFailureBlock)failure;

#pragma mark 删除订单
+ (AFHTTPRequestOperation *)requestDeleteOrderWithOrderid:(NSString *)orderId
                                                  success:(LHHTTPRequestSuccessBlock)success
                                                  failure:(LHHTTPRequestFailureBlock)failure;

+ (AFHTTPRequestOperation *)requestPayWithWay:(LHOnlinePayWay)way
                                        payId:(NSString *)payId
                                         cash:(CGFloat)cash
                                      success:(LHHTTPRequestSuccessBlock)success
                                      failure:(LHHTTPRequestFailureBlock)failure;

#pragma mark - HTTP methods
+ (AFHTTPRequestOperation *)sendBaseRequestWithPathString:(NSString *)pathString
                                               methodType:(JXHTTPMethodType)methodType
                                                paramType:(JXHTTPParamType)paramType
                                                   params:(id)params
                                                needToken:(BOOL)needToken
                                             checkNetwork:(BOOL)checkNetwork
                                               retryTimes:(NSUInteger)retryTimes
                                                  success:(LHHTTPRequestSuccessBlock)success
                                                  failure:(LHHTTPRequestFailureBlock)failure;

+ (AFHTTPRequestOperation *)sendGetRequestWithPathString:(NSString *)pathString
                                                 tokened:(BOOL)tokened
                                                  params:(id)params
                                                 success:(LHHTTPRequestSuccessBlock)success
                                                 failure:(LHHTTPRequestFailureBlock)failure;

+ (AFHTTPRequestOperation *)sendPostRequestWithPathString:(NSString *)pathString
                                                  tokened:(BOOL)tokened
                                                   params:(id)params
                                                paramType:(JXHTTPParamType)paramType
                                                  success:(LHHTTPRequestSuccessBlock)success
                                                  failure:(LHHTTPRequestFailureBlock)failure;

+ (NSURLSessionUploadTask *)sendUploadTaskWithPathString:(NSString *)pathString
                                                 tokened:(BOOL)tokened
                                                  params:(id)params
                                                   files:(NSArray *)files
                                                 success:(LHHTTPTaskSuccessBlock)success
                                                 failure:(LHHTTPTaskFailureBlock)failure
                                                progress:(LHHTTPProgressBlock)progress;
@end
