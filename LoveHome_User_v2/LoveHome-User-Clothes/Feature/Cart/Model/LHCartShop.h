//
//  LHCartShop.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/4.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHSpecify.h"
#import "LHOrder.h"

@interface LHCartShop : NSObject
@property (nonatomic, assign) BOOL dueFlag;
@property (nonatomic, strong) NSString *shopID;         // 店铺ID
@property (nonatomic, strong) NSString *shopName;         // 店铺ID
@property (nonatomic, strong) NSMutableArray *specifies; // 商品集合


@property (nonatomic, assign) BOOL isEditing;           // 是否处于编辑状态
@property (nonatomic, strong) NSString *remark;

+ (NSArray *)fetch;
+ (void)storage:(NSArray *)cartShops;

+ (void)addProductWithOrder:(LHOrder *)order;
+ (NSInteger)getProdunctCount;
@end
