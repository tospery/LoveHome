//
//  JCSegmentMenuSubItemView.m
//  LoveHome
//
//  Created by Joe Chen on 15/2/11.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "JCSegmentMenuChildItemView.h"

@interface JCSegmentMenuChildItemView()

@property (strong, nonatomic) UIImageView *showArrowImageView;

@end

@implementation JCSegmentMenuChildItemView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize arrowImageViewSize  = CGSizeMake(13.0f, 13.0f);

    if (_showArrowImageView ==  nil)
    {
        _showArrowImageView        = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width-arrowImageViewSize.width-30.0f, (self.bounds.size.height-arrowImageViewSize.height)/2.0f, arrowImageViewSize.width, arrowImageViewSize.height)];
        [_showArrowImageView setBackgroundColor:[UIColor clearColor]];
        [_showArrowImageView setContentMode:UIViewContentModeScaleAspectFit];
        [_showArrowImageView setImage:[UIImage imageNamed:@"mainPage_DownArrow"]];
        [_showArrowImageView setHighlightedImage:[UIImage imageNamed:@"mainPage_UpArrow"]];
        [self addSubview:_showArrowImageView];
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    
    
    [_showArrowImageView setHighlighted:selected];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
