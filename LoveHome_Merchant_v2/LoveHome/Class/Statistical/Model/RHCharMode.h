//
//  RHCharModels.h
//  LoveHome
//
//  Created by MRH on 15/12/5.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

/*!
 *  @brief  图表Model (一个model一条线)
 *
 *  @param chartListData    StatistChartModelList(每一个点的数据集合)
 *  @param chartFillColor    线条颜色
 *
 */
#import <Foundation/Foundation.h>

@interface RHCharMode : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSMutableArray *chartListData;
@property (nonatomic,strong) UIColor *chartFillColor;

@property (nonatomic, strong) NSMutableArray *finishCountArr;
@property (nonatomic, strong) NSMutableArray *cancelCountArr;
@end
