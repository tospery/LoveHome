//
//  OrderStatisModel.h
//  LoveHome
//
//  Created by MRH on 15/12/18.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RHCharMode;
@interface OrderStatisModel : NSObject

@property (nonatomic,assign) NSInteger allOrders;                   // 总订单
@property (nonatomic,assign) NSInteger finisedOrders;               // 完成订单
@property (nonatomic,assign) NSInteger merchantRefuseOrders;        // 商家拒绝
@property (nonatomic,assign) NSInteger userCancelOrders;            // 用户取消


// Each OrderStatus list (return [<StatistChartModel>])
+(RHCharMode *)getDiffrentStatusOrdersList:(NSArray *)allData  withType:(NSString *)orderIdentifer;
@end

extern NSString *const FinshiOrderIdentifer;
extern NSString *const MerchantRefuseOrderIdentifer;
extern NSString *const UserCancelOrdersIdentifer;
extern NSString *const PayOrdersIdentifer;

