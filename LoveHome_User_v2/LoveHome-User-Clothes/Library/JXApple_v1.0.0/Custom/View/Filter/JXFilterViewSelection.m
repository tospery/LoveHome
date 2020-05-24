//
//  JXFilterViewSelection.m
//  iOSLibrary
//
//  Created by 杨建祥 on 15/9/26.
//  Copyright © 2015年 杨建祥. All rights reserved.
//

#import "JXFilterViewSelection.h"

@implementation JXFilterViewSelectionContent

@end

@interface JXFilterViewSelection ()
@property (nonatomic, strong) UIView *backgroundView;
@end

@implementation JXFilterViewSelection
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

#pragma mark - Private methods
- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    
    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = [UIColor clearColor];
    [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognize:)]];
    [self addSubview:_backgroundView];
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    if (JXiOSVersionGreaterThanOrEqual(8.0)) {
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        effectView.alpha = 0.8f;
        [_backgroundView addSubview:effectView];
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_backgroundView);
        }];
    }else {
        UIView *alphaView = [[UIView alloc] init];
        alphaView.backgroundColor = [UIColor lightGrayColor];
        alphaView.alpha = 0.8f;
        [_backgroundView addSubview:alphaView];
        [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_backgroundView);
        }];
    }
    
}

- (void)tapRecognize:(UITapGestureRecognizer *)recognizer {
    if (_isAnimating) {
        return;
    }
    
    _isAnimating = YES;
    if ([_delegate respondsToSelector:@selector(filterViewSelection:didSelectIndex:withObject:)]) {
        [_delegate filterViewSelection:self didSelectIndex:(self.tag - JXFilterViewTagBegin) withObject:nil];
    }
}

#pragma mark - Accessor methods
- (void)setContentView:(JXFilterViewSelectionContent *)contentView {
    _contentView = contentView;
    [self addSubview:_contentView];
}
@end





