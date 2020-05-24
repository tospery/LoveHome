//
//  OrderFinishCell.h
//  LoveHome
//
//  Created by 杨建祥 on 15/8/28.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "OrderTools.h"
#import "LHStarView.h"

typedef void(^OrderFinishCellButtonPressedBlock)(UIButton *button);

@interface OrderFinishCell : UITableViewCell

- (void)configOrder:(OrderModel *)order;
- (void)setupButtonPressedBlock:(OrderFinishCellButtonPressedBlock)buttonPressedBlock;

+ (NSString *)identifier;
+ (CGFloat)heightForOrder:(OrderModel *)order;
@end
