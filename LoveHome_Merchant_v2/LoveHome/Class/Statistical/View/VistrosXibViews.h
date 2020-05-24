//
//  VistrosXibViews.h
//  LoveHome
//
//  Created by MRH on 15/12/5.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger , CharType){
    VistrosCount,
    OrderStatis,
    ActiveOrderStatis,
    OrderPriceStatis,
};

@interface VistrosXibViews : UIView

/*!
 *  @brief  curretntDatalist<RHChartModel>
 */
@property (nonatomic,strong) NSMutableArray *currenDataList;
@property (nonatomic,assign) CharType chartType;
@property (nonatomic,copy) void(^selecBlcok)(NSInteger index);

// 本地数据源个数改变时调用此方法(列如原本3条线现在一条线)
- (void)reloadDataView;

// 数据源内容改变时调用此方法(currentDataList 重新配置了数据源后必须调用此方法)
- (void)resetData;

@end
