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
            
        case OrderTypeRectClothes:
            typeName = @"去收衣";
            break;
            
        case OrderTypehandled:
            typeName = @"已受理";
            
            break;
        case OrderTypeUnhandled:
            typeName = @"未响应";
            break;
        case OrderTypeRejected:
            typeName = @"已拒绝";
        default:
            break;
    }
    return typeName;
}

- (OrderCount *)fetchOrderCount {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[OrderTools getLocalOrdercountPath]];
}

- (void)storeOrderCount:(OrderCount *)ordercount {
    [NSKeyedArchiver archiveRootObject:ordercount toFile:[OrderTools getLocalOrdercountPath]];
}


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
    NSDictionary *params = @{@"status": @(type),
                             @"currentPage": @(page),
                             @"pageSize": @(size)};
    
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


+ (AFHTTPRequestOperation *)acceptWithOrderid:(NSString *)orderid
                                      success:(HttpServiceBasicSucessBackBlock)success
                                      failure:(HttpServiceBasicFailBackBlock)failure {
    NSDictionary *params = @{@"orderId": orderid};
    
    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"merchantorder/acctptorder" andToken:YES andParameterDic:params andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:success andFailedCallback:failure];
    return operation;
}

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
