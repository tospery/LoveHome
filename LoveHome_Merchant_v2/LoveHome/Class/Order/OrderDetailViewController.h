//
//  OrderDetailViewController.h
//  LoveHome
//
//  Created by MRH-MAC on 15/9/1.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "ModelViewController.h"
#import "OrderTools.h"

@interface OrderDetailViewController : ModelViewController
@property (nonatomic,assign) OrderType type;
@property (nonatomic,strong) OrderModel *orderDetail;
@property (nonatomic,copy) void(^leftActionBlcok)(OrderModel *order,OrderType type);
@property (nonatomic,copy) void(^rightActionBlcok)(OrderModel *order,OrderType type);

- (id)initWithOrder:(OrderModel *)order withOrderType:(OrderType)orderTyep;



@end
