//
//  JXDatePicker.h
//  UE04_DatetimePicker（自定义日期时间选择器）
//
//  Created by 杨建祥 on 15/1/9.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#ifdef JXEnableMasonry
#import <UIKit/UIKit.h>

@interface JXDatePicker : UIView
@property (nonatomic, strong) UIButton *foregroundButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIDatePicker *datePicker;

- (void)setupCloseBlock:(void(^)(BOOL selected))closeBlock;
@end
#endif