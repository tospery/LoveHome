//
//  LHCaptchaButton.m
//  LoveHome-User-Clothes
//
//  Created by 李俊辉 on 15/7/22.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//  

#import "LHCaptchaButton.h"
static int TimeCount = 0;
@interface LHCaptchaButton()
@property (strong, nonatomic) UIButton *getCodeButton;
@property (strong, nonatomic) UILabel  *displayLabel;
@property (assign, nonatomic) NSInteger timeInterval;
@property (strong, nonatomic) UIColor  *themeColor;
@property (strong, nonatomic) UIColor *disableTextColor;
@property (strong, nonatomic) UIColor *disableBGColor;
@end

@implementation LHCaptchaButton
- (instancetype)initWithCountTime:(NSInteger)timeInterval themeColor:(UIColor *)themeColor disableTextColor:(UIColor *)disableTextColor disableBGColor:(UIColor *)disableBGColor
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor clearColor];
        _timeInterval = timeInterval;
        _themeColor = themeColor;
        _disableTextColor = disableTextColor;
        _disableBGColor = disableBGColor;
        
        [self setupSubView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        self.backgroundColor = [UIColor clearColor];
        _timeInterval = kCaptchaTime;
        _themeColor = kColorTheme;
        _disableTextColor = kCaptchaDisableTextColor;
        _disableBGColor = kCaptchaDisableButtonBGColor;
        
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView
{
    [self addSubview:self.getCodeButton];
    [self.getCodeButton addSubview:self.displayLabel];
    
    [self.getCodeButton addTarget:self action:@selector(timerFire) forControlEvents:UIControlEventTouchUpInside];
    
    [self.getCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.getCodeButton.mas_centerY);
        make.centerX.equalTo(self.getCodeButton.mas_centerX);
    }];
}

- (void)finish
{
    [self resetCodeState:NO];
}

#pragma mark - private methods
/**
 *  移除定时器
 */
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

/**
 *  添加定时器
 */
- (void)addTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(upateTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

/**
 *  重置UI
 */
- (void)resetCodeState:(BOOL)retry
{
    [_timer invalidate];
    _timer = nil;
    
    NSString *tips = @"获取验证码";
    if (retry) {
        tips = @"重新获取";
    }
    self.displayLabel.text = tips;
    self.displayLabel.textColor = _themeColor;
    self.getCodeButton.enabled = YES;
    self.getCodeButton.backgroundColor = [UIColor whiteColor];
    self.getCodeButton.layer.masksToBounds = YES;
    self.getCodeButton.layer.borderColor = _themeColor.CGColor;
    self.getCodeButton.layer.borderWidth = 1;
    self.getCodeButton.layer.cornerRadius = 6;
    TimeCount = 0;
}

#pragma mark - event response
- (void)timerFire
{
    BOOL shouldStart = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(LHCaptchaButtonShouldStartCountDown)]) {
        shouldStart = [self.delegate LHCaptchaButtonShouldStartCountDown];
    }
    if (shouldStart)
    {
        [self addTimer];
        self.getCodeButton.enabled = NO;
        self.displayLabel.textColor = _disableTextColor;
        self.getCodeButton.backgroundColor = _disableBGColor;
        self.getCodeButton.layer.masksToBounds = YES;
        self.getCodeButton.layer.borderColor = _disableBGColor.CGColor;
        self.getCodeButton.layer.borderWidth = 1;
        self.getCodeButton.layer.cornerRadius = 6;
        self.displayLabel.text = [NSString stringWithFormat:@"重新获取(%d)",(int)_timeInterval];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(LHCaptchaButtonDidStartCountDown)]) {
            [self.delegate LHCaptchaButtonDidStartCountDown];
        }
    }
    else
    {
        //不执行
    }
}

- (void)upateTime
{
    TimeCount++;
    if (TimeCount >= _timeInterval)
    {
        [self resetCodeState:YES];
        if (self.delegate && [self.delegate respondsToSelector:@selector(LHCaptchaButtonDidEndCountDown)]) {
            [self.delegate LHCaptchaButtonDidEndCountDown];
        }
        return;
    }
    self.displayLabel.text = [NSString stringWithFormat:@"重新获取(%d)",(int)_timeInterval - TimeCount];
}

#pragma mark - getters and setters

- (UIButton *)getCodeButton
{
    if (!_getCodeButton) {
        _getCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getCodeButton exSetBorder:_themeColor width:1 radius:6];
    }
    return _getCodeButton;
}

- (UILabel *)displayLabel
{
    if (!_displayLabel) {
        _displayLabel = [[UILabel alloc] init];
        _displayLabel.text = @"获取验证码";
        _displayLabel.textColor = _themeColor;
        _displayLabel.font = [UIFont systemFontOfSize:14];
    }
    return _displayLabel;
}

@end
