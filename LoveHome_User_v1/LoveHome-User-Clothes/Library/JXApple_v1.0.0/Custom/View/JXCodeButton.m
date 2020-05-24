//
//  JXCodeButton.m
//  iOSLibrary
//
//  Created by 杨建祥 on 15/7/27.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "JXCodeButton.h"
#import "JXApple.h"

@interface JXCodeButton ()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation JXCodeButton
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

- (CGSize)intrinsicContentSize {
    return CGSizeMake(100, 30);
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Access methods
- (void)setEnableTextColor:(UIColor *)enableTextColor {
    _enableTextColor = enableTextColor;
    [self exSetBorder:_enableTextColor width:kJXBorderSmall radius:kJXRadiusSmall];
    [self setTitleColor:_enableTextColor forState:UIControlStateNormal];
}

- (void)setEnableBgColor:(UIColor *)enableBgColor {
    _enableBgColor = enableBgColor;
    [self setBackgroundImage:[UIImage exImageWithColor:_enableBgColor] forState:UIControlStateNormal];
}

- (void)setDisableTextColor:(UIColor *)disableTextColor {
    _disableTextColor = disableTextColor;
    [self setTitleColor:_disableTextColor forState:UIControlStateDisabled];
}

- (void)setDisableBgColor:(UIColor *)disableBgColor {
    _disableBgColor = disableBgColor;
    [self setBackgroundImage:[UIImage exImageWithColor:_disableBgColor] forState:UIControlStateDisabled];
}

#pragma mark - Private methods
- (void)custom {
    _duration = 10;
    _enableTextColor = JXColorHex(0x29D8D6);
    _enableBgColor = [UIColor clearColor];
    _disableTextColor = JXColorHex(0xAAAAAA);
    _disableBgColor = JXColorHex(0xE5E5E5);
    
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self exSetBorder:_enableTextColor width:kJXBorderSmall radius:kJXRadiusSmall];
    
    [self setTitleColor:_enableTextColor forState:UIControlStateNormal];
    [self setTitleColor:_disableTextColor forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage exImageWithColor:_enableBgColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage exImageWithColor:_disableBgColor] forState:UIControlStateDisabled];
    
    [self setTitle:kStringGetCode forState:UIControlStateNormal];
    [self addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startTiming {
    if (self.timer) {
        return;
    }
    
    [self setEnabled:NO];
    [self exSetBorder:[UIColor clearColor] width:0 radius:kJXRadiusSmall];
    [self setTitle:[NSString stringWithFormat:@"%@(%@)", kStringReget, @(self.duration)] forState:UIControlStateDisabled];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scheduledTimer) userInfo:nil repeats:YES];
}

- (void)stopTimingWithTitle:(NSString *)title {
    [self setEnabled:YES];
    [self setTitle:title forState:UIControlStateNormal];
    [self exSetBorder:self.enableTextColor width:kJXBorderSmall radius:kJXRadiusSmall];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Action methods
- (void)pressed:(id)sender {
    [self startTiming];
}

- (void)scheduledTimer {
    if (1 == self.duration) {
        [self stopTimingWithTitle:kStringReget];
    }else {
        [self setTitle:[NSString stringWithFormat:@"%@(%@)", kStringReget, @(--self.duration)] forState:UIControlStateDisabled];
    }
}

#pragma mark - Public methods
- (void)stopTiming {
    [self stopTimingWithTitle:kStringReget];
}

- (void)reset {
    [self stopTimingWithTitle:kStringGetCode];
}
@end
