//
//  LHShop.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/30.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>


//"businessTime": "10:30-18:00",
//"telePhone": "18101234567",

@interface LHShop : NSObject <BMKAnnotation>
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *shopName;

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
//@property (nonatomic, strong) NSArray *logos;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) NSInteger freeze;

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

