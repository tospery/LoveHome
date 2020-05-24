//
//  JXFilterViewCategory.m
//  iOSLibrary
//
//  Created by 杨建祥 on 15/9/26.
//  Copyright © 2015年 杨建祥. All rights reserved.
//

#import "JXFilterViewCategory.h"

@interface JXFilterViewCategory ()

@end

@implementation JXFilterViewCategory
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
    self.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.tintColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    _indicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jx_arrow_down_gray"]];
    [self addSubview:_indicatorImageView];
    [_indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(_titleLabel.mas_trailing).offset(6);
    }];
    
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_actionButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_actionButton];
    [_actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - Action methods
- (void)buttonPressed:(UIButton *)button {
    if (_isAnimating) {
        return;
    }
    
    _isAnimating = YES;
    button.selected = !button.selected;
    if ([_delegate respondsToSelector:@selector(filterViewCategory:didSelectIndex:)]) {
        [_delegate filterViewCategory:self didSelectIndex:self.tag];
    }
}
@end




