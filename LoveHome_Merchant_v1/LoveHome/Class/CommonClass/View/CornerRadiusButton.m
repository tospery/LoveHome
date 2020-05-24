//
//  CornerRadiusButton.m
//  LoveHome
//
//  Created by MRH-MAC on 15/9/22.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "CornerRadiusButton.h"

@implementation CornerRadiusButton



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = 5;
}
@end
