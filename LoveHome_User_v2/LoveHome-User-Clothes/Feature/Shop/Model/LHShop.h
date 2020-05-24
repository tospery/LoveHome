//
//  LHShop.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/30.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

//address = "\U56db\U5ddd\U7701\U6210\U90fd\U5e02\U6b66\U4faf\U533a\U5929\U5e9c\U4e94\U8857";
//businessTime = "10:24-19:00";
//commonts = 0;
//description = "null null null";
//distance = 2308;
//freeze = 3;
//latitude = "30.56553";
//longitude = "104.07544";
//name = "\U9ec4\U74dc2\U53f7\U5e97";
//saleTotal = 0;
//shopId = 345;
//sleeping = 1;
//starLevel = 0;
//tag = "\U6d17\U8863,\U6d17\U978b,\U76ae\U5177\U6d17\U62a4,\U5962\U4f88\U54c1\U6d17\U62a4,\U5176\U4ed6";
//telePhone = 18722345678;
//url = "http://img.appvworks.com/22ef71c9f217413381fa6c68f2dcc883";


//saleTotal = 0;
//sleeping = 1;
//url = "http://img.appvworks.com/22ef71c9f217413381fa6c68f2dcc883";

@interface LHShop : NSObject <BMKAnnotation>
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *activityIconUrl;
@property (nonatomic, copy) NSString *shopDescription; // 店铺描述

@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) NSUInteger level;
@property (nonatomic, assign) NSUInteger distance;
@property (nonatomic, assign) NSUInteger totalComment;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *services;
//@property (nonatomic, strong) NSString *province;
//@property (nonatomic, strong) NSString *city;
//@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSArray *types;
@property (nonatomic, strong) NSArray *shopPictures;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) NSInteger freeze;
@property (nonatomic, assign) NSInteger saleTotal;
@property (nonatomic, assign) NSInteger sleeping; // 1表示营业，2表示休息

- (NSString *)title;
- (NSString *)subtitle;
- (CLLocationCoordinate2D)coordinate;

/**
 *  Secondary Initializer
 *
 *  @param shopId   shopId
 *  @param shopName shopName
 *
 *  @return the instance of a shop
 */
- (instancetype)initWithShopId:(NSString *)shopId shopName:(NSString *)shopName;
@end

