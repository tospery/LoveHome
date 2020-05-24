//
//  IncomTableViewCell.m
//  LoveHome
//
//  Created by MRH-MAC on 15/8/28.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "IncomTableViewCell.h"
#import "IncomDetailModel.h"
@interface IncomTableViewCell ()


@property (weak, nonatomic) IBOutlet UILabel *orderId;

@property (weak, nonatomic) IBOutlet UILabel *orderPrice;

@property (weak, nonatomic) IBOutlet UILabel *orderTime;

@end

@implementation IncomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInconModel:(IncomDetailModel *)inconModel
{
    _inconModel = inconModel;
    _orderId.text = inconModel.orderId;
    _orderPrice.text = [NSString stringWithFormat:@"￥%.2lf",inconModel.cash];
    _orderTime.text = inconModel.dealDate;
    
}

@end
