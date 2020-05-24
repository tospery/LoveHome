//
//  RecctAndRejectToolBar.m
//  LoveHome
//
//  Created by MRH-MAC on 15/9/2.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "RecctAndRejectToolBar.h"
#import "OrderTools.h"
@interface RecctAndRejectToolBar ()

@property (nonatomic, assign) OrderType type;


@end
@implementation RecctAndRejectToolBar

- (void)awakeFromNib
{
    _rightButton.layer.cornerRadius = 4;
    _leftButton.layer.cornerRadius = 4;
    _rightButton.layer.borderColor = JXColorHex(0xff4400).CGColor;
    _leftButton.layer.borderColor = JXColorHex(0xff4400).CGColor;
    [_rightButton setTitleColor:JXColorHex(0xff4400) forState:UIControlStateNormal];
   
    
    [_leftButton setImage:[UIImage imageNamed:@"ico_phone"] forState:UIControlStateNormal];
    _leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 60);
    [_leftButton setTitleColor:JXColorHex(0xff4400) forState:UIControlStateNormal];
    _rightButton.layer.borderWidth = _leftButton.layer.borderWidth = 1;
    
    [_rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
     [_leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#warning 点击事件可做修改,将左面的按钮事件改成联系客户
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
