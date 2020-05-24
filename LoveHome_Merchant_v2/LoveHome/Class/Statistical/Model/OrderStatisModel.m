//
//  OrderStatisModel.m
//  LoveHome
//
//  Created by MRH on 15/12/18.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import "OrderStatisModel.h"
#import "StatistChartModel.h"
#import "RHCharMode.h"

NSString * const FinshiOrderIdentifer = @"finisedOrders";
//NSString * const MerchantRefuseOrderIdentifer = @"merchantRefuseOrders";
NSString * const UserCancelOrdersIdentifer = @"userCancelOrders";
NSString * const PayOrdersIdentifer = @"payOrders";

@implementation OrderStatisModel

// Each OrderStatus list (return [<StatistChartModel>])
+(RHCharMode *)getDiffrentStatusOrdersList:(NSArray *)allData  withType:(NSString *)orderIdentifer{
    NSMutableArray *arry = [[NSMutableArray alloc] init];
    NSMutableArray *farr = [[NSMutableArray alloc] init];

    for (NSDictionary *dic in allData) {
        StatistChartModel *model = [[StatistChartModel alloc] init];
        model.valueDate = dic[@"date"];
        
        
        if ([dic[orderIdentifer] isEqual:[NSNull null]]) {
            model.cost = 0;
        } else {
        model.cost = [dic[orderIdentifer] integerValue];
        }
        [farr addObject:[NSString stringWithFormat:@"%ld", (long)model.cost]];
        [arry addObject:model];
    }
    if (arry.count == 1) {
        [arry addObject:[arry lastObject]];
    }
    RHCharMode *model = [[RHCharMode alloc] init];
    model.name = orderIdentifer;
    model.chartListData = arry;
    model.finishCountArr = farr;
    return model;
}


@end
