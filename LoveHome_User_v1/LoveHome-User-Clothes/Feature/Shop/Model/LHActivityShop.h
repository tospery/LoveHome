//
//  LHShopActivity.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/16.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHActivityShop : NSObject
@property (nonatomic, strong) NSString *activityid;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *shopId;

@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;

@property (nonatomic, assign) NSInteger starLevel;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, strong) NSString *telphone;
@property (nonatomic, strong) NSString *address;


@property (nonatomic, strong) NSString *logourl;
@property (nonatomic, strong) NSString *shopname;
@property (nonatomic, strong) NSString *prodname;
@property (nonatomic, strong) NSString *producturl;
@property (nonatomic, assign) CGFloat price;


@end
