//
//  RHLoadView.m
//  LoveHome
//
//  Created by MRH on 15/8/11.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import "RHLoadView.h"
#import "Masonry.h"
#import "RHType.h"

#define kReloadStr @"重新加载"
@interface RHLoadView ()

@property (nonatomic, strong) UIImageView *processingImageView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *callbackButton;
@property (nonatomic, strong) UIImageView *resultImageView;

@end
@implementation RHLoadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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

#pragma mark - privateMethods
- (void)setup {
    self.backgroundColor = BackGroudColor;
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
    self.messageLabel.textColor = RHColorHex(0x666666, 1);
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

        [self exRotateWithOncetime:0.8 withView:self.processingImageView];
    }
}


- (void)notifyApplicationDidEnterBackground:(NSNotification *)notify {
    if (!self.processingImageView.hidden) {

        [self exStopRotationWithView:self.processingImageView];
    }
}

- (void)showProcessing {
    [self.resultImageView setHidden:YES];
    [self.messageLabel setHidden:YES];
    [self.callbackButton setHidden:YES];
    
    [self.processingImageView setHidden:NO];
    [self exRotateWithOncetime:0.8 withView:self.processingImageView];
}

- (UIButton *)callbackButton {
    if (!_callbackButton) {
        _callbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _callbackButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_callbackButton setTitle:kReloadStr forState:UIControlStateNormal];
        [_callbackButton setTitleColor:RHColorHex(0x666666, 1) forState:UIControlStateNormal];
        

        [_callbackButton setBackgroundImage:        [UIImage creatImageWithColor:[UIColor whiteColor] andSize:CGSizeZero] forState:UIControlStateNormal];
        [_callbackButton setBackgroundImage:        [UIImage creatImageWithColor:RHColorHex(0xF4F4F4,1) andSize:CGSizeZero] forState:UIControlStateHighlighted];
        [_callbackButton addTarget:self action:@selector(callbackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_callbackButton exSetBorder:RHColorHex(0x666666,1) width:1.0f radius:4.0f];
        [_callbackButton sizeToFit];
    }
    return _callbackButton;
}

- (void)callbackButtonPressed:(id)sender {
    if (self.callback) {
        self.callback();
    }
}

- (void)showResultWithImage:(UIImage *)image message:(NSString *)message functitle:(NSString *)functitle callback:(void(^)(void))callback {
    
    [self exStopRotationWithView:self.processingImageView];
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


#pragma mark - Class methods
+ (void)showProcessingAddedTo:(UIView *)view rect:(CGRect)rect {
    
    if ([view isKindOfClass:[UITableView class]]) {
        [(UITableView *)view setScrollEnabled:NO];
    }
    
    RHLoadView *loadView = [RHLoadView loadForView:view];
    if (!loadView) {
        loadView = [[RHLoadView alloc] init];
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




+ (void)hideForView:(UIView *)view {
    if ([view isKindOfClass:[UITableView class]]) {
        [(UITableView *)view setScrollEnabled:YES];
    }
    
    RHLoadView *loadView = [RHLoadView loadForView:view];
    if (loadView) {
        [loadView removeFromSuperview];
    }
}

+ (RHLoadView *)loadForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[RHLoadView class]]) {
            return  (RHLoadView *)subview;
        }
    }
    return nil;
}


// 显示错误
+ (void)showResultAddedTo:(UIView *)view
                     rect:(CGRect)rect
                    error:(NSError *)error
                 callback:(void(^)(void))callback {
    UIImage *image;
    if (RHErrorCodeNetworkException == error.code) {
        image = [UIImage imageNamed:@"rh_error_network"];
    }else if (RHErrorCodeServerException == error.code) {
        image = [UIImage imageNamed:@"rh_error_server"];
    }else {
        
        // 其余错误
        image = [UIImage imageNamed:@"rh_error_server"];
    }
    
    [RHLoadView showResultAddedTo:view rect:rect image:image message:error.localizedDescription functitle:kReloadStr callback:callback];

}


+ (void)showResultAddedTo:(UIView *)view
                     rect:(CGRect)rect
                    image:(UIImage *)image
                  message:(NSString *)message
                functitle:(NSString *)functitle
                 callback:(void(^)(void))callbackcallback
{
    if ([view isKindOfClass:[UITableView class]]) {
        [(UITableView *)view setScrollEnabled:YES];
    }
    
    RHLoadView *loadView = [RHLoadView loadForView:view];
    if (!loadView) {
        loadView = [[RHLoadView alloc] init];
        [view addSubview:loadView];
        
        if (CGRectEqualToRect(rect, CGRectZero)) {
            [loadView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view);
            }];
        }else {
            loadView.frame = rect;
        }
    }
  [loadView showResultWithImage:image message:message functitle:functitle callback:callbackcallback];

}

#pragma mark - Animation

- (void)exRotateWithOncetime:(CFTimeInterval)oncetime withView:(UIView *)view {
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: -M_PI * 2.0 ];
    rotationAnimation.duration = oncetime;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)exStopRotationWithView:(UIView *)view {
    [view.layer removeAnimationForKey:@"rotationAnimation"];
}
@end
