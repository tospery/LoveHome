//
//  HomeTool.h
//  LoveHome
//
//  Created by MRH-MAC on 15/8/28.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "BaseDataModel.h"

@interface HomeTool : BaseDataModel


/*!
 *  @brief  查询近7天收入
 *
 *  @param suceess
 *  @param fail
 *
 *  @return 
 */
+(AFHTTPRequestOperation *)sendSelctWalletetShopNearly7daysIncome:(HttpServiceBasicSucessBackBlock)suceess andFail:(HttpServiceBasicFailBackBlock)fail;


/*!
 *  @brief  获取收入详情列表
 *
 *  @param date    开始时间
 *  @param endDate 结束时间
 *  @param page    第几页
 *  @param size    每页大小
 *  @param suceess 成功回调
 *  @param fail    失败回调
 *
 *  @return
 */
+(AFHTTPRequestOperation *)sendSelectDetailListStarDate:(NSString *)date endDate:(NSString *)endDate  currentPage:(NSInteger)page paSize:(NSInteger)size andsuceess:(HttpServiceBasicSucessBackBlock)suceess andFail:(HttpServiceBasicFailBackBlock)fail;



+(AFHTTPRequestOperation *)sendWalletGetShopWalletMonthStarMoth:(NSString *)starMoth endMoth:(NSString *)endMoth andSuceess:(HttpServiceBasicSucessBackBlock)suceess andFail:(HttpServiceBasicFailBackBlock)fail;
@end
