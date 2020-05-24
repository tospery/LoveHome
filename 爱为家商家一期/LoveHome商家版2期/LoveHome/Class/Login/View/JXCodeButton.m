//
//  JXCodeButton.m
//  iOSLibrary
//
//  Created by 杨建祥 on 15/7/27.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "JXCodeButton.h"


@interface JXCodeButton ()
@property (nonatomic, assign) NSInteger durationBak;
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
    return CGSizeMake(90, 30);
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Access methods
- (BOOL)isTiming {
    return _timer != nil;
}

- (void)setEnableTextColor:(UIColor *)enableTextColor {
    _enableTextColor = enableTextColor;
    [self exSetBorder:_enableTextColor width:1.4 radius:4.0];
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
    [self exSetBorder:_enableTextColor width:1.2 radius:4];
    
    [self setTitleColor:_enableTextColor forState:UIControlStateNormal];
    [self setTitleColor:_disableTextColor forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage exImageWithColor:_enableBgColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage exImageWithColor:_disableBgColor] forState:UIControlStateDisabled];
    
    [self setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startTiming {
    if (self.timer) {
        return;
    }
    
    if (_startBlock) {
        if (_startBlock()) {
            _duration = _durationBak;
            
            [self setEnabled:NO];
            [self exSetBorder:_disableBorderColor width:1.2 radius:4.0];
            [self setTitle:[NSString stringWithFormat:@"%@(%@)", @"获取验证码", @(self.duration)] forState:UIControlStateDisabled];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scheduledTimer) userInfo:nil repeats:YES];
        }
    }
}

- (void)stopTimingWithTitle:(NSString *)title {
    [self setEnabled:YES];
    [self setTitle:title forState:UIControlStateNormal];
    [self exSetBorder:_enableBorderColor width:1.2 radius:4.0];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Action methods
- (void)pressed:(id)sender {
    [self startTiming];
}

- (void)scheduledTimer {
    if (1 == self.duration) {
        [self stopTimingWithTitle:@"重新获取"];
    }else {
        [self setTitle:[NSString stringWithFormat:@"%@(%@)", @"重新获取", @(--self.duration)] forState:UIControlStateDisabled];
    }
}

#pragma mark - Public methods
- (void)setupWithEnableTextColor:(UIColor *)enableTextColor
                   enableBgColor:(UIColor *)enableBgColor
               enableBorderColor:(UIColor *)enableBorderColor
                disableTextColor:(UIColor *)disableTextColor
                  disableBgColor:(UIColor *)disableBgColor
              disableBorderColor:(UIColor *)disableBorderColor
                        duration:(NSInteger)duration {
    _enableTextColor = enableTextColor;
    _enableBgColor = enableBgColor;
    _enableBorderColor = enableBorderColor;
    _disableTextColor = disableTextColor;
    _disableBgColor = disableBgColor;
    _disableBorderColor = disableBorderColor;
    _durationBak = duration;
    
    
    [self setTitleColor:_enableTextColor forState:UIControlStateNormal];
    [self setTitleColor:_disableTextColor forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage exImageWithColor:_enableBgColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage exImageWithColor:_disableBgColor] forState:UIControlStateDisabled];
    [self exSetBorder:_enableBorderColor width:1.2 radius:4.0];
}

- (void)stopTiming {
    [self stopTimingWithTitle:@"重新获取"];
}

- (void)reset {
    [self stopTimingWithTitle:@"获取验证码"];
}

- (UIView *)exSetBorder:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius{
    self.layer.masksToBounds = YES;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radius;
    return self;
}
@end
