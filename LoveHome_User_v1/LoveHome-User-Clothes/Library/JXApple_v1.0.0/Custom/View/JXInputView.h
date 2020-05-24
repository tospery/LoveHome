//
//  JXInputView.h
//  iOSLibrary
//
//  Created by 杨建祥 on 15/9/20.
//  Copyright © 2015年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXAddressManager.h"

typedef void(^JXInputViewDidSelectBlock)(JXProvince *province, JXCity *city, JXZone *zone);

@interface JXInputView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, copy) JXInputViewDidSelectBlock didSelectBlock;

- (instancetype)initWithDefaultProvinceID:(NSInteger)defaultProvinceID
                            defaultCityID:(NSInteger)defaultCityID
                            defaultZoneID:(NSInteger)defaultZoneID;

@end
