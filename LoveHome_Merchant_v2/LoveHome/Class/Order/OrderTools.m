//
//  OrderTools.m
//  LoveHome
//
//  Created by 杨建祥 on 15/8/27.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "OrderTools.h"

@implementation OrderTools
singleton_implementation(OrderTools)

#pragma mark - 订单状态
- (NSString *)orderNameWithType:(OrderType)type
{
    NSString *typeName;
    switch (type) {
        case OrderTypeAdded:
            typeName = @"新增订单";
            
            break;
        case OrderTypeFinished:
            typeName = @"已完成";
            
            break;
            
        case OrderTypehandled:
            typeName = @"服务中";
            
            break;
        case OrderTypeRejected:
            typeName = @"已取消";
        default:
            break;
    }
    return typeName;
}
/*
 * @brief 根据路径取出订单个数
 */
- (OrderCount *)fetchOrderCount {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[OrderTools getLocalOrdercountPath]];
}

- (void)storeOrderCount:(OrderCount *)ordercount {
    [NSKeyedArchiver archiveRootObject:ordercount toFile:[OrderTools getLocalOrdercountPath]];
}
                            
//获取订单
- (NSArray *)fetchOrdersWithType:(OrderType)type {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[OrderTools getLocalOrdersPathWithType:type]];
}

- (void)storeOrders:(NSArray *)orders type:(OrderType)type {
    [NSKeyedArchiver archiveRootObject:orders toFile:[OrderTools getLocalOrdersPathWithType:type]];
}

+ (NSString *)getLocalOrdersPathWithType:(OrderType)type {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"orders#%ld.data", (long)type]];
}

+ (NSString *)getLocalOrdercountPath {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"orders#count.data"];
}

+ (AFHTTPRequestOperation *)getListWithType:(OrderType)type
                                       page:(NSUInteger)page
                                       size:(NSUInteger)size
                                    success:(HttpServiceBasicSucessBackBlock)success
                                    failure:(HttpServiceBasicFailBackBlock)failure {
    
//    OrderTypeAdded,         // 新增
//    OrderTypeUnhandled,     // 未响应
//    OrderTypeRectClothes,   // 去收衣
//    OrderTypehandled,       // 服务中
//    OrderTypeFinished,      // 已完成
//    OrderTypeRejected,      // 已拒绝
    
    NSLog(@"type = %ld", (long)type);
    
    NSInteger status;
    if (1 == type) {
        status = 1;
    }else if (2 == type) {
        status = 4;
    }else if (3 == type) {
        status = 5;
    }else if (4 == type) {
        status = 6;
    }
    
    NSDictionary *params = @{@"status": @(status),
                             @"currentPage": @(page),
                             @"pageSize": @(size)};
    
    NSLog(@"params = %@", params);
    
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"merchantorder/getshoporder" andToken:YES andParameterDic:params andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:^(AFHTTPRequestOperation *operation, id responsObject) {
        OrderCollectionModel *collection = [OrderCollectionModel objectWithKeyValues:responsObject];
        if(success) {
            success(operation, collection);
        }
    } andFailedCallback:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
    
    return operation;
}
//允许用户取消订单
+ (AFHTTPRequestOperation *)allowCustomerRefuseWithOrderId:(NSString *)orderid
                                               success:(HttpServiceBasicSucessBackBlock)success
                                               failure:(HttpServiceBasicFailBackBlock)failure
{
    NSDictionary *params = @{@"orderId": orderid};
    
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"merchantorder/cancelOrderAble" andToken:YES andParameterDic:params andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:success andFailedCallback:failure];
    return operation;
 
}

#warning 以前的接单 现在是自动接单 所以接口应该调下面的那个 //
+ (AFHTTPRequestOperation *)acceptWithOrderid:(NSString *)orderid
                                      success:(HttpServiceBasicSucessBackBlock)success
                                      failure:(HttpServiceBasicFailBackBlock)failure {
    NSDictionary *params = @{@"orderId": orderid};
    //   merchantorder/collectclothesbymerchant
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"merchantorder/acctptorder" andToken:YES andParameterDic:params andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:success andFailedCallback:failure];
    return operation;
}
//批量接单
+ (AFHTTPRequestOperation *)acceptWithOrderids:(NSArray *)orderids
                                       success:(HttpServiceBasicSucessBackBlock)success
                                       failure:(HttpServiceBasicFailBackBlock)failure {
    
    NSMutableString *arryIds = [[NSMutableString alloc] init];
    for (OrderModel *order in orderids) {
    
        [arryIds appendString:[NSString stringWithFormat:@"%@,",order.orderid]];
    }
    [arryIds deleteCharactersInRange:NSMakeRange(arryIds.length - 1, 1)];
    
    
    NSDictionary *params = @{@"orderIdList": arryIds};
    
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"merchantorder/acctptorderarray" andToken:YES andParameterDic:params andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:success andFailedCallback:failure];
    
    return operation;
}

#pragma mark - 拒绝收衣服 已经失效
// 拒绝收衣服
+ (AFHTTPRequestOperation *)rejectClothesWithOrderid:(NSString *)orderid
                                       reason:(NSString *)reason
                                      success:(HttpServiceBasicSucessBackBlock)success
                                      failure:(HttpServiceBasicFailBackBlock)failure
{
    NSDictionary *params = @{@"orderId": orderid,
                             @"reason": reason};
    
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"merchantorder/rejectordercollectclothes" andToken:YES andParameterDic:params andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:success andFailedCallback:failure];
    
//    NSDateComponents

    return operation;

    
}


+ (AFHTTPRequestOperation *)rejectWithOrderid:(NSString *)orderid
                                       reason:(NSString *)reason
                                      success:(HttpServiceBasicSucessBackBlock)success
                                      failure:(HttpServiceBasicFailBackBlock)failure {
    NSDictionary *params = @{@"orderId": orderid,
                             @"servingRemark": reason};
    
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"merchantorder/rejectorder" andToken:YES andParameterDic:params andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:success andFailedCallback:failure];
    return operation;
}


+ (AFHTTPRequestOperation *)getDetailWithOrderid:(NSString *)orderid
                                         success:(HttpServiceBasicSucessBackBlock)success
                                         failure:(HttpServiceBasicFailBackBlock)failure {
    NSDictionary *params = @{@"orderId": orderid};
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"merchantorder/getorderdetail" andToken:YES andParameterDic:params andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:success andFailedCallback:failure];
    
    return operation;
}


+ (AFHTTPRequestOperation *)getCountWithSuccess:(HttpServiceBasicSucessBackBlock)success
                                        failure:(HttpServiceBasicFailBackBlock)failure {
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"merchantorder/getshopordercount" andToken:YES andParameterDic:nil andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:^(AFHTTPRequestOperation *operation, id responsObject) {
        OrderCount *ordercount = [OrderCount objectWithKeyValues:responsObject];
        if (success) {
            success(operation, ordercount);
        }
    } andFailedCallback:failure];
    return operation;
}

#warning 此处为 商家确认 收件 在首页的 那个 确认收衣那里应该调这个接口了
+ (AFHTTPRequestOperation *)confirmOrderClothes:(NSString *)orderid
                                        success:(HttpServiceBasicSucessBackBlock)success
                                        failure:(HttpServiceBasicFailBackBlock)failure
{
    NSDictionary *params = @{@"orderId": orderid};
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"merchantorder/collectclothesbymerchant" andToken:YES andParameterDic:params andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:^(AFHTTPRequestOperation *operation, id responsObject) {
        if (success) {
            success(operation, responsObject);
        }
    } andFailedCallback:failure];
    return operation;
}


// 未响应的收衣
+ (AFHTTPRequestOperation *)confirmOrderClothesWithWating:(NSString *)orderid
                                                  success:(HttpServiceBasicSucessBackBlock)success
                                                  failure:(HttpServiceBasicFailBackBlock)failure
{
    NSDictionary *params = @{@"orderId": orderid};
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"merchantorder/collectclothesbymerchantnoresponse" andToken:YES andParameterDic:params andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:^(AFHTTPRequestOperation *operation, id responsObject) {
        if (success) {
            success(operation, responsObject);
        }
    } andFailedCallback:failure];
    return operation;

}
@end
