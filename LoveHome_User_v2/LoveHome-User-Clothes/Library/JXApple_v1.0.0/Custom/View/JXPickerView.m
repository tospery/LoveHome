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

#define kJXDatePickerBottomHeight               (200)
#define kJXDatePickerPickerHeight               (162)
#define kJXDatePickerButtonOffset               (2)
#define kJXDatePickerButtonWidth                (80)
#define kJXDatePickerButtonHeight               (34)

typedef NS_ENUM(NSInteger, JXPickerType){
    JXPickerTypeDatetime,
    JXPickerTypeSingle,
    JXPickerTypeRelated,
    JXPickerTypePCZ,            // 省市区
    JXPickerTypeCZ,              // 市区
    JXPickerType5,
    JXPickerType6
};

@interface JXPickerView ()
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) JXPickerType type;
@property (nonatomic, strong) NSArray *singleData;
@property (nonatomic, strong) NSDictionary *relatedData;
@property (nonatomic, strong) NSArray *parents;
@property (nonatomic, strong) NSArray *children;

@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *zones;

@property (nonatomic, strong) NSArray *dates5;
@property (nonatomic, strong) NSArray *firsts5;
@property (nonatomic, strong) NSArray *seconds5;
@property (nonatomic, strong) NSArray *thirds5;

@property (nonatomic, strong) NSArray *firsts6;
@property (nonatomic, strong) NSArray *seconds6;
@property (nonatomic, strong) NSDictionary *secondDict6;
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
    return CGSizeMake(kJXScreenWidth, kJXScreenHeight);
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
    _num = 0;
}

- (void)loadDataWithDft:(NSDate *)dft {
    [self.datePicker setHidden:YES];
    [self.pickerView setHidden:NO];
    self.type = JXPickerType5;
    _num = 3;
    
    NSDate *date = [NSDate date];
    _dates5 = [NSDate exDatesFromDate:date ToDay:7];
    NSMutableArray *firsts = [NSMutableArray arrayWithCapacity:7];
    for (int i = 0; i < _dates5.count; ++i) {
        NSDate *cur = _dates5[i];
        if (0 == i) {
            [firsts addObject:[NSString stringWithFormat:@"今天(%@)", [cur exWeekday]]];
        }else if (1 == i) {
            [firsts addObject:[NSString stringWithFormat:@"明天(%@)", [cur exWeekday]]];
        }else {
            [firsts addObject:[NSString stringWithFormat:@"%@(%@)", [cur exStringWithFormat:kJXFormatDatetimeStyle3], [cur exWeekday]]];
        }
    }
    _firsts5 = firsts;
    
    _seconds5 = @[@"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20"];
    _thirds5 = @[@"00", @"30"];
    
    [self.pickerView reloadAllComponents];
}

- (void)loadDataWithDft_v2:(NSDate *)dft {
    [self.datePicker setHidden:YES];
    [self.pickerView setHidden:NO];
    self.type = JXPickerType5;
    _num = 2;
    
    NSDate *date = [NSDate date];
    _dates5 = [NSDate exDatesFromDate:date ToDay:3];
    NSMutableArray *firsts = [NSMutableArray arrayWithCapacity:7];
    for (int i = 0; i < _dates5.count; ++i) {
        NSDate *cur = _dates5[i];
        if (0 == i) {
            [firsts addObject:[NSString stringWithFormat:@"今天(%@)", [cur exWeekday]]];
        }else if (1 == i) {
            [firsts addObject:[NSString stringWithFormat:@"明天(%@)", [cur exWeekday]]];
        }else {
            [firsts addObject:[NSString stringWithFormat:@"%@(%@)", [cur exStringWithFormat:kJXFormatDatetimeStyle3], [cur exWeekday]]];
        }
    }
    _firsts5 = firsts;
    
    _seconds5 = @[@"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20"];
    _thirds5 = @[@"00", @"30"];
    
    [self.pickerView reloadAllComponents];
}

- (void)loadData_v2:(NSArray *)firsts secondDict:(NSDictionary *)secondDict {
    [self.datePicker setHidden:YES];
    [self.pickerView setHidden:NO];
    self.type = JXPickerType6;
    _num = 2;
    _firsts6 = firsts;
    _secondDict6 = secondDict;
    // [self.pickerView reloadAllComponents];
    
    [self.pickerView reloadComponent:0];
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    
    NSString *first = _firsts6[0];
    _seconds6 = _secondDict6[first];
    [self.pickerView reloadComponent:1];
    [self.pickerView selectRow:0 inComponent:1 animated:NO];
    
//    
//    self.parents = [[_relatedData allKeys] sortedArrayUsingSelector:@selector(compare:)];
//    [self.pickerView reloadComponent:0];
//    
//    NSInteger index = [self.parents indexOfObject:parent];
//    index = (index == NSNotFound) ? 0 : index;
//    [self.pickerView selectRow:index inComponent:0 animated:NO];
//    
//    NSString *parentValue = self.parents[index];
//    self.children = [_relatedData[parentValue] sortedArrayUsingSelector:@selector(compare:)];
//    [self.pickerView reloadComponent:1];
//    
//    index = [self.children indexOfObject:child];
//    index = (index == NSNotFound) ? 0 : index;
//    [self.pickerView selectRow:index inComponent:1 animated:NO];
    
    // [self.pickerView reloadAllComponents];
}

- (void)loadData:(NSArray *)data current:(NSString *)current{
    _singleData = data;
    _num = 1;
    
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
    _num = 2;
    
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

- (void)loadDataWithProvinces:(NSArray *)provinces
                     province:(JXProvince *)province
                         city:(JXCity *)city
                         zone:(JXZone *)zone {
    _num = 3;
    
    _provinces = provinces;
    
    JXProvince *p = province;
    if (!province) {
        p = provinces[0];
    }
    _cities = [JXAddressManager findCitiesWithProvince:p];
    
    JXCity *c = city;
    if (!city) {
        c = _cities[0];
    }
    _zones = [JXAddressManager findZonesWithCity:c];
    
    [self.datePicker setHidden:YES];
    [self.pickerView setHidden:NO];
    self.type = JXPickerTypePCZ;
    [self.pickerView reloadAllComponents];
}

- (void)loadDataWithCities:(NSArray *)cities
                         city:(JXCity *)city
                         zone:(JXZone *)zone {
    _num = 2;
    _cities = cities;
    
    JXCity *c = city;
    if (!city) {
        c = _cities[0];
    }
    _zones = [JXAddressManager findZonesWithCity:c];
    
    [self.datePicker setHidden:YES];
    [self.pickerView setHidden:NO];
    self.type = JXPickerTypeCZ;
    [self.pickerView reloadAllComponents];
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
        id result = nil;
        if (self.type == JXPickerType5) {
            int a1 = [_pickerView selectedRowInComponent:0];
            int a2 = [_pickerView selectedRowInComponent:1];
            int a3 = [_pickerView selectedRowInComponent:2];
            
            NSDate *b1 = _dates5[a1];
            NSString *b2 = [b1 exStringWithFormat:kJXFormatForDateInternational];
            NSString *b3 = [NSString stringWithFormat:@"%@ %@:%@", b2, _seconds5[a2], _thirds5[a3]];
            
            result = [b3 exDateWithFormat:kJXFormatDatetimeStyle2];
        }else if (self.type == JXPickerType6) {
            int a1 = [_pickerView selectedRowInComponent:0];
            int a2 = [_pickerView selectedRowInComponent:1];
            NSString *b1 = self.firsts6[a1];
            NSString *b2 = self.seconds6[a2];
            result = [NSString stringWithFormat:@"%@#%@", b1, b2];
        }
        self.willCloseBlock(result);
    }
}

#pragma mark - Delegate
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _num;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (JXPickerType6 == self.type) {
        return kJXScreenWidth / (CGFloat)self.num;
    }else {
        if (JXPickerType5 == self.type) {
            if (0 == component) {
                return kJXScreenWidth * 0.6;
            }else {
                return kJXScreenWidth * 0.2;
            }
        }else {
            return kJXScreenWidth / 3.0;
        }
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (JXPickerType6 == self.type) {
        if (0 == component) {
            return self.firsts6.count;
        }else {
            return self.seconds6.count;
        }
    }else {
        if(JXPickerTypeSingle == self.type) {
            return self.singleData.count;
        }else if (JXPickerTypeRelated == self.type) {
            if (component == 0) {
                return self.parents.count;
            } else {
                return self.children.count;
            }
        }else if (JXPickerTypePCZ == self.type) {
            if (component == 0) {
                return self.provinces.count;
            }else if (component == 1) {
                return self.cities.count;
            }else {
                return self.zones.count;
            }
        }else if (JXPickerType5 == self.type) {
            if (component == 0) {
                return _firsts5.count;
            }else if (component == 1) {
                return _seconds5.count;
            }else {
                return _thirds5.count;
            }
        }else {
            if (component == 0) {
                return self.cities.count;
            }else {
                return self.zones.count;
            }
        }
    }
}

#pragma mark UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (JXPickerType6 == self.type) {
        if (component == 0) {
            return self.firsts6[row];
        } else {
            return self.seconds6[row];
        }
    }else {
        if(JXPickerTypeSingle == self.type) {
            return self.singleData[row];
        }else if (JXPickerTypeRelated == self.type) {
            if (component == 0) {
                return self.parents[row];
            } else {
                return self.children[row];
            }
        }else if (JXPickerTypePCZ == self.type) {
            if (component == 0) {
                return [self.provinces[row] name];
            }else if (component == 1) {
                return [self.cities[row] name];
            }else {
                return [self.zones[row] name];
            }
        }else if (JXPickerType5 == self.type) {
            if (component == 0) {
                return _firsts5[row];
            }else if (component == 1) {
                return _seconds5[row];
            }else {
                return _thirds5[row];
            }
        }else {
            if (component == 0) {
                return [self.cities[row] name];
            }else {
                return [self.zones[row] name];
            }
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (JXPickerType6 == self.type) {
        if (0 == component) {
            NSString *first = self.firsts6[row];
            self.seconds6 = self.secondDict6[first];
            [self.pickerView reloadComponent:1];
            [self.pickerView selectRow:0 inComponent:1 animated:NO];
        }
    }else {
        if(JXPickerTypeSingle == self.type) {
            return;
        }else if (JXPickerTypeRelated == self.type) {
            if (0 == component) {
                NSString *parentValue = self.parents[row];
                self.children = [self.relatedData[parentValue] sortedArrayUsingSelector:@selector(compare:)];
                [self.pickerView reloadComponent:1];
                [self.pickerView selectRow:0 inComponent:1 animated:NO];
            }
        }else if (JXPickerTypePCZ == self.type) {
            if (0 == component) {
                JXProvince *p = self.provinces[row];
                _cities = [JXAddressManager findCitiesWithProvince:p];
                [self.pickerView reloadComponent:1];
                [self.pickerView selectRow:0 inComponent:1 animated:NO];
                
                JXCity *c = _cities[0];
                _zones = [JXAddressManager findZonesWithCity:c];
                [_pickerView reloadComponent:2];
                [_pickerView selectRow:0 inComponent:2 animated:NO];
            }else if (1 == component) {
                JXCity *c = _cities[row];
                _zones = [JXAddressManager findZonesWithCity:c];
                [_pickerView reloadComponent:2];
                [_pickerView selectRow:0 inComponent:2 animated:NO];
            }
        }else {
            if (0 == component) {
                //            JXCity *c = _cities[row];
                //            _zones = [JXAddressManager findZonesWithCity:c];
                //            [_pickerView reloadComponent:1];
                //            [_pickerView selectRow:0 inComponent:1 animated:NO];
            }
        }
    }
}
@end
#endif
