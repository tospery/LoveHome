//
//  OrderAddedCell.m
//  LoveHome
//
//  Created by 杨建祥 on 15/8/29.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "OrderAddedCell.h"


@interface OrderAddedCell ()
@property (nonatomic, weak) IBOutlet UILabel *orderidLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *payLabel;

@property (nonatomic, weak) IBOutlet UIButton *rejectButton;
@property (nonatomic, weak) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *selectOrderButton;

@property (nonatomic, copy) OrderAddedCellFuncBlock funcBlock;
@property (nonatomic, copy) OrderAddedCellSelectBlock selectBlock;
@end

@implementation OrderAddedCell

- (void)awakeFromNib {
    // Initialization code
    [self.rejectButton exSetBorder:JXColorHex(0x666666) width:1.0 radius:2];
    [self.acceptButton exSetBorder:JXColorHex(0xff0000) width:1.0 radius:2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupFuncBlock:(OrderAddedCellFuncBlock)funcBlock {
    self.funcBlock = funcBlock;
}

- (void)setupSelectBlock:(OrderAddedCellSelectBlock)selectBlock {
    self.selectBlock = selectBlock;
}

- (void)configOrder:(OrderModel *)order {
    self.orderidLabel.text = [NSString stringWithFormat:@"订单号：%@", order.orderid];
    self.timeLabel.text = order.appointTime;
    self.addressLabel.text = [NSString stringWithFormat:@"收货地址：%@", order.customerAddress];
    self.payLabel.text = [NSString stringWithFormat:@"%@    ¥%.2lf",(order.orderPayDto.payment == 0 ? @"线下支付" : @"线上支付"),order.orderPayDto.totalPrice];
    self.selectOrderButton.selected = order.selected;
}

- (IBAction)checkButtonPressed:(id)sender {
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    
    if (self.selectBlock) {
        self.selectBlock(btn.selected);
    }
}

- (IBAction)funcButtonPressed:(id)sender {
    if (self.funcBlock) {
        self.funcBlock(sender);
    }
}

+ (NSString *)identifier {
    return @"OrderAddedCellIdentifier";
}

+ (CGFloat)height {
    return 174.0f;
}

@end
