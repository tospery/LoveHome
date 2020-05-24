//
//  LHAddressManager.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/27.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXProvince : NSObject
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString *name;

@end

@interface JXCity : NSObject
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger provinceID;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *firstLetter;

@end

@interface JXZone : NSObject
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger cityID;
@property (nonatomic, strong) NSString *name;

@end

@interface JXAddressManager : NSObject
/**
 *  获取所有省、直辖市
 *
 *  @return 所有省、直辖市
 */
+ (NSArray *)getAllProvinces;

/**
 *  获取省下的所有城市
 *
 *  @param province 省
 *
 *  @return 省下的所有城市
 */
+ (NSArray *)findCitiesWithProvince:(JXProvince *)province;

/**
 *  获取城市下的所有区
 *
 *  @param city 城市
 *
 *  @return 城市下的所有区
 */
+ (NSArray *)findZonesWithCity:(JXCity *)city;
@end

