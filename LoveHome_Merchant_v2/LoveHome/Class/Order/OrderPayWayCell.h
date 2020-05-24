//
//  OrderPayWayCell.h
//  LoveHome
//
//  Created by MRH-MAC on 15/9/2.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderTools.h"
@interface OrderPayWayCell : UITableViewCell

@property (nonatomic,strong) OrderModel *order;

+(CGFloat)getCellHeight:(OrderModel *)order;

@end
