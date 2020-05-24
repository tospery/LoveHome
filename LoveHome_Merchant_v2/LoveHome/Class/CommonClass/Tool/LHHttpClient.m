//
//  LHHttpClient.m
//  LoveHome
//
//  Created by MRH on 15/11/26.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import "LHHttpClient.h"
#import "StatistChartModel.h"
#import "RHCharMode.h"
#import "ShopStatisModel.h"
@implementation LHHttpClient

// 每日流量统计
+ (AFHTTPRequestOperation *)requestStatistiGetFlowListWithPage:(NSInteger)page
                                                       Success:(HttpServiceBasicSucessBackBlock)success fail:(HttpServiceBasicFailBackBlock)fail
{
    NSDictionary *params = @{@"page":@(page),@"rows":@10};
    
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"report/queryshopdayreport" andToken:YES andParameterDic:params andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:^(AFHTTPRequestOperation *operation, id responsObject) {
        if(success) {
            success(operation, responsObject);
        }
    } andFailedCallback:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(operation, error);
        }
    }];
    
    return operation;
}


// 商品统计
+ (AFHTTPRequestOperation *)requestStatistiGetCountWithDays:(NSInteger)days Success:(HttpServiceBasicSucessBackBlock)success
                                                       failure:(HttpServiceBasicFailBackBlock)failure {
    NSDictionary *dic = @{@"days":@(days)};;
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"merchantorder/productSalesReport" andToken:YES andParameterDic:dic andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:^(AFHTTPRequestOperation *operation, id responsObject) {
        if (success) {
            NSMutableArray *data  = [ShopStatisModel objectArrayWithKeyValuesArray:responsObject];
            for (int i = 0; i<data.count; i++) {
                ShopStatisModel *mode = data[i];
                mode.rankNu = i;
            }
            success(operation, data);
        }
    } andFailedCallback:failure];
    return operation;
}


/***访问数量***/
+ (AFHTTPRequestOperation *)requestStatistitGetVisitersCountSuccess:(HttpServiceBasicSucessBackBlock)success
                                                               fail:(HttpServiceBasicFailBackBlock)fail
{
#pragma mark - 不需要向服务器发送shopId了
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"report/getUserReportDtoList" andToken:YES andParameterDic:/*@{@"shopId":@232}*/nil andParameterType:kHttpRequestParameterType_None andSucceedCallback:^(AFHTTPRequestOperation *operation, id responsObject) {
        
        if (success) {
            //TODO 服务器返回格式太差.....
            NSMutableArray *dataSource = [[NSMutableArray alloc] init];
            for (NSArray *value in responsObject) {
                StatistChartModel *model = [[StatistChartModel alloc] init];
                model.cost = [value.lastObject floatValue];
                model.valueDate = value.firstObject;
                [dataSource addObject:model];
            }
#warning 数组倒序遍历!!!!()
            NSMutableArray *arry = [NSMutableArray arrayWithArray:[[dataSource /*objectEnumerator*/reverseObjectEnumerator] allObjects]];
            success(operation, arry);
        }
    } andFailedCallback:fail];
    return operation;
}


/******订单收入统计图表******/
+ (AFHTTPRequestOperation *)requestStatistiGetAroundIncomeListSuccess:(HttpServiceBasicSucessBackBlock)success fail:(HttpServiceBasicFailBackBlock)fail
{
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"wallet/getShopNearlydaysIncome" andToken:YES andParameterDic:nil andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:^(AFHTTPRequestOperation *operation, id responsObject) {
        if (success) {
            NSMutableArray *list = [[NSMutableArray alloc] init];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (NSDictionary * dic in responsObject) {
                    StatistChartModel *mode = [[StatistChartModel alloc] init];
                    mode.cost = [dic[@"cash"] floatValue];
                    mode.valueDate = dic[@"dealDate"];
                    [list addObject:mode];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(operation, list);
                });
            });
        }
    } andFailedCallback:fail];
    return operation;
}


/******订单各个状态数量统计******/
+ (AFHTTPRequestOperation *)requestStatistiGetOrderCountsSuccess:(HttpServiceBasicSucessBackBlock)success fail:(HttpServiceBasicFailBackBlock)fail
{
    NSDictionary *parameter = @{@"days":@90};
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"merchantorder/generalOrderReport" andToken:YES andParameterDic:parameter andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:^(AFHTTPRequestOperation *operation, id responsObject) {
        
        if (success) {
            success(operation, responsObject);
        }
    } andFailedCallback:fail];
    return operation;
}
/**
 *  专门为订单统计里面的两个订单数量写的
 *
 *  @param days    7,30,90
 *  @param success 成功
 *  @param fail    失败
 *
 *  @return opreation
 */
+(AFHTTPRequestOperation *)requestStatisticalNumbersWith:(NSInteger)days Success:(HttpServiceBasicSucessBackBlock)success fail:(HttpServiceBasicFailBackBlock)fail
{
    NSDictionary *dic = @{@"days":@(days)};;
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"merchantorder/generalOrderReport" andToken:YES andParameterDic:dic andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:^(AFHTTPRequestOperation *operation, id responsObject) {
        
        if (success) {
            success(operation, responsObject);
        }
    } andFailedCallback:fail];
    return operation;

}
/**
 *  获取活动数量的请求
 *
 *  @param url     url
 *  @param success success
 *  @param fail    fail
 *
 *  @return operation
 */
+ (AFHTTPRequestOperation *)getActivityCountSuccess:(HttpServiceBasicSucessBackBlock)success fail:(HttpServiceBasicFailBackBlock)fail
{
   AFHTTPRequestOperation *operation = [HttpServiceManageObject sendGetRequestWithPathUrl:@"activity/queryActByShop" andToken:YES  andParaDic:nil andSucceedCallback:^(AFHTTPRequestOperation *operation, id responsObject) {
       if (success) {
           success(operation, responsObject);
       }
       
   } andFailedCallback:^(AFHTTPRequestOperation *operation, NSError *error) {
       
       NSLog(@"fail11111");
   }];
    return operation;
}
/******活动订单数量统计图表******/
+ (AFHTTPRequestOperation *)requestStatistiGetActivitOrderrCountsWithDays:(NSInteger)days andActivityId:(NSInteger)activityId Success:(HttpServiceBasicSucessBackBlock)success fail:(HttpServiceBasicFailBackBlock)fail

{    NSDictionary *parameter = @{@"days":@(days), @"activityId":@(activityId)};
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"merchantorder/activityOrderReport" andToken:YES andParameterDic:parameter andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:^(AFHTTPRequestOperation *operation, id responsObject) {
        
        if (success) {
            success(operation, responsObject);
        }
    } andFailedCallback:fail];
    return operation;
}
/******活动订单数量 数字统计******/
+ (AFHTTPRequestOperation *)requestActivtyCountsWithDays:(NSInteger)currentDays andActivityId:(NSInteger)activityId Success:(HttpServiceBasicSucessBackBlock)success fail:(HttpServiceBasicFailBackBlock)fail

{    NSDictionary *parameter = @{@"days":@(currentDays), @"activityId":@(activityId)};
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"merchantorder/activityOrderReport" andToken:YES andParameterDic:parameter andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:^(AFHTTPRequestOperation *operation, id responsObject) {
        
        if (success) {
            success(operation, responsObject);
        }
    } andFailedCallback:fail];
    return operation;
}


@end
