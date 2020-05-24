//
//  JXPickerView.h
//  iOSLibrary
//
//  Created by 杨建祥 on 15/7/25.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#ifdef JXEnableMasonry
#import <UIKit/UIKit.h>

typedef void(^JXDatePickerWillCloseBlock)(void);

@interface JXPickerView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIButton *fgButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, copy) JXDatePickerWillCloseBlock willCloseBlock;

- (void)loadData:(NSDate *)current;
- (void)loadData:(NSArray *)data current:(NSString *)current;
- (void)loadData:(NSDictionary *)data parent:(NSString *)parent child:(NSString *)child;

- (void)show:(BOOL)show;
@end
#endif