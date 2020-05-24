//
//  ShopTitleCell.h
//  LoveHome
//
//  Created by MRH-MAC on 15/2/9.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderTools.h"
@class OrderTitleCell;
@protocol OrderTitleCellDelegate <NSObject>

// 选中
- (void)shopTitleSelectButton:(OrderTitleCell *)cell isSelect:(BOOL)isSelect;

//编辑
- (void)shopTitleEditingShop:(OrderTitleCell *)cell isEditing:(BOOL)isEditing;

// 跳转
- (void)shopTitleSelectShop:(OrderTitleCell *)cell;

@end
@interface OrderTitleCell : UITableViewCell


@property (nonatomic , strong) OrderModel *ordeEntity;


@property (nonatomic , assign) BOOL isEditing;

@property (weak, nonatomic) IBOutlet UIButton *edtingShopButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;


@property (nonatomic ,assign) id<OrderTitleCellDelegate>delegate;

- (void)setSelectButtonStatus:(BOOL)isSelect;

@end
