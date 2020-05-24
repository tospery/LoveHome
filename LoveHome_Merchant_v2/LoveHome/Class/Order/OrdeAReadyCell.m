//
//  OrdeAReadyCell.m
//  LoveHome
//
//  Created by MRH-MAC on 15/9/1.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "OrdeAReadyCell.h"
#import "LHStarView.h"
@interface OrdeAReadyCell ()

@property (weak, nonatomic) IBOutlet UILabel *reciveOrderTime;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLbale;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLbale;
@property (weak, nonatomic) IBOutlet UILabel *orderAppoinTime;
@property (weak, nonatomic) IBOutlet LHStarView *starLeveView;
@property (weak, nonatomic) IBOutlet UILabel *commentLable;
@property (weak, nonatomic) IBOutlet UILabel *customeName;
@property (weak, nonatomic) IBOutlet UILabel *customTelephone;
@property (weak, nonatomic) IBOutlet UILabel *adress;


@end

#pragma mark - 已完成订单
@implementation OrdeAReadyCell

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
    _reciveOrderTime.text = _orderDetail.receiptTime;
    _orderIdLbale.text = _orderDetail.orderid;
    _orderTimeLbale.text = _orderDetail.orderTime;
    _orderAppoinTime.text = [NSString stringWithFormat:@"预约上门时间:  %@",_orderDetail.appointTime];
    if (![orderDetail.content isEqual:[NSNull null]]) {
    _commentLable.text = [NSString stringWithFormat:@"  %@", _orderDetail.content];
    } else {
        _commentLable.text = @"  暂无评论";
    }
    _customeName.text = [NSString stringWithFormat:@"客户姓名: %@", _orderDetail.customerName];
    _customTelephone.text = [NSString stringWithFormat:@"客户电话: %@", _orderDetail.customerTelephone];
    _adress.text = [NSString stringWithFormat:@"收货地址: %@", _orderDetail.customerAddress];
    _starLeveView.level = _orderDetail.attitude;
    [_starLeveView loadData];
}

+(CGFloat )heightForOrder:(OrderModel *)order
{
    return 250;
}

+(NSString *)identifier
{
    return @"OrdeAReadyCell";
}

@end
