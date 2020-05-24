//
//  AdvertDisplayerView.h
//  AdvertDisplayerView
//
//  Created by Joe Chen on 14/12/9.
//  Copyright (c) 2014年 卡莱博尔. All rights reserved.
//


#import <UIKit/UIKit.h>

/*!
 *  @brief  广告循环展示器
 */
@protocol AdvertDisplayerViewDelegate;
@interface AdvertDisplayerView : UIView

@property (assign, nonatomic) id<AdvertDisplayerViewDelegate>delegate;
@property (assign, nonatomic) BOOL           isAutoRun;     //默认是： YES--自动滑动
@property (assign, nonatomic) NSTimeInterval animationTime; //默认动画切换时间是5秒
@property (strong, nonatomic) NSArray        *dataArray;    //显示的数据源


- (void)reloadData;

/*!
 *  @brief  停止动画
 */
- (void)stopAnimation;

@end


@protocol AdvertDisplayerViewDelegate <NSObject>

@optional
- (void)advertDisplayerView:(AdvertDisplayerView *)view didClickedItem:(NSInteger)index;

@end


