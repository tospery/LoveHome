//
//  OrderPayWayCell.m
//  LoveHome
//
//  Created by MRH-MAC on 15/9/2.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "OrderPayWayCell.h"
#define kBaseCellHeight 140



@interface OrderPayWayCell ()
@property (weak, nonatomic) IBOutlet UILabel *credirtsPrice;
@property (weak, nonatomic) IBOutlet UILabel *counponPrice;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *payWayName;
@property (weak, nonatomic) IBOutlet UILabel *apointTime;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;
@property (weak, nonatomic) IBOutlet UIView *payTypeView;

@end

@implementation OrderPayWayCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setOrder:(OrderModel *)order
{
    _order = order;
    _payWayName.text = _order.orderPayDto.payment == 1? @"线上支付" :@"线下支付";
    _apointTime.text = _order.appointTime;
    _payMoney.text = [NSString stringWithFormat:@"￥%.2lf",_order.orderPayDto.payPrice];
    _totalPrice.text = [NSString stringWithFormat:@"￥%.2lf",_order.orderPayDto.totalPrice];
    _counponPrice.text = [NSString stringWithFormat:@"￥%.2lf",_order.orderPayDto.couponPrice];
    _credirtsPrice.text = [NSString stringWithFormat:@"￥%.2lf",_order.orderPayDto.creditsPrice];
    [_payTypeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 多种支付方式
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)getCellHeight:(OrderModel *)order
{
    CGFloat base = kBaseCellHeight;
    
      
    return base;
}

@end
