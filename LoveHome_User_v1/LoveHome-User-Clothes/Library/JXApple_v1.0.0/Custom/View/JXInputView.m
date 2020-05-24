//
//  JXInputView.m
//  iOSLibrary
//
//  Created by 杨建祥 on 15/9/20.
//  Copyright © 2015年 杨建祥. All rights reserved.
//

#import "JXInputView.h"

@interface JXInputView ()
@property (nonatomic, assign) NSInteger defaultProvinceID;
@property (nonatomic, assign) NSInteger defaultCityID;
@property (nonatomic, assign) NSInteger defaultZoneID;
@property (nonatomic, strong) NSArray  *provinces, *cities, *zones;
@property (nonatomic, strong) UIPickerView *picker;
@end

@implementation JXInputView
- (instancetype)initWithDefaultProvinceID:(NSInteger)defaultProvinceID
                            defaultCityID:(NSInteger)defaultCityID
                            defaultZoneID:(NSInteger)defaultZoneID {
    if (self = [self initWithFrame:CGRectMake(0, 0, kJXScreenWidth, 180.0f)]) {
        _defaultProvinceID = defaultProvinceID;
        _defaultCityID = defaultCityID;
        _defaultZoneID = defaultZoneID;
        [self custom];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (_didSelectBlock) {
        _didSelectBlock(_provinces[[_picker selectedRowInComponent:0]], _cities[[_picker selectedRowInComponent:1]], _zones[[_picker selectedRowInComponent:2]]);
    }
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(kJXScreenWidth, 180.0f);
}

- (void)custom {
    NSInteger i = 0;
    NSInteger provinceIndex = 0;
    NSInteger cityIndex = 0;
    NSInteger zoneIndex = 0;
    
    _provinces = [JXAddressManager getAllProvinces];
    for (i = 0; i < _provinces.count; ++i) {
        JXProvince *p = _provinces[i];
        if (p.uid == _defaultProvinceID) {
            break;
        }
    }
    
    provinceIndex = i;
    if (provinceIndex == _provinces.count) {
        _cities = [JXAddressManager findCitiesWithProvince:_provinces[0]];
        _zones = [JXAddressManager findZonesWithCity:_cities[0]];
        NSLog(@"无效的默认省ID");
    }else {
        JXProvince *p = [[JXProvince alloc] init];
        p.uid = _defaultProvinceID;
        _cities = [JXAddressManager findCitiesWithProvince:p];
        
        for (i = 0; i < _cities.count; ++i) {
            JXCity *c = _cities[i];
            if (c.uid == _defaultCityID) {
                break;
            }
        }
        
        cityIndex = i;
        if (cityIndex == _cities.count) {
            _zones = [JXAddressManager findZonesWithCity:_cities[0]];
            NSLog(@"无效的默认城市ID");
        }else {
            JXCity *c = [[JXCity alloc] init];
            c.uid = _defaultCityID;
            _zones = [JXAddressManager findZonesWithCity:c];
            
            for (i = 0; i < _zones.count; ++i) {
                JXZone *z = _zones[i];
                if (z.uid == _defaultZoneID) {
                    break;
                }
            }
            if (i == _zones.count) {
                zoneIndex = 0;
            }else {
                zoneIndex = i;
            }
        }
    }
    
    _picker = [[UIPickerView alloc] init]; //CGRectMake(0, 0, kJXScreenWidth, 180.0f)];
    _picker.showsSelectionIndicator = YES;
    _picker.backgroundColor = [UIColor whiteColor];
    _picker.delegate = self;
    _picker.dataSource = self;
    [self addSubview:_picker];
    [_picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
//    NSInteger index = [self.parents indexOfObject:parent];
//    index = (index == NSNotFound) ? 0 : index;
//    [self.pickerView selectRow:index inComponent:0 animated:NO];
    
    [_picker selectRow:provinceIndex inComponent:0 animated:NO];
    [_picker selectRow:cityIndex inComponent:1 animated:NO];
    [_picker selectRow:zoneIndex inComponent:2 animated:NO];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return [_provinces count];
            break;
        case 1:
            return [_cities count];
            break;
        case 2:
            return [_zones count];
            break;
        default:
            return 0;
            break;
    }
}

//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    switch (component) {
//        case 0:
//            return 80.0f;
//            break;
//        case 1:
//            return 100.0f;
//            break;
//        case 2:
//            return kJXScreenWidth - 80.0f - 100.0f;
//            break;
//        default:
//            return 0;
//            break;
//    }
//}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return [(JXProvince *)([_provinces objectAtIndex:row]) name];
            break;
        case 1:
            return [(JXCity *)[_cities objectAtIndex:row] name];
            break;
        case 2:
            //if ([_zones count] > 0) {
                return [(JXZone *)[_zones objectAtIndex:row] name];
                break;
            //}
        default:
            return  @"";
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0: {
            _cities = [JXAddressManager findCitiesWithProvince:_provinces[row]];
            [_picker selectRow:0 inComponent:1 animated:YES];
            [_picker reloadComponent:1];
            
            _zones = [JXAddressManager findZonesWithCity:_cities[0]];
            [_picker selectRow:0 inComponent:2 animated:YES];
            [_picker reloadComponent:2];
            break;
        }
        case 1: {
            _zones = [JXAddressManager findZonesWithCity:_cities[row]];
            [_picker selectRow:0 inComponent:2 animated:YES];
            [_picker reloadComponent:2];
            break;
        }
        case 2: {
            break;
        }
        default:
            break;
    }
    
    if (_didSelectBlock) {
        _didSelectBlock(_provinces[[pickerView selectedRowInComponent:0]], _cities[[pickerView selectedRowInComponent:1]], _zones[[pickerView selectedRowInComponent:2]]);
    }
}
@end



