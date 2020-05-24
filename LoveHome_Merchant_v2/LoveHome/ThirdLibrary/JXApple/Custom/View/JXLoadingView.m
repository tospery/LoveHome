//
//  JXLoadingView.m
//  MyiOS
//
//  Created by Thundersoft on 10/19/14.
//  Copyright (c) 2014 Thundersoft. All rights reserved.
//

#ifdef JXEnableMasonry
#import "JXLoadingView.h"

static JXLoadingViewType lType;
static NSData *lGifData;
static UIFont *lMessageFont;

@interface JXLoadingView ()
@property (nonatomic, assign) JXLoadingViewType type;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
#ifdef JXEnableFLAnimatedImage
@property (nonatomic, strong) FLAnimatedImageView *gifImageView;
#endif

@property (nonatomic, strong) UIImageView *failedImageView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *retryButton;

@property (nonatomic, copy) JXLoadingViewRetryBlock retryBlock;
@end

@implementation JXLoadingView
#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = JXColorHex(0xF4F4F4);
    }
    return self;
}

#pragma mark - Public methods
- (void)showProcessing {
    if (JXLoadingViewTypeActivity == [JXLoadingView type]) {
        [self.activityIndicatorView startAnimating];
    }else {
#ifdef JXEnableFLAnimatedImage
        [self.gifImageView setHidden:NO];
#endif
    }
    
    [_failedImageView setHidden:YES];
    [_messageLabel setHidden:YES];
    [_retryButton setHidden:YES];
}

- (void)showFailedWithImage:(UIImage *)image message:(NSString *)message retry:(JXLoadingViewRetryBlock)retry {
    self.failedImageView.image = image;
    self.messageLabel.text = message;
    self.retryBlock = retry;
    
    if (JXLoadingViewTypeActivity == [JXLoadingView type]) {
        [_activityIndicatorView stopAnimating];
    }else {
#ifdef JXEnableFLAnimatedImage
        [_gifImageView setHidden:YES];
#endif
    }
    
    [_failedImageView setHidden:NO];
    [_messageLabel setHidden:NO];
    [self.retryButton setHidden:(retry ? NO : YES)];
}

#pragma mark - Accessor methods
- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] init];
        _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _activityIndicatorView.color = [UIColor darkGrayColor];
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
        [_activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return _activityIndicatorView;
}

#ifdef JXEnableFLAnimatedImage
- (FLAnimatedImageView *)gifImageView {
    if (!_gifImageView) {
        _gifImageView = [[FLAnimatedImageView alloc] init];
        _gifImageView.animatedImage =  [FLAnimatedImage animatedImageWithGIFData:[JXLoadingView gifData]];
        [self addSubview:_gifImageView];
        [_gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return _gifImageView;
}
#endif

- (UIImageView *)failedImageView {
    if (!_failedImageView) {
        _failedImageView = [[UIImageView alloc] init];
        [self addSubview:_failedImageView];
        [_failedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-60);
        }];
    }
    return _failedImageView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [JXLoadingView messageFont];
        _messageLabel.textColor = [UIColor lightGrayColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_messageLabel];
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.failedImageView.mas_bottom).offset(20);
            make.height.equalTo(@20);
        }];
    }
    return _messageLabel;
}

- (UIButton *)retryButton {
    if (!_retryButton) {
        _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _retryButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_retryButton setTitle:kStringReload forState:UIControlStateNormal];
        [_retryButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_retryButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [_retryButton addTarget:self action:@selector(retryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_retryButton sizeToFit];
        [self addSubview:_retryButton];
        [_retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.messageLabel.mas_bottom).offset(12);
            make.width.equalTo(@80);
            make.height.equalTo(@26);
        }];
        [_retryButton exSetBorder:[UIColor lightGrayColor] width:1 radius:2];
    }
    return _retryButton;
}

#pragma mark - Action methods
- (void)retryButtonPressed:(id)sender {
    if (self.retryBlock) {
        self.retryBlock();
    }
}

#pragma mark - Class methods
+ (JXLoadingView *)loadForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[self class]]) {
            return  (JXLoadingView *)subview;
        }
    }
    return nil;
}

+ (void)showProcessingAddedTo:(UIView *)view{
    JXLoadingView *loadingView = [[self class] loadForView:view];
    if (!loadingView) {
        loadingView = [[[self class] alloc] init];
        [view addSubview:loadingView];
        [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
    }
    [loadingView showProcessing];
}

+ (void)showFailedAddedTo:(UIView *)view image:(UIImage *)image message:(NSString *)message retry:(JXLoadingViewRetryBlock)retry {
    JXLoadingView *loadingView = [[self class] loadForView:view];
    if (!loadingView) {
        loadingView = [[[self class] alloc] init];
        [view addSubview:loadingView];
        [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
    }
    [loadingView showFailedWithImage:image message:message retry:retry];
}

+ (void)showFailedAddedTo:(UIView *)view error:(NSError *)error retry:(void (^)(void))retry {
    if (!error) {
        return;
    }
    
    UIImage *image;
    if (JXErrorCodeNetworkDisable == error.code) {
        image = [UIImage imageNamed:@"network_error"];
    }else if (JXErrorCodeServerException == error.code) {
        image = [UIImage imageNamed:@"ic_server_error"];
    }
    else if (JXErrorCodeDataEmpty == error.code)
    {
        image = [UIImage imageNamed:@"order_empty"];
    }
    [JXLoadingView showFailedAddedTo:view image:image message:error.localizedDescription retry:retry];
}

+ (void)hideForView:(UIView *)view {
    JXLoadingView *loadingView = [[self class] loadForView:view];
    if (loadingView) {
        [loadingView removeFromSuperview];
    }
}

+ (UIFont *)messageFont {
    if (!lMessageFont) {
        lMessageFont = [UIFont systemFontOfSize:16.0f];
    }
    return lMessageFont;
}

+ (void)setMessageFont:(UIFont *)font {
    lMessageFont = font;
}

+ (JXLoadingViewType)type {
    return lType;
}

+ (void)setType:(JXLoadingViewType)type {
    lType = type;
}

+ (NSData *)gifData {
    if (!lGifData) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"jx_loading" withExtension:@"gif"];
        lGifData = [NSData dataWithContentsOfURL:url];
    }
    return lGifData;
}

+ (void)setGifData:(NSData *)data {
    lGifData = data;
}
@end
#endif

