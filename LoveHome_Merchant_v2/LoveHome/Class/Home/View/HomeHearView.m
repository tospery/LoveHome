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
    UIView *tooBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0/*self.height/2 */)];
    tooBar.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLalbe = [[UILabel alloc] init];
    titleLalbe.font = [UIFont systemFontOfSize:15];
    titleLalbe.textColor = [UIColor redColor];
    titleLalbe.text = @"新增订单";
        
    UIButton *button = [[UIButton alloc] init];
   // button.backgroundColor = JXColorHex(0xf03838);
    [button setTitle:@"批量收衣" forState:UIControlStateNormal];
    [button setTitleColor:JXColorHex(0xff4400) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.layer.cornerRadius = 4;
    [button addTarget:self action:@selector(acceptOrder:)forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark - 全选laebl
    UILabel *allSelectedLabel = [[UILabel alloc] init];
    allSelectedLabel.frame = CGRectMake(45, button.frame.size.height + 45, 50, 15);
    allSelectedLabel.text = @"全选";
    allSelectedLabel.font = [UIFont systemFontOfSize:15];
    allSelectedLabel.textAlignment = NSTextAlignmentLeft;
    allSelectedLabel.textColor = JXColorHex(0x666666);
    
#pragma mark - 全选按钮
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

//    [tooBar addSubview:titleLalbe];
//    [self addSubview:_allReciveOrderBtn];
//    [self addSubview:allSelectedLabel];
//    [self addSubview:button];
//    [self addSubview:bottomLine];
    
    
//    [titleLalbe mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(tooBar.mas_centerY);
//        make.leading.equalTo(@10);
//        make.width.equalTo(@100);
//        make.height.equalTo(@20);
//    }];
    
    
//    [_allReciveOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(@(-5));
////#warning 预留
////        make.left.mas_equalTo(10);
//        make.leading.equalTo(@12);
//        make.size.mas_equalTo(CGSizeMake(25, 25));
//        
////        make.centerY.equalTo(tooBar.mas_centerY);
////        make.trailing.equalTo(@-22);
////        make.size.mas_equalTo(CGSizeMake(25, 25));
//    }];
    
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(@(-5));
//        make.trailing.equalTo(@(-10));
//        make.size.mas_equalTo(CGSizeMake(65, 25));
//        
////        make.centerY.equalTo(tooBar.mas_centerY);
////        make.trailing.equalTo(allSelectButton.mas_leading).offset(-5);
////        make.size.mas_equalTo(CGSizeMake(65, 25));
//    }];
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
