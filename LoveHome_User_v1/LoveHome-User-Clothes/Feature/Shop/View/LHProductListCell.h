//
//  LHProductCell.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/12.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LHProductListCell;

typedef void(^LHProductListCellPressedBlock)(LHProductListCell *cell, LHProduct *product, BOOL selected);

@interface LHProductListCell : UITableViewCell
@property (nonatomic, assign) BOOL isOutOfService;

@property (nonatomic, strong) NSArray *products;

- (void)reloadState;
- (void)setupPressedBlock:(LHProductListCellPressedBlock)pressedBlock;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
