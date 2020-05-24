//
//  DetailNormlHearCell.m
//  LoveHome
//
//  Created by MRH-MAC on 15/9/1.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "DetailNormlHearCell.h"

@interface DetailNormlHearCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UILabel *subscribeTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *payOrderTime;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *telePhone;
@property (weak, nonatomic) IBOutlet UILabel *adress;

@end

@implementation DetailNormlHearCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrder:(OrderModel *)order
{
    _order = order;
    _dateLable.text = _order.appointTime;
    _orderNumber.text = _order.orderid;
    _payOrderTime.text = _order.orderTime;
    _userName.text = _order.customerName;
    _telePhone.text = _order.customerTelephone;
    _adress.text = [NSString stringWithFormat:@"收货地址:%@",_order.customerAddress];
}

+ (NSString *)identifier {
    return @"DetailNormlHearCell";
}
@end
