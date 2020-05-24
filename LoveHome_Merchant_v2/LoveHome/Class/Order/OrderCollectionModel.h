//
//  OrderCollectionModel.h
//  LoveHome
//
//  Created by 杨建祥 on 15/8/27.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface OrderCollectionModel : NSObject
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger totalPages;
@property (nonatomic, assign) NSUInteger totalRows;
@property (nonatomic, assign) NSUInteger pageSize;
@property (nonatomic, strong) NSArray *orders;

@end
