//
//  LHProduct.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/3.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHSecondActivity.h"

@interface LHProduct : NSObject
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *url;    // YJX_TODO 服务器缺少该字段
@property (nonatomic, strong) NSArray *specifies;
@property (nonatomic, strong) NSString *originalPrice;

@property (nonatomic, assign) BOOL dueFlag;
@property (nonatomic, assign) BOOL actCategoryFlag;
@property (nonatomic, assign) LHSecondActivityType actPriceType;
@property (nonatomic, assign) CGFloat actPrice;
@property (nonatomic, strong) NSString *activityId;
@property (nonatomic, strong) NSString *activityTitle;
@property (nonatomic, strong) NSString *actProductImgUrl;

@end
