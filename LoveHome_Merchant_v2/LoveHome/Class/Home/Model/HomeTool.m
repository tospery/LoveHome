//
//  HomeTool.m
//  LoveHome
//
//  Created by MRH-MAC on 15/8/28.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "HomeTool.h"
#import "IncomModel.h"
@implementation HomeTool

/*!
 *  @brief  查询近7天收入
 *
 *  @param suceess
 *  @param fail
 *
 *  @return 
 */
+(AFHTTPRequestOperation *)sendSelctWalletetShopNearly7daysIncome:(HttpServiceBasicSucessBackBlock)suceess andFail:(HttpServiceBasicFailBackBlock)fail
{
    AFHTTPRequestOperation *opration = [HttpServiceManageObject sendPostRequestWithPathUrl:@"wallet/getShopNearly7daysIncome" andToken:YES andParameterDic:nil andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:suceess andFailedCallback:fail];
    
    return opration;
}


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
+(AFHTTPRequestOperation *)sendSelectDetailListStarDate:(NSString *)date endDate:(NSString *)endDate  currentPage:(NSInteger)page paSize:(NSInteger)size andsuceess:(HttpServiceBasicSucessBackBlock)suceess andFail:(HttpServiceBasicFailBackBlock)fail
{
    
    
    NSMutableDictionary *parmete = [[NSMutableDictionary alloc] init];
    [parmete setObject:date forKey:@"startDate"];
    [parmete setObject:endDate forKey:@"endDate"];
    [parmete setObject:@(page) forKey:@"currentPage"];
    [parmete setObject:@(size) forKey:@"pageSize"];
      AFHTTPRequestOperation *opration = [HttpServiceManageObject sendPostRequestWithPathUrl:@"wallet/getPageWalletFlow" andToken:YES andParameterDic:parmete andParameterType:kHttpRequestParameterType_JSON andSucceedCallback:suceess andFailedCallback:fail];
    return opration;
}



// 日期查询
+(AFHTTPRequestOperation *)sendWalletGetShopWalletMonthStarMoth:(NSString *)starMoth endMoth:(NSString *)endMoth andSuceess:(HttpServiceBasicSucessBackBlock)suceess andFail:(HttpServiceBasicFailBackBlock)fail
{
    NSDictionary *dic = @{@"startDate": starMoth,@"endDate":endMoth};
    AFHTTPRequestOperation *opration = [HttpServiceManageObject sendPostRequestWithPathUrl:@"wallet/getShopWalletMonth" andToken:YES andParameterDic:dic andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:^(AFHTTPRequestOperation *operation, id responsObject)
    {
        NSMutableArray *arry = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in responsObject) {
            IncomModel *model = [[IncomModel alloc] init];
            [model setKeyValues:dic];
            [arry addObject:model];
        }
        
        [arry sortUsingComparator:^NSComparisonResult(IncomModel *part1,IncomModel *part2) {
    
            if ([part1.startDate floatValue] > [part2.startDate floatValue]) {
            
                return NSOrderedDescending;
            }
       
            return NSOrderedAscending;
        }];
        
        suceess(operation,arry);
        
        
    }andFailedCallback:fail];
    return opration;
}

@end
