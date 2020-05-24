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
    
    [self signMyUI];
}

- (void)signMyUI
{
    self.orderId.textColor = JXColorHex(0x333333);
    self.orderId.font = RHFontAdap(14);
    [self.orderId mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 20);
        make.height.mas_equalTo(20);
    }];
    
    UIView *spView = [[UIView alloc] init];
    spView.backgroundColor = JXColorHex(0xeeeeee);
    [self.contentView addSubview:spView];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_orderId).offset(30);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo(1);
    }];
    
    self.orderPrice.textColor = JXColorHex(0xff4400);
    self.orderPrice.font = RHFontAdap(14);
    [self.orderPrice mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(spView).offset(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width / 2 - 50);
        make.height.mas_equalTo(20);
    }];
    
    self.orderTime.textColor =JXColorHex(0x999999);
    self.orderTime.font = RHFontAdap(14);
    [self.orderTime mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(spView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width / 2 - 20);
        make.height.mas_equalTo(20);
        
    }];
}

- (void)setInconModel:(IncomDetailModel *)inconModel
{
    _inconModel = inconModel;
    _orderId.text = [NSString stringWithFormat:@"订单号: %@", inconModel.orderId];
    _orderPrice.text = [NSString stringWithFormat:@"￥%.2lf",inconModel.cash];
    _orderTime.text = inconModel.dealDate;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
