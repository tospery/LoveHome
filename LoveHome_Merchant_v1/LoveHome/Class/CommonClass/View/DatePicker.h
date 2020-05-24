//
//  DatePicker.h
//  爱为家
//
//  Created by MRH-MAC on 14-10-6.
//  Copyright (c) 2014年 MRH-MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePicker;
@protocol DatePickerDelegate <NSObject>

- (void)datePcickerCancel:(DatePicker *)dataPicker;
- (void)changeDelegateString:(NSString *)contetnt;

@end

@interface DatePicker : UIView

@property (nonatomic,assign) BOOL isShowTitle;
@property(nonatomic,copy)void(^block)(NSString *date,id  category);

@property(nonatomic,copy)void(^choosePickerBlock)(NSString *beginTimeStr,NSString *endTimeStr);
@property (nonatomic,assign) id <DatePickerDelegate>delegate;


- (id)initWithtitle:(NSArray *)titles;
- (id)initWithtitle:(NSArray *)titles isShowTitle:(BOOL)isShow;



/*!
 *  @brief  显示date
 */
- (void)coverStarAnimation;

- (void)scrollRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;


/*!
 *  @brief  出入数据源
 *
 *  @param data        第一列
 *  @param SecondeData 第二列
 */
- (void)setContentData:(NSArray *)data andSconde:(NSArray *)SecondeData;

@end
