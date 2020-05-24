//
//  LHOrderProductCell.h
//  LoveHome-User-Clothes
//
//  Created by 李俊辉 on 15/7/27.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//  订单产品Cell
#define kCellIdentifier_OrderProduct @"OrderProductCell"
#import "LHBaseCell.h"
#import "OrderModel.h"

@interface LHOrderProductCell : LHBaseCell
@property (nonatomic, strong) OrderDetailModel *orderProduct;
+ (CGFloat)cellHeight;
@end
