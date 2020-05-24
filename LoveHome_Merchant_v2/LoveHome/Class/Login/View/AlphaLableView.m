//
//  AlphaLableView.m
//  LoveHome
//
//  Created by MRH-MAC on 14/12/4.
//  Copyright (c) 2014年 卡莱博尔. All rights reserved.
//

#import "AlphaLableView.h"

@interface AlphaLableView ()



@end
@implementation AlphaLableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}



- (void)initView
{
    UIView *alpaView = [[UIView alloc] initWithFrame:self.bounds];
    alpaView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    alpaView.backgroundColor = [UIColor blackColor];
    alpaView.layer.cornerRadius = 3;
    alpaView.alpha = 0.5;
    [self addSubview:alpaView];
    
    _lable = [[UILabel alloc] initWithFrame:self.bounds];
    _lable.backgroundColor = [UIColor clearColor];
    _lable.numberOfLines = 0;
    _lable.textColor = [UIColor whiteColor];
    _lable.font = [UIFont systemFontOfSize:14];
    _lable.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _lable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_lable];
    
    _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_loadingView stopAnimating];
    [_loadingView setHidesWhenStopped:YES];
    [self addSubview:_loadingView];
   

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *view in self.subviews)
    {
        [view setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
            _loadingView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
            _loadingView.bounds = CGRectMake(0, 0, 20, 20);
        }
    }
}


- (void)setContentText:(NSString *)ContentText
{
    _lable.text = ContentText;
    [self setNeedsDisplay];
    
}
//- (void)setFrame:(CGRect)frame
//{
//    [self initView];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
