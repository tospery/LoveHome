//
//  JXCodeButton.h
//  iOSLibrary
//
//  Created by 杨建祥 on 15/7/27.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXCodeButton : UIButton
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) UIColor *enableTextColor;
@property (nonatomic, strong) UIColor *enableBgColor;
@property (nonatomic, strong) UIColor *disableTextColor;
@property (nonatomic, strong) UIColor *disableBgColor;

- (void)stopTiming;
- (void)reset;

@end
