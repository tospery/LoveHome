//
//  OrderRejectCell.m
//  LoveHome
//
//  Created by 杨建祥 on 15/8/28.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "OrderRejectCell.h"

@interface OrderRejectCell ()


//大试图
@property (strong, nonatomic) IBOutlet UIView *allView;
//订单号
@property (nonatomic, weak) IBOutlet UILabel *orderidLabel;
//订单状态
@property (strong, nonatomic) IBOutlet UILabel *orderStatusLabel;
//拒绝时间
@property (nonatomic, weak) IBOutlet UILabel *somethingLabel;
//付款金额
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
//付款方式
@property (nonatomic, weak) IBOutlet UILabel *wayLabel;
//客户姓名
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
//客户电话
@property (nonatomic, weak) IBOutlet UILabel *phoneLabel;
//电话图标 + 联系客户文字label + 透明按钮
@property (nonatomic, weak) IBOutlet UIView *contactView;
@property (strong, nonatomic) IBOutlet UIImageView *icoImageView;

@property (strong, nonatomic) IBOutlet UILabel *connectionLabel;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;

@property (nonatomic, copy) OrderRejectCellButtonPressedBlock buttonPressedBlock;
@end

@implementation OrderRejectCell

- (void)awakeFromNib {
    // Initialization code
    [self.contactView exSetBorder:[UIColor lightGrayColor] width:1.0f radius:2.0f];
    
    [self resetUpUI];
}

- (void)resetUpUI
{
    //大试图
    _allView.backgroundColor = [UIColor whiteColor];
   [_allView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.mas_equalTo(self.contentView).offset(10);
       make.left.mas_equalTo(self.contentView).offset(0);
       make.right.mas_equalTo(self.contentView).offset([UIScreen mainScreen].bounds.size.width);
       make.height.mas_equalTo(190);
   }];
    //订单号
    _orderidLabel.font = [UIFont systemFontOfSize:14];
    _orderidLabel.textColor = JXColorHex(0x666666);
    [_orderidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.allView).offset(10);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(20);
        
    }];
    //订单状态
    _orderStatusLabel.font = [UIFont systemFontOfSize:14];
    _orderStatusLabel.textColor = JXColorHex(0xff4400);
    _orderStatusLabel.textAlignment = NSTextAlignmentRight;
    [_orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.allView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
        
    }];
    //分割线
    
    UIView *spView1 = [[UIView alloc] init];
    spView1.backgroundColor = JXColorHex(0xeeeeee);
    [self.allView addSubview:spView1];
    
    [spView1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.allView).offset(39);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo(1);
        
    }];
    //拒绝时间
    
    _somethingLabel.textColor = JXColorHex(0x666666);
    _somethingLabel.font = [UIFont systemFontOfSize:14];
    [_somethingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(spView1).offset(10);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 30);
        make.height.mas_equalTo(20);
        
    }];
    
    //客户姓名
    _nameLabel.textColor = JXColorHex(0x666666);
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_somethingLabel).offset(30);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(20);

        
    }];
    //电话号码
    _phoneLabel.textColor = JXColorHex(0x666666);
    _phoneLabel.font = [UIFont systemFontOfSize:14];
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_somethingLabel).offset(30);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(20);
    }];
    //付款金额
    
    _amountLabel.textColor = JXColorHex(0xff4400);
    _amountLabel.font = [UIFont systemFontOfSize:16];
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_nameLabel).offset(30);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
        
    }];
    
    //支付方式
    _wayLabel.textColor = JXColorHex(0xff4400);
    _wayLabel.font = [UIFont systemFontOfSize:14];
    [_wayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_nameLabel).offset(30);
        make.left.mas_equalTo(_amountLabel).offset(100);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
        
    }];
    
    UIView *spView2 = [[UIView alloc] init];
    spView2.backgroundColor = JXColorHex(0xeeeeee);
    [_allView addSubview:spView2];
    [spView2 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_wayLabel).offset(30);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo(1);
        
    }];
   
    _contactView.layer.borderColor = JXColorHex(0xff4400).CGColor;
    [_contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(spView2).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(30);
    }];
    
    _icoImageView.frame = CGRectMake(5, 8, 15, 15);
    _connectionLabel.frame = CGRectMake(25, 5, 60, 20);
    _connectionLabel.textColor = JXColorHex(0xff4400);
    
    [self.contactView addSubview:_clearButton];
    _clearButton.backgroundColor = [UIColor clearColor];
    [_clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(spView2).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(30);
        
    }];

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
    self.amountLabel.text = [NSString stringWithFormat:@"¥%.2f", order.orderPayDto.totalPrice];
    self.wayLabel.text = order.orderPayDto.payment == 0 ? @"线下支付" : @"线上支付";
    self.somethingLabel.text = [NSString stringWithFormat:@"取消时间：%@", order.rejectTime];
    
    self.nameLabel.text = [NSString stringWithFormat:@"客户姓名: %@",order.customerName];
    self.phoneLabel.text = [NSString stringWithFormat:@"客户电话: %@", order.customerTelephone];
    
}

+ (NSString *)identifier {
    return @"OrderRejectCellIdentifier";
}

+ (CGFloat)heightForOrder:(OrderModel *)order {
    CGFloat height = 200.0f;
//    NSString *reason = [NSString stringWithFormat:@"拒绝理由：%@", order.servingRemark];
//    if (reason.length != 0) {
//        CGSize size = [reason exSizeWithFont:[UIFont systemFontOfSize:13.0f] width:(kJXMetricScreenWidth - 12 - 8)];
//        height += size.height;
//    }
    return height;
}
@end
