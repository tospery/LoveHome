//
//  LHSpecifyListView.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/14.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHProductListCell.h"

typedef void(^LHProductListViewPressedBlock)(LHProductListCell *cell, LHProduct *product, UIButton *btn, BOOL selected, UIImageView *imageView);

@interface LHProductListView : UIView <UITableViewDataSource, UITableViewDelegate>
//@property (nonatomic, assign) BOOL activityFlag;
@property (nonatomic, assign) BOOL isOutOfService;
- (instancetype)initWithProducts:(NSArray *)products;
@property (nonatomic, strong) UITableView *tableView;

- (void)reloadData;
- (void)setupPressedBlock:(LHProductListViewPressedBlock)pressedBlock;
@end
