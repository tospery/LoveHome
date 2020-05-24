//
//  JXDatePicker.m
//  UE04_DatetimePicker（自定义日期时间选择器）
//
//  Created by 杨建祥 on 15/1/9.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#ifdef JXEnableMasonry
#import "JXDatePicker.h"
#import "JXApple.h"
#import "Masonry.h"

#define kBottomHeight               (200)
#define kPickerHeight               (162)
#define kButtonWidth                (80)
#define kButtonHeight               (34)
#define kButtonOffset               (2)

@interface JXDatePicker ()
@property (nonatomic, copy) void(^closeBlock)(BOOL selected);
@end

@implementation JXDatePicker
#pragma mark - Override methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self custom];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self custom];
    }
    return self;
}

- (void)dealloc {
}

- (CGSize)intrinsicContentSize {
    JXDevice *device = [JXDevice sharedInstance];
    return CGSizeMake(device.appFrameSize.width, device.appFrameSize.height);
}

#pragma mark custom
- (void)custom {
    self.backgroundColor = [UIColor clearColor];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading);
        make.trailing.equalTo(self.mas_trailing);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@(kBottomHeight));
    }];
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    [self addSubview:_datePicker];
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(bottomView.mas_leading);
        make.trailing.equalTo(bottomView.mas_trailing);
        make.bottom.equalTo(bottomView.mas_bottom);
        make.height.equalTo(@(kPickerHeight));
    }];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancelButton setTitle:kStringCancel forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(bottomView.mas_leading).offset(20);
        make.bottom.equalTo(_datePicker.mas_top).offset(kButtonOffset * -1);
        make.width.equalTo(@(kButtonWidth));
        make.height.equalTo(@(kButtonHeight));
    }];
    
    _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_okButton setTitle:kStringOK forState:UIControlStateNormal];
    [_okButton addTarget:self action:@selector(okButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_okButton];
    [_okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(bottomView.mas_trailing).offset(-20);
        make.bottom.equalTo(_datePicker.mas_top).offset(kButtonOffset * -1);
        make.width.equalTo(_cancelButton);
        make.height.equalTo(_cancelButton);
    }];
    
    _foregroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _foregroundButton.backgroundColor = [UIColor lightGrayColor];
    _foregroundButton.alpha = 0;
    [_foregroundButton addTarget:self action:@selector(foregroundButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_foregroundButton];
    [_foregroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading);
        make.top.equalTo(self.mas_top);
        make.trailing.equalTo(self.mas_trailing);
        make.bottom.equalTo(bottomView.mas_top);
    }];
}

#pragma mark - Action methods
- (void)foregroundButtonPressed:(id)sender {
    if (_closeBlock) {
        _closeBlock(NO);
    }
}

- (void)cancelButtonPressed:(id)sender {
    if (_closeBlock) {
        _closeBlock(NO);
    }
}

- (void)okButtonPressed:(id)sender {
    if (_closeBlock) {
        _closeBlock(YES);
    }
}

#pragma mark - Public methods
- (void)setupCloseBlock:(void(^)(BOOL selected))closeBlock {
    _closeBlock = closeBlock;
}
@end
#endif
