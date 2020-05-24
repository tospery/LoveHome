//
//  LHV2ShopFooter.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 16/3/7.
//  Copyright © 2016年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LHShopFooterFuncCallback)(LHCartShop *cartShop, BOOL goOrder);

@interface LHV2ShopFooter : UITableViewHeaderFooterView
@property (nonatomic, strong) LHCartShop *cartShop;
@property (nonatomic, copy) LHShopFooterFuncCallback funcCallback;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
