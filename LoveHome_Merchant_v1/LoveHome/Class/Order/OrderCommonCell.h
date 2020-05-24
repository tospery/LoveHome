//
//  OrderCell.h
//  LoveHome
//
//  Created by 杨建祥 on 15/8/27.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "OrderTools.h"

typedef void(^OrderCommonCellButtonPressedBlock)(UIButton *button);

@interface OrderCommonCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIButton *acceptButton;

- (void)configOrder:(OrderModel *)order type:(OrderType)type;
- (void)setupButtonPressedBlock:(OrderCommonCellButtonPressedBlock)buttonPressedBlock;

+ (NSString *)identifier;
+ (CGFloat)heightForOrder:(OrderModel *)order;
@end
