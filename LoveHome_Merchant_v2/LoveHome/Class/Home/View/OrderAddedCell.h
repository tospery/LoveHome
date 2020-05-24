//
//  OrderAddedCell.h
//  LoveHome
//
//  Created by 杨建祥 on 15/8/29.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

typedef void(^OrderAddedCellFuncBlock)(UIButton *button, OrderModel *order);
typedef void(^OrderAddedCellSelectBlock)(BOOL selected);

@interface OrderAddedCell : UITableViewCell

@property (nonatomic, strong) OrderModel *order;

@property (nonatomic, assign) NSInteger cancelable;

- (void)configOrder:(OrderModel *)order;
- (void)setupFuncBlock:(OrderAddedCellFuncBlock)funcBlock;
- (void)setupSelectBlock:(OrderAddedCellSelectBlock)selectBlock;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
