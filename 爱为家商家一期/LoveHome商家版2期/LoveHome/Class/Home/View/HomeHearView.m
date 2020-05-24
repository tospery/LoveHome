//
//  HomeHearView.m
//  LoveHome
//
//  Created by MRH-MAC on 15/8/26.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "HomeHearView.h"

@implementation HomeHearView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews
{
    
    OrderButton *button1 = [[OrderButton alloc] init];
    button1.frame = CGRectMake(0, 0, SCREEN_WIDTH/3,65);
    [button1 addTarget:self action:@selector(waittingOrder:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitle:@"未响应订单" forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"首页01"] forState:UIControlStateNormal];
    self.waitingButton = button1;
    [self addSubview:button1];
    
    
    OrderButton *button2 = [[OrderButton alloc] init];
    button2.frame = CGRectMake(SCREEN_WIDTH/3, 0, button1.width,65);
     [button2 addTarget:self action:@selector(orderList:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitle:@"订单列表" forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"首页02"] forState:UIControlStateNormal];
    self.orderListButton = button2;
    [self addSubview:button2];
    
    OrderButton *button3 = [[OrderButton alloc] init];
    button3.frame = CGRectMake(SCREEN_WIDTH/3 *2, 0, button1.width, 65);
     [button3 addTarget:self action:@selector(orderDetail:) forControlEvents:UIControlEventTouchUpInside];
    [button3 setTitle:@"收入明细" forState:UIControlStateNormal];
    [button3 setImage:[UIImage imageNamed:@"首页03"] forState:UIControlStateNormal];
    self.orderDetailButton = button3;
    [self addSubview:button3];
    
    
    for (int i = 1; i<3; i++) {
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(self.width / 3 *i , 5, 0.5, 55)];
        line.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:line];
    }
       UIView *tooBar = [[UIView alloc] initWithFrame:CGRectMake(0, _orderDetailButton.height + 10, self.width, 40)];
    tooBar.backgroundColor = [UIColor whiteColor];
    UILabel *titleLalbe = [[UILabel alloc] init];
    titleLalbe.font = [UIFont systemFontOfSize:13];
    titleLalbe.text = @"新增订单";
    
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor =JXColorHex(0xf03838);
    [button setTitle:@"批量接单" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.layer.cornerRadius = 4;
    [button addTarget:self action:@selector(acceptOrder:)forControlEvents:UIControlEventTouchUpInside];    
    
    UIButton *allSelectButton = [[UIButton alloc] init];
    [allSelectButton setImage:[UIImage imageNamed:@"ic_check_normal"] forState:UIControlStateNormal];
    [allSelectButton setImage:[UIImage imageNamed:@"home_add_checked"] forState:UIControlStateSelected];
    [allSelectButton addTarget:self action:@selector(selectAllOrders:) forControlEvents:UIControlEventTouchUpInside];
    self.allReciveOrderBtn = allSelectButton;

    UILabel *bottomLine = [[UILabel alloc] init];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    bottomLine.alpha = 0.5;
    bottomLine.height = 0.5;
    bottomLine.width = self.width;
    bottomLine.x = 0;
    bottomLine.y = self.height - 0.5;

    [self addSubview:tooBar];
    [tooBar addSubview:button];
    [tooBar addSubview:titleLalbe];
    [self addSubview:_allReciveOrderBtn];
    [self addSubview:bottomLine];
    
    
    [titleLalbe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tooBar.mas_centerY);
        make.leading.equalTo(@10);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    
    [_allReciveOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tooBar.mas_centerY);
        make.trailing.equalTo(@-22);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tooBar.mas_centerY);
        make.trailing.equalTo(allSelectButton.mas_leading).offset(-5);
        make.size.mas_equalTo(CGSizeMake(65, 25));
    }];
    
   
    

}

- (void)waittingOrder:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(homeHearViewDeleageWaittingOrder:)] )
    {
        [_delegate homeHearViewDeleageWaittingOrder:sender];
    }
}

- (void)orderList:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(homeHearViewDeleageOrderList:)] )
    {
        [_delegate homeHearViewDeleageOrderList:sender];
    }

}

- (void)orderDetail:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(homeHearViewDeleageOrderDetail:)] )
    {
        [_delegate homeHearViewDeleageOrderDetail:sender];
    }
}


- (void)acceptOrder:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(homeHearViewDeleageAcceptBatchOrders:)]) {
        [_delegate homeHearViewDeleageAcceptBatchOrders:sender];
    }
}

- (void)selectAllOrders:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(homeHearViewDeleageSelectAll:)]) {
        [_delegate homeHearViewDeleageSelectAll:sender];
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
