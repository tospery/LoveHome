//
//  LHMyBalanceTool.h
//  LoveHome-User-Clothes
//
//  Created by MRH-MAC on 15/7/31.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "BaseDataModel.h"
#define FromScheme @"LoveHomeUser"
#import "PayOnlineMentModel.h"
@interface LHMyWalletTool : BaseDataModel

typedef void (^BlanceListDetailBlock)(AFHTTPRequestOperation *operation, NSArray * blanceList);

/*!
 *  @brief  获取在线支付服务
 *
 *  @return
 */
+ (NSMutableArray *)getOnlinePayMent;

//
///*!
// *  @brief  获取UUID
// *
// *  @param money 充值金额
// *  @param type  充值类型
// */
//+ (void)sendInchargeMoney:(NSString *)money andPayTpey:(NSInteger)type andsuccessBlock:(JXHTTPRequestSuccessBlock)success andFail:(JXHTTPRequestFailureBlock)fail;
//
///*!
// *  @brief  查询电子钱包流水
// *
// *  @param success
// *  @param fail
// */
//+ (void)getUserWalletBlanceList:(BlanceListDetailBlock)success andFail:(JXHTTPRequestFailureBlock)fail;

@end
