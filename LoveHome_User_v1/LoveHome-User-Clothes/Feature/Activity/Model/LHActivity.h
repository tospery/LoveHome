//
//  LHActivity.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/21.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHActivity : NSObject
@property (nonatomic, assign) LHActivityType type;

@property (nonatomic, strong) NSString *activityid;
@property (nonatomic, strong) NSString *baseProductId;
@property (nonatomic, strong) NSString *imgurl;
@property (nonatomic, strong) NSString *targeturl;
@property (nonatomic, strong) NSString *activitytitle;

@end
