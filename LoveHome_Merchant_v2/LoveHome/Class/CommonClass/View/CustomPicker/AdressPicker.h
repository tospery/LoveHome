//
//  AdressPicker.h
//  Pikcer
//
//  Created by MRH-MAC on 15/1/8.
//  Copyright (c) 2015年 MRH-MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdressPicker;

@protocol AdressPickerDelegate <NSObject>



- (void)adressPickerDidChangeStatus:(AdressPicker *)picker;

@end

@interface AdressPicker : UIView

/*!
 *  @brief  省市区 数据源
 */
@property (nonatomic , strong) NSArray  *provinces, *cities, *areas;


/*!
 *  @brief  省 市 区
 */
@property (nonatomic , strong) NSString *state,*city,*district;

@property (nonatomic , assign) id <AdressPickerDelegate>delegate;

- (void)show;
@end
