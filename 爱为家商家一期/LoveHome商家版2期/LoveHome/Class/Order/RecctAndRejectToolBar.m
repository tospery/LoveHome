//
//  RecctAndRejectToolBar.m
//  LoveHome
//
//  Created by MRH-MAC on 15/9/2.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "RecctAndRejectToolBar.h"

@implementation RecctAndRejectToolBar

- (void)awakeFromNib
{
    _rightButton.layer.cornerRadius = 4;
    _leftButton.layer.cornerRadius = 4;
    _rightButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _leftButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _rightButton.layer.borderWidth = _leftButton.layer.borderWidth = 0.5;
    
    [_rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
     [_leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClick:(UIButton *)sender
{
    if (sender == _rightButton) {
        
        if (_rightClick) {
            _rightClick();
        }
        
    }
    else
    {
        if (_leftClick) {
            _leftClick();
        }
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
