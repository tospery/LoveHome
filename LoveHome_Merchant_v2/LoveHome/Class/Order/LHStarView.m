//
//  LHStarView.hs
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/31.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHStarView.h"

@interface LHStarView ()
@property (nonatomic, strong) NSArray *stars;
@property (nonatomic, copy) LHStarViewDidSelectBlock didSelectBlock;
@end

@implementation LHStarView
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
    return CGSizeMake(90, 20);
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Access methods
- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    
    if (enabled) {
        for (UIButton *btn in self.stars) {
            [btn addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else {
        for (UIButton *btn in self.stars) {
            [btn removeTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)setLevel:(NSInteger)level {
    _level = level;
    
    for (int i = 0; i < self.count; ++i) {
        if (i < level) {
            [(UIButton *)self.stars[i] setSelected:YES];
        }else {
            [(UIButton *)self.stars[i] setSelected:NO];
        }
    }
}

#pragma mark - Private methods
- (void)custom {
    _enabled = YES;
    _count = 5;
    _level = 3;
    
    _selectedImage = [UIImage imageNamed:@"star_selected"];
    _unselectedImage = [UIImage imageNamed:@"star_unselected"];
    
    self.backgroundColor = [UIColor clearColor];
    
}


- (void)pressed:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ((btn.tag < (_level - 1)) || (btn.tag > _level)) {
        return;
    }
    
    BOOL state = !btn.isSelected;
    [btn setSelected:state];
    
    if (state) {
        _level++;
    }else {
        _level--;
    }
    
    if (self.didSelectBlock) {
        self.didSelectBlock(_level);
    }
}

#pragma mark - Public methods
- (void)setupDidSelectBlock:(LHStarViewDidSelectBlock)didSelectBlock {
    self.didSelectBlock = didSelectBlock;
}

- (void)loadData {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    NSMutableArray *stars = [NSMutableArray arrayWithCapacity:self.count];
    for (int i = 0; i < self.count; ++i) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [btn setBackgroundImage:self.selectedImage forState:UIControlStateSelected];
        [btn setBackgroundImage:self.unselectedImage forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
        if (i < _level) {
            [btn setSelected:YES];
        }else {
            [btn setSelected:NO];
        }
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self).multipliedBy(0.8);
            make.width.equalTo(btn.mas_height);
            make.centerY.equalTo(self);
            make.centerX.equalTo(self).multipliedBy((CGFloat)(1 + (2 * i)) / 5);
        }];
        [stars addObject:btn];
    }
    self.stars = stars;
    
    self.enabled = _enabled;
}
@end
