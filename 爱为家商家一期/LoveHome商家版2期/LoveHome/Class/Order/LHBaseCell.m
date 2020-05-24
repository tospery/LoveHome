//
//  LHBaseCell.m
//  LoveHome-User-Clothes
//
//  Created by 李俊辉 on 15/7/22.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHBaseCell.h"
@interface LHBaseCell()

@property (strong, nonatomic) UIView *bottomLineView;
@end
@implementation LHBaseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupLineStuff];
    }
    return self;
}

- (void)setupLineStuff
{
    [self addSubview:self.topLineView];
    [self addSubview:self.bottomLineView];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@(0.5));
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@(0.5));
    }];
}

- (void)setLastRowInSection:(BOOL)lastRowInSection
{
    _lastRowInSection = lastRowInSection;
    
    self.bottomLineView.hidden = !_lastRowInSection;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - getters and setters 
- (UIView *)topLineView
{
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = kCellLineColor;
    }
    return _topLineView;
}

- (UIView *)bottomLineView
{
    if (!_bottomLineView)
    {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = kCellLineColor;
    }
    return _bottomLineView;
}
@end
