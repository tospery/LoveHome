//
//  LHActivityCenter.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/1.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHActivityCenter : NSObject
@property (nonatomic, assign) NSInteger activityId;
@property (nonatomic, copy) NSString *activityTitle;
@property (nonatomic, assign) NSInteger saleCounts;
@property (nonatomic, copy) NSString *surplusDateStr;
@property (nonatomic, assign) NSUInteger surplusTotalSecond;
@property (nonatomic, copy) NSString *url;

@end
