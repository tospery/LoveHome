//
//  JCSegmentConditionItemView.m
//  LoveHome
//
//  Created by Joe Chen on 15/2/11.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "JCSegmentMenuBaseItemView.h"

@interface JCSegmentMenuBaseItemView()
{
    BOOL currentSelected;
}

@end

@implementation JCSegmentMenuBaseItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.selected = NO;
        
        UITapGestureRecognizer *tapGesture  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapItemViewAction:)];
        [self addGestureRecognizer:tapGesture];
        
        _showTitleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _showTitleLabel.textAlignment = NSTextAlignmentCenter;
        _showTitleLabel.textColor     = [UIColor blackColor];
        _showTitleLabel.font          = [UIFont systemFontOfSize:15.0f];
        _showTitleLabel.text = @"选择";
        [self addSubview:_showTitleLabel];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_showTitleLabel != nil)
    {
        _showTitleLabel.frame = self.bounds;
    }
}

- (BOOL)isSelected
{
    return currentSelected;
}

- (void)setSelected:(BOOL)selected
{
    currentSelected = selected;
}

- (void)tapItemViewAction:(UITapGestureRecognizer *)gesture
{
    if (_delegate && [_delegate respondsToSelector:@selector(segmentMenuBaseItemView:didClickedItem:)])
    {
        [_delegate segmentMenuBaseItemView:self didClickedItem:_index];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
