//
//  LHShopListCell.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/16.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHShop.h"
#import "LHActivityShop.h"

@interface LHShopFavoriteCell : SWTableViewCell
@property (nonatomic, strong) LHShop *shop;
@property (nonatomic, strong) LHActivityShop *activityShop;
@property (nonatomic, strong) LHFavorite *favorite;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
