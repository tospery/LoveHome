//
//  OrderRejectViewCell.m
//  LoveHome
//
//  Created by MRH-MAC on 15/9/1.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "OrderRejectViewCell.h"

@interface OrderRejectViewCell ()
/**
 * @prama 拒绝时间
 **/
@property (weak, nonatomic) IBOutlet UILabel *rejectDate;
/**
 * @prama 订单号
 **/
@property (weak, nonatomic) IBOutlet UILabel *orderId;
/**
 * @prama 下单时间
 **/
@property (weak, nonatomic) IBOutlet UILabel *orderCommitTime;
/**
 * @prama 预约取货时间
 **/
@property (weak, nonatomic) IBOutlet UILabel *orderAppoiTime;
/**
 * @prama 客户姓名
 **/
@property (weak, nonatomic) IBOutlet UILabel *customName;
/**
 * @prama 客户电话
 **/
@property (weak, nonatomic) IBOutlet UILabel *customTelePhone;
/**
 * @prama 收货地址
 **/
@property (weak, nonatomic) IBOutlet UILabel *adress;
/**
 * @prama 分割线
 **/
@property (strong, nonatomic) IBOutlet UIView *spView;



@end


@implementation OrderRejectViewCell

- (void)awakeFromNib {
    // Initialization code
    [self playMyUI];
}
- (void)playMyUI
{
    //取消时间
    _rejectDate.textColor = JXColorHex(0x666666);
    _rejectDate.font = [UIFont systemFontOfSize:14];
    [self.rejectDate mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 20);
        make.height.mas_equalTo(20);
        
    }];
    //订单号
    _orderId.textColor = JXColorHex(0x666666);
    _orderId.font = [UIFont systemFontOfSize:14];
    [self.orderId mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_rejectDate).offset(30);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 20);
        make.height.mas_equalTo(20);

    }];
    //下单时间
    _orderCommitTime.textColor = JXColorHex(0x666666);
    _orderCommitTime.font =[UIFont systemFontOfSize:14];
    [self.orderCommitTime mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_orderId).offset(30);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 20);
        make.height.mas_equalTo(20);
    }];
    //预约上门时间
    _orderAppoiTime.textColor = JXColorHex(0x666666);
    _orderAppoiTime.font = [UIFont systemFontOfSize:14];
    [self.orderAppoiTime mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_orderCommitTime).offset(30);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 20);
        make.height.mas_equalTo(20);
    }];
    //分割线
    self.spView.backgroundColor = JXColorHex(0xeeeeee);
    [self.spView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_orderAppoiTime).offset(30);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo(1);
    }];
    //客户姓名
    _customName.textColor = JXColorHex(0x666666);
    _customName.font = [UIFont systemFontOfSize:14];
    [self.customName mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_spView).offset(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width / 2 - 20);
        make.height.mas_equalTo(20);

    }];
    //客户电话
    _customTelePhone.textColor = JXColorHex(0x666666);
    _customTelePhone.font = [UIFont systemFontOfSize:14];
    [self.customTelePhone mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_spView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width / 2 - 10);
        make.height.mas_equalTo(20);
    }];
    //收货地址
    _adress.textColor = JXColorHex(0x666666);
    _adress.font = [UIFont systemFontOfSize:14];
    _adress.numberOfLines = 2;
    _adress.textAlignment = NSTextAlignmentLeft;
    [self.adress mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_customName).offset(25);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 20);
        make.height.mas_equalTo(40);
    }];
}
- (void)setOrderDetail:(OrderModel *)orderDetail
{
    _orderDetail = orderDetail;
    _rejectDate.text =  [NSString stringWithFormat:@"取消时间: %@", _orderDetail.rejectTime] ;
    _orderId.text = [NSString stringWithFormat:@"订单号: %@", _orderDetail.orderid];
    _orderCommitTime.text = [NSString stringWithFormat:@"下单时间: %@", _orderDetail.orderTime];
    _orderAppoiTime.text = [NSString stringWithFormat:@"预约上门时间:%@",_orderDetail.appointTime];
    _customName.text = [NSString stringWithFormat:@"客户姓名: %@", _orderDetail.customerName];
    _customTelePhone.text = [NSString stringWithFormat:@"客户电话: %@", _orderDetail.customerTelephone];
    _adress.text = [NSString stringWithFormat:@"收货地址: %@", _orderDetail.customerAddress];
}

+(NSString *)identifier
{
    return @"OrderRejectViewCell";
}

// 基础高度161
+(CGFloat)heightWithOrder:(OrderModel *)order
{
    // 初始lable高度为0
    CGFloat baseheight = 190;
    CGFloat height2 = [order.customerAddress stringContetenSizeWithFount:[UIFont systemFontOfSize:14] andSize:CGSizeMake(SCREEN_WIDTH - 18, 100000)].size.height;
    
    baseheight +=height2;
    return baseheight;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
