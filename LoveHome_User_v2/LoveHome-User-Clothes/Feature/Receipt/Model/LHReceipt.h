//
//  LHAddress.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/24.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHReceipt : NSObject
@property (nonatomic, strong) NSString *receiptID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, strong) NSString *provinceName;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, assign) NSInteger areaId;
@property (nonatomic, strong) NSString *areaName;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *addressExpand;  // 门牌号
@property (nonatomic, assign) NSInteger productCount;
@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, assign) double longitude;     // 经度
@property (nonatomic, assign) double latitude;      // 纬度

+ (LHReceipt *)fetch;
+ (void)storage:(LHReceipt *)receipt;

@end











