//
//  JXCodeButton.h
//  iOSLibrary
//
//  Created by 杨建祥 on 15/7/27.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL(^JXCodeButtonStartBlock)(void);

@interface JXCodeButton : UIButton
@property (nonatomic, copy) JXCodeButtonStartBlock startBlock;
@property (nonatomic, assign, readonly) BOOL isTiming;

@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) UIColor *enableTextColor;
@property (nonatomic, strong) UIColor *enableBgColor;
@property (nonatomic, strong) UIColor *enableBorderColor;
@property (nonatomic, strong) UIColor *disableTextColor;
@property (nonatomic, strong) UIColor *disableBgColor;
@property (nonatomic, strong) UIColor *disableBorderColor;

- (void)setupWithEnableTextColor:(UIColor *)enableTextColor
                   enableBgColor:(UIColor *)enableBgColor
               enableBorderColor:(UIColor *)enableBorderColor
                disableTextColor:(UIColor *)disableTextColor
                  disableBgColor:(UIColor *)disableBgColor
              disableBorderColor:(UIColor *)disableBorderColor
                        duration:(NSInteger)duration;

- (void)stopTiming;
- (void)reset;

@end
