//
//  OrderRejectViewCell.m
//  LoveHome
//
//  Created by MRH-MAC on 15/9/1.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "OrderRejectViewCell.h"

@interface OrderRejectViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *rejectContent;
@property (weak, nonatomic) IBOutlet UILabel *rejectDate;
@property (weak, nonatomic) IBOutlet UILabel *orderId;
@property (weak, nonatomic) IBOutlet UILabel *orderCommitTime;
@property (weak, nonatomic) IBOutlet UILabel *orderAppoiTime;
@property (weak, nonatomic) IBOutlet UILabel *customName;
@property (weak, nonatomic) IBOutlet UILabel *customTelePhone;
@property (weak, nonatomic) IBOutlet UILabel *adress;



@end


@implementation OrderRejectViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setOrderDetail:(OrderModel *)orderDetail
{
    _orderDetail = orderDetail;
    _rejectContent.text = [NSString stringWithFormat:@"拒绝理由:%@",_orderDetail.servingRemark];
    _rejectDate.text =  [NSString stringWithFormat:@"拒绝时间:%@", _orderDetail.rejectTime] ;
    _orderId.text = _orderDetail.orderid;
    _orderCommitTime.text = _orderDetail.orderTime;
//    _orderAppoiTime.text = [NSString stringWithFormat:@"预约上门时间:%@",_orderDetail.appointTime];
    _customName.text = _orderDetail.customerName;
    _customTelePhone.text = _orderDetail.customerTelephone;
    _adress.text = _orderDetail.customerAddress;
}

+(NSString *)identifier
{
    return @"OrderRejectViewCell";
}

// 基础高度161
+(CGFloat)heightWithOrder:(OrderModel *)order
{
    
    // 初始lable高度为0
    CGFloat baseheight = 161;
    
    NSString *rejectContent = [NSString stringWithFormat:@"拒绝理由:%@",order.servingRemark];
    CGFloat height = [rejectContent stringContetenSizeWithFount:[UIFont systemFontOfSize:14] andSize:CGSizeMake(SCREEN_WIDTH - 18, 100000)].size.height;
    
    baseheight += height;
    
    CGFloat height2 = [order.customerAddress stringContetenSizeWithFount:[UIFont systemFontOfSize:14] andSize:CGSizeMake(SCREEN_WIDTH - 18, 100000)].size.height;
    
    baseheight +=height2;
    return baseheight;

}
@end
