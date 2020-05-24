//
//  OrderRejectViewCell.h
//  LoveHome
//
//  Created by MRH-MAC on 15/9/1.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface OrderRejectViewCell : UITableViewCell
@property (nonatomic,strong) OrderModel *orderDetail;
+(NSString *)identifier;
+(CGFloat)heightWithOrder:(OrderModel *)order;
@end
