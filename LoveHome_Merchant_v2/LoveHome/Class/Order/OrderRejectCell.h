//
//  OrderRejectCell.h
//  LoveHome
//
//  Created by 杨建祥 on 15/8/28.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "OrderTools.h"

typedef void(^OrderRejectCellButtonPressedBlock)(UIButton *button);

@interface OrderRejectCell : UITableViewCell

- (void)configOrder:(OrderModel *)order;
- (void)setupButtonPressedBlock:(OrderRejectCellButtonPressedBlock)buttonPressedBlock;

+ (NSString *)identifier;
+ (CGFloat)heightForOrder:(OrderModel *)order;
@end
