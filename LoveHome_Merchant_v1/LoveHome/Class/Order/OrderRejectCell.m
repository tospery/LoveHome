//
//  OrderRejectCell.m
//  LoveHome
//
//  Created by 杨建祥 on 15/8/28.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "OrderRejectCell.h"

@interface OrderRejectCell ()
@property (nonatomic, weak) IBOutlet UILabel *orderidLabel;
@property (nonatomic, weak) IBOutlet UILabel *somethingLabel;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@property (nonatomic, weak) IBOutlet UILabel *wayLabel;
@property (nonatomic, weak) IBOutlet UIView *payView;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *phoneLabel;
@property (nonatomic, weak) IBOutlet UILabel *reasonLabel;

@property (nonatomic, weak) IBOutlet UIView *contactView;
@property (nonatomic, copy) OrderRejectCellButtonPressedBlock buttonPressedBlock;
@end

@implementation OrderRejectCell

- (void)awakeFromNib {
    // Initialization code
    [self.contactView exSetBorder:[UIColor lightGrayColor] width:1.0f radius:2.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonPressed:(id)sender {
    if (self.buttonPressedBlock) {
        self.buttonPressedBlock(sender);
    }
}

- (void)setupButtonPressedBlock:(OrderRejectCellButtonPressedBlock)buttonPressedBlock {
    self.buttonPressedBlock = buttonPressedBlock;
}

- (void)configOrder:(OrderModel *)order {
    self.orderidLabel.text = [NSString stringWithFormat:@"订单号：%@", order.orderid];
    self.amountLabel.text = [NSString stringWithFormat:@"%.2f", order.orderPayDto.totalPrice];
    self.wayLabel.text = order.orderPayDto.payment == 0 ? @"线下支付" : @"线上支付";
    self.somethingLabel.text = [NSString stringWithFormat:@"拒绝时间：%@", order.rejectTime];
    
    self.nameLabel.text = order.customerName;
    self.phoneLabel.text = order.customerTelephone;
    self.reasonLabel.text = [NSString stringWithFormat:@"拒绝理由：%@", order.servingRemark];
}

+ (NSString *)identifier {
    return @"OrderRejectCellIdentifier";
}

+ (CGFloat)heightForOrder:(OrderModel *)order {
    CGFloat height = 155.0f;
    NSString *reason = [NSString stringWithFormat:@"拒绝理由：%@", order.servingRemark];
    if (reason.length != 0) {
        CGSize size = [reason exSizeWithFont:[UIFont systemFontOfSize:13.0f] width:(kJXMetricScreenWidth - 12 - 8)];
        height += size.height;
    }
    return height;
}
@end
