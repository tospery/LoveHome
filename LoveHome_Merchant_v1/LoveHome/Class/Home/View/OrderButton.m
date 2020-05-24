//
//  OrderButton.m
//  LoveHome
//
//  Created by MRH-MAC on 15/8/27.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "OrderButton.h"

#define kBtImageW 30
#define kBtImageH 30
#define kBtImageTop 5

@interface OrderButton ()
@property (nonatomic,strong) UILabel *countLbale;

@end

@implementation OrderButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _countLbale = [[UILabel alloc] init];
        _countLbale.backgroundColor = [UIColor redColor];
        _countLbale.font = [UIFont systemFontOfSize:11];
        _countLbale.textAlignment = NSTextAlignmentCenter;
        _countLbale.textColor = [UIColor whiteColor];
        [self addSubview:_countLbale];
        
        self.backgroundColor = [UIColor whiteColor];
        self.messageCount = 0;
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _countLbale.center = CGPointMake(self.width / 2 + kBtImageW / 2 - 3, kBtImageTop *2 + 3);
    _countLbale.bounds = CGRectMake(0, 0, 20, 15);
    _countLbale.layer.cornerRadius = 8;
    _countLbale.clipsToBounds = YES;

}

- (void)setMessageCount:(NSInteger)messageCount
{
    _messageCount = messageCount;
    
    if (_messageCount == 0) {
        
        _countLbale.hidden = YES;
    }
    else
    {
        _countLbale.hidden = NO;
    }
    
    if (_messageCount > 99) {
        
        _countLbale.text = [NSString stringWithFormat:@"99+"];
    }
    else
    {
        _countLbale.text = [NSString stringWithFormat:@"%ld",_messageCount];
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (CGRect)imageRectForContentRect:(CGRect)contentRect
{

    CGFloat imageX = self.width / 2 - kBtImageW / 2;
    CGFloat imageY = kBtImageTop;
    CGFloat imageWidth = kBtImageW;
    CGFloat imageHeight = kBtImageH;
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

#pragma mark 调整内部UILabel的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0 ;
    CGFloat titleY = contentRect.size.height - 20;
    CGFloat titleHeight = 18;
    CGFloat titleWidth = contentRect.size.width;


    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}


- (void)setHighlighted:(BOOL)highlighted {
    
}

@end
