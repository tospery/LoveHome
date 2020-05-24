//
//  LHHttpClient.h
//  LoveHome
//
//  Created by MRH on 15/11/26.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHHttpClient : NSObject


#pragma mark - 统计模块
/***每日流量统计***/
+ (AFHTTPRequestOperation *)requestStatistiGetFlowListWithPage:(NSInteger)page
                                                       Success:(HttpServiceBasicSucessBackBlock)success fail:(HttpServiceBasicFailBackBlock)fail;
/***商品统计****/
+ (AFHTTPRequestOperation *)requestStatistiGetCountWithDays:(NSInteger)days Success:(HttpServiceBasicSucessBackBlock)success
                                                    failure:(HttpServiceBasicFailBackBlock)failure;
/***访问数量***/
+ (AFHTTPRequestOperation *)requestStatistitGetVisitersCountSuccess:(HttpServiceBasicSucessBackBlock)success
                                                 fail:(HttpServiceBasicFailBackBlock)fail;


#pragma mark 订单收入
/******订单收入统计图表******/
+ (AFHTTPRequestOperation *)requestStatistiGetAroundIncomeListSuccess:(HttpServiceBasicSucessBackBlock)success
                                                         fail:(HttpServiceBasicFailBackBlock)fail;


/******订单各个状态数量统计******/
+ (AFHTTPRequestOperation *)requestStatistiGetOrderCountsSuccess:(HttpServiceBasicSucessBackBlock)success
                                                 fail:(HttpServiceBasicFailBackBlock)fail;

/***********特意为了 订单统计里面两个状态的订单写的********/
+ (AFHTTPRequestOperation *)requestStatisticalNumbersWith:(NSInteger)days Success:(HttpServiceBasicSucessBackBlock)success
                                                            fail:(HttpServiceBasicFailBackBlock)fail;

/******活动订单数量统计图表******/
+ (AFHTTPRequestOperation *)requestStatistiGetActivitOrderrCountsWithDays:(NSInteger)days andActivityId:(NSInteger)activityId Success:(HttpServiceBasicSucessBackBlock)success fail:(HttpServiceBasicFailBackBlock)fail;

/****** 活动订单 activityID ******/
+ (AFHTTPRequestOperation *)getActivityCountSuccess:(HttpServiceBasicSucessBackBlock)success fail:(HttpServiceBasicFailBackBlock)fail;

/******活动订单数量 数字统计******/
+ (AFHTTPRequestOperation *)requestActivtyCountsWithDays:(NSInteger)currentDays andActivityId:(NSInteger)activityId Success:(HttpServiceBasicSucessBackBlock)success fail:(HttpServiceBasicFailBackBlock)fail;


@end
