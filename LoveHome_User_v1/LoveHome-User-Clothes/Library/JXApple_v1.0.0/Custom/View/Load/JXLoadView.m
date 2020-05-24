//
//  JXLoadView.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/1.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "JXLoadView.h"

static UIColor *lBackgroundColor;

@interface JXLoadView ()
@property (nonatomic, strong) UIImageView *processingImageView;

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *callbackButton;
@property (nonatomic, strong) UIImageView *resultImageView;

@property (nonatomic, copy) JXLoadResultCallback callback;
@end

@implementation JXLoadView
#pragma mark - Override methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods
- (void)setup {
    self.backgroundColor = [JXLoadViewManager backgroundColor];
    
    self.processingImageView = [[UIImageView alloc] init];
    self.processingImageView.image = [UIImage imageNamed:@"jx_loading_static"];
    [self addSubview:self.processingImageView];
    [self.processingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@48);
        make.height.equalTo(self.processingImageView.mas_width);
    }];
    [self.processingImageView setHidden:YES];
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.font = [UIFont systemFontOfSize:17.0f];
    self.messageLabel.textColor = JXColorHex(0x666666);
    [self.messageLabel sizeToFit];
    [self addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.messageLabel setHidden:YES];
    
    
    self.resultImageView = [[UIImageView alloc] init];
    self.resultImageView.image = [UIImage imageNamed:@"jx_error_network"];
    [self.resultImageView sizeToFit];
    [self addSubview:self.resultImageView];
    [self.resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.messageLabel);
        make.bottom.equalTo(self.messageLabel.mas_top).offset(-12.0f);
    }];
    [self.resultImageView setHidden:YES];
    
    [self addSubview:self.callbackButton];
    [_callbackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.messageLabel);
        make.top.equalTo(self.messageLabel.mas_bottom).offset(16.0f);
        make.width.equalTo(@88);
        make.height.equalTo(@32);
    }];
    [_callbackButton setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyApplicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyApplicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)notifyApplicationDidBecomeActive:(NSNotification *)notify {
    if (!self.processingImageView.hidden) {
        [self.processingImageView exRotateWithOncetime:0.8];
    }
}


- (void)notifyApplicationDidEnterBackground:(NSNotification *)notify {
    if (!self.processingImageView.hidden) {
        [self.processingImageView exStopRotation];
    }
}

- (void)showProcessing {
    [self.resultImageView setHidden:YES];
    [self.messageLabel setHidden:YES];
    [self.callbackButton setHidden:YES];
    
    [self.processingImageView setHidden:NO];
    [self.processingImageView exRotateWithOncetime:0.8];
}

- (void)showResultWithError:(NSError *)error callback:(JXLoadResultCallback)callback {
    self.callback = callback;
    
    [self.processingImageView exStopRotation];
    [self.processingImageView setHidden:YES];
    
    [self.callbackButton setHidden:(callback ? NO : YES)];
    
    if (JXErrorCodeNetworkException == error.code) {
        [self.resultImageView setHidden:NO];
        [self.messageLabel setHidden:NO];
        self.resultImageView.image = [UIImage imageNamed:@"jx_error_network"];
        self.messageLabel.text = error.localizedDescription;
    }else if (JXErrorCodeServerException == error.code) {
        [self.resultImageView setHidden:NO];
        [self.messageLabel setHidden:NO];
        self.resultImageView.image = [UIImage imageNamed:@"jx_error_server"];
        self.messageLabel.text = error.localizedDescription;
    }else {
        [self.resultImageView setHidden:YES];
        [self.messageLabel setHidden:NO];
        self.messageLabel.text = error.localizedDescription;
    }
}

- (void)showResultWithImage:(UIImage *)image message:(NSString *)message functitle:(NSString *)functitle callback:(JXLoadResultCallback)callback {
    [self.processingImageView exStopRotation];
    [self.processingImageView setHidden:YES];
    
    if (image) {
        self.resultImageView.image = image;
        [self.resultImageView setHidden:NO];
    }else {
        self.resultImageView.image = nil;
        [self.resultImageView setHidden:YES];
    }
    
    if (message.length != 0) {
        self.messageLabel.text = message;
        [self.messageLabel setHidden:NO];
    }else {
        self.messageLabel.text = nil;
        [self.messageLabel setHidden:YES];
    }
    
    if (functitle.length != 0 && callback) {
        self.callback = callback;
        [self.callbackButton setTitle:functitle forState:UIControlStateNormal];
        [self.callbackButton setHidden:NO];
    }else {
        self.callback = NULL;
        [self.callbackButton setHidden:YES];
    }
}

#pragma mark - Action methods
- (void)callbackButtonPressed:(id)sender {
    if (self.callback) {
        self.callback();
    }
}

#pragma mark - Accessor methods
- (UIButton *)callbackButton {
    if (!_callbackButton) {
        _callbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _callbackButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_callbackButton setTitle:kStringReload forState:UIControlStateNormal];
        [_callbackButton setTitleColor:JXColorHex(0x666666) forState:UIControlStateNormal];
        [_callbackButton setBackgroundImage:[UIImage exImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_callbackButton setBackgroundImage:[UIImage exImageWithColor:JXColorHex(0xF4F4F4)] forState:UIControlStateHighlighted];
        [_callbackButton addTarget:self action:@selector(callbackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_callbackButton exSetBorder:JXColorHex(0x666666) width:1.0f radius:4.0f];
        [_callbackButton sizeToFit];
    }
    return _callbackButton;
}

#pragma mark - Class methods
+ (void)showProcessingAddedTo:(UIView *)view rect:(CGRect)rect {
    if ([view isKindOfClass:[UITableView class]]) {
        [(UITableView *)view setScrollEnabled:NO];
    }
    
    JXLoadView *loadView = [JXLoadView loadForView:view];
    if (!loadView) {
        loadView = [[JXLoadView alloc] init];
        [view addSubview:loadView];
        
        if (CGRectEqualToRect(rect, CGRectZero)) {
            [loadView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view);
            }];
        }else {
            loadView.frame = rect;
        }
    }
    [loadView showProcessing];
}

+ (void)showResultAddedTo:(UIView *)view rect:(CGRect)rect error:(NSError *)error callback:(JXLoadResultCallback)callback {
    UIImage *image;
    if (JXErrorCodeNetworkException == error.code) {
        image = [UIImage imageNamed:@"jx_error_network"];
    }else if (JXErrorCodeServerException == error.code) {
        image = [UIImage imageNamed:@"jx_error_server"];
    }else {
        image = nil;
    }
    
    [JXLoadView showResultAddedTo:view rect:rect image:image message:error.localizedDescription functitle:kStringReload callback:callback];
}

+ (void)showResultAddedTo:(UIView *)view rect:(CGRect)rect image:(UIImage *)image message:(NSString *)message functitle:(NSString *)functitle callback:(JXLoadResultCallback)callback {
    if ([view isKindOfClass:[UITableView class]]) {
        [(UITableView *)view setScrollEnabled:YES];
    }
    
    JXLoadView *loadView = [JXLoadView loadForView:view];
    if (!loadView) {
        loadView = [[JXLoadView alloc] init];
        [view addSubview:loadView];
        
        if (CGRectEqualToRect(rect, CGRectZero)) {
            [loadView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view);
            }];
        }else {
            loadView.frame = rect;
        }
    }
    [loadView showResultWithImage:image message:message functitle:functitle callback:callback];
}

+ (void)hideForView:(UIView *)view {
    if ([view isKindOfClass:[UITableView class]]) {
        [(UITableView *)view setScrollEnabled:YES];
    }
    
    JXLoadView *loadView = [JXLoadView loadForView:view];
    if (loadView) {
        [loadView removeFromSuperview];
    }
}

+ (JXLoadView *)loadForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[JXLoadView class]]) {
            return  (JXLoadView *)subview;
        }
    }
    return nil;
}
@end


@implementation JXLoadViewManager
+ (void)setBackgroundColor:(UIColor *)backgroundColor {
    lBackgroundColor = backgroundColor;
}

+ (UIColor *)backgroundColor {
    if (!lBackgroundColor) {
        lBackgroundColor = [UIColor whiteColor];
    }
    return lBackgroundColor;
}
@end



