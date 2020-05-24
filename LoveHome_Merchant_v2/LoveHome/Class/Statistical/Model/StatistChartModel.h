//
//  StatistChartModel.h
//  LoveHome
//
//  Created by MRH on 15/12/5.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatistChartModel : NSObject

@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString *valueDate;
//@property (nonatomic,assign) CGFloat cost;
@property (nonatomic,assign) NSInteger cost;

@property (nonatomic, assign) NSInteger finishCount;

@property (nonatomic, assign) NSInteger cancelCount;
@end
