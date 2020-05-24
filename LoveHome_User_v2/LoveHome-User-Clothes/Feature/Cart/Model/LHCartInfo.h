//
//  LHCartInfo.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 16/1/5.
//  Copyright © 2016年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHProduct.h"


@class LHCartInfoShop;
@class LHCartInfoProduct;
@class LHCartInfoSpecify;

@interface LHCartInfo : NSObject
@property (nonatomic, strong) NSArray *normalPro;
@property (nonatomic, strong) NSArray *passDueProducts;

@end


@interface LHCartInfoShop : NSObject
@property (nonatomic, strong) NSString *shopId;         // 店铺ID
@property (nonatomic, strong) NSString *shopName;         // 店铺ID
@property (nonatomic, strong) NSMutableArray *products; // 商品集合
@property (nonatomic, strong) NSMutableArray *activictInfos; // 商品集合

@end


@interface LHCartInfoProduct : NSObject
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSArray *specifies;

@end


@interface LHCartInfoActivity : NSObject
@property (nonatomic, assign) NSInteger actPriceType; // 1折扣/2组合
@property (nonatomic, assign) CGFloat actPrice;
@property (nonatomic, strong) NSString *activityId;
@property (nonatomic, strong) NSString *activityName;
@property (nonatomic, strong) NSString *actProductImgUrl;
@property (nonatomic, strong) NSArray *products;

@end


//"id": 5163,
//"name": "默认规格",
//"price": 14,
//"url": null,
//"buyCount": 1
@interface LHCartInfoSpecify : NSObject
@property (nonatomic, assign) NSInteger buyCount; // 表示商品的数量
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *discountPrice;

@end




