//
//  LHProductSpecify.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/3.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHProduct.h"

@interface LHSpecify : LHProduct <NSCopying>
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, assign) BOOL isEditing; // 是否处于编辑状态
@property (nonatomic, assign) BOOL selected;    // 用于购物车，表示商品是否勾选
@property (nonatomic, assign) NSInteger pieces; // 表示商品的数量


@end
