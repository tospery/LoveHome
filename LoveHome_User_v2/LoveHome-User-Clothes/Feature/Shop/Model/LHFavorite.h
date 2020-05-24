//
//  LHFavorite.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/27.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHFavorite : NSObject
@property (nonatomic, assign) NSUInteger uid;
@property (nonatomic, assign) NSUInteger shopId;
@property (nonatomic, assign) NSUInteger starLevel;
@property (nonatomic, assign) NSUInteger distance;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, strong) NSString * shopName;
@property (nonatomic, strong) NSString * logoUrl;
@property (nonatomic, strong) NSString * activityIconUrl;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, assign) NSInteger freeze;
@property (nonatomic, assign) NSInteger coverage;
@property (nonatomic, assign) NSInteger sleeping;

@end
