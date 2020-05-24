//
//  JXPickerView.m
//  iOSLibrary
//
//  Created by 杨建祥 on 15/7/25.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#ifdef JXEnableMasonry
#import "JXPickerView.h"
#import "Masonry.h"
#import "JXApple.h"

#define kJXDatePickerBottomHeight               (200)
#define kJXDatePickerPickerHeight               (162)
#define kJXDatePickerButtonOffset               (2)
#define kJXDatePickerButtonWidth                (80)
#define kJXDatePickerButtonHeight               (34)

typedef NS_ENUM(NSInteger, JXPickerType){
    JXPickerTypeDatetime,
    JXPickerTypeSingle,
    JXPickerTypeRelated
};

@interface JXPickerView ()
@property (nonatomic, assign) JXPickerType type;
@property (nonatomic, strong) NSArray *singleData;
@property (nonatomic, strong) NSDictionary *relatedData;
@property (nonatomic, strong) NSArray *parents;
@property (nonatomic, strong) NSArray *children;
@end

@implementation JXPickerView
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

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(kJXMetricScreenWidth, kJXMetricScreenHeight);
}

#pragma mark - Private methods
- (void)custom {
    self.backgroundColor = [UIColor clearColor];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading);
        make.trailing.equalTo(self.mas_trailing);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@(kJXDatePickerBottomHeight));
    }];
    
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor whiteColor];
    [self addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(bottomView.mas_leading);
        make.trailing.equalTo(bottomView.mas_trailing);
        make.bottom.equalTo(bottomView.mas_bottom);
        make.height.equalTo(@(kJXDatePickerPickerHeight));
    }];
    
    self.datePicker = [[UIDatePicker alloc] init];
    [container addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(container.mas_leading);
        make.trailing.equalTo(container.mas_trailing);
        make.top.equalTo(container.mas_top);
        make.bottom.equalTo(container.mas_bottom);
    }];
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [container addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(container.mas_leading);
        make.trailing.equalTo(container.mas_trailing);
        make.top.equalTo(container.mas_top);
        make.bottom.equalTo(container.mas_bottom);
    }];
    [self.pickerView setHidden:YES];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancelButton setTitle:kStringCancel forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(bottomView.mas_leading).offset(20);
        make.bottom.equalTo(container.mas_top).offset(kJXDatePickerButtonOffset * -1);
        make.width.equalTo(@(kJXDatePickerButtonWidth));
        make.height.equalTo(@(kJXDatePickerButtonHeight));
    }];
    
    self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.okButton setTitle:kStringOK forState:UIControlStateNormal];
    [self.okButton addTarget:self action:@selector(okButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.okButton];
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(bottomView.mas_trailing).offset(-20);
        make.bottom.equalTo(container.mas_top).offset(kJXDatePickerButtonOffset * -1);
        make.width.equalTo(self.cancelButton);
        make.height.equalTo(self.cancelButton);
    }];
    
    self.fgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fgButton.backgroundColor = [UIColor lightGrayColor];
    self.fgButton.alpha = 0;
    [self.fgButton addTarget:self action:@selector(fdButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.fgButton];
    [self.fgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading);
        make.top.equalTo(self.mas_top);
        make.trailing.equalTo(self.mas_trailing);
        make.bottom.equalTo(bottomView.mas_top);
    }];
}

#pragma mark - Public methods
- (void)loadData:(NSDate *)current{
    [self.datePicker setHidden:NO];
    [self.pickerView setHidden:YES];
    self.type = JXPickerTypeDatetime;
}

- (void)loadData:(NSArray *)data current:(NSString *)current{
    _singleData = data;
    
    [self.datePicker setHidden:YES];
    [self.pickerView setHidden:NO];
    self.type = JXPickerTypeSingle;
    [self.pickerView reloadAllComponents];
    
    NSInteger index = [_singleData indexOfObject:current];
    index = (index == NSNotFound) ? 0 : index;
    [self.pickerView selectRow:index inComponent:0 animated:NO];
}

- (void)loadData:(NSDictionary *)data parent:(NSString *)parent child:(NSString *)child{
    _relatedData = data;
    
    [self.datePicker setHidden:YES];
    [self.pickerView setHidden:NO];
    self.type = JXPickerTypeRelated;
    [self.pickerView reloadAllComponents];
    
    self.parents = [[_relatedData allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [self.pickerView reloadComponent:0];
    
    NSInteger index = [self.parents indexOfObject:parent];
    index = (index == NSNotFound) ? 0 : index;
    [self.pickerView selectRow:index inComponent:0 animated:NO];
    
    NSString *parentValue = self.parents[index];
    self.children = [_relatedData[parentValue] sortedArrayUsingSelector:@selector(compare:)];
    [self.pickerView reloadComponent:1];
    
    index = [self.children indexOfObject:child];
    index = (index == NSNotFound) ? 0 : index;
    [self.pickerView selectRow:index inComponent:1 animated:NO];
}

- (void)show:(BOOL)show {
    if (show) {
        [UIView animateWithDuration:0.3f animations:^{
            self.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.fgButton.alpha = 0.3f;
            }];
        }];
    }else {
        self.fgButton.alpha = 0;
        [UIView animateWithDuration:0.3f animations:^{
            self.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - Action methods
- (void)fdButtonPressed:(id)sender {
    [self show:NO];
}

- (void)cancelButtonPressed:(id)sender {
    [self show:NO];
}

- (void)okButtonPressed:(id)sender {
    [self show:NO];
    if (self.willCloseBlock) {
        self.willCloseBlock();
    }
}

#pragma mark - Delegate
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if(JXPickerTypeSingle == self.type) {
        return 1;
    }else {
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(JXPickerTypeSingle == self.type) {
        return self.singleData.count;
    }else {
        if (component == 0) {
            return self.parents.count;
        } else {
            return self.children.count;
        }
    }
}

#pragma mark UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(JXPickerTypeSingle == self.type) {
        return self.singleData[row];
    }else {
        if (component == 0) {
            return self.parents[row];
        } else {
            return self.children[row];
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(JXPickerTypeSingle == self.type) {
        return;
    }
    
    if (0 == component) {
        NSString *parentValue = self.parents[row];
        self.children = [self.relatedData[parentValue] sortedArrayUsingSelector:@selector(compare:)];
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:NO];
    }
}
@end
#endif
