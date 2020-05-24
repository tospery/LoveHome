//
//  OrderCell.m
//  LoveHome
//
//  Created by 杨建祥 on 15/8/27.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "OrderCommonCell.h"
#import "UIImage+ImageEffects.h"
#define OrderCellHeightBase             (184.0f)
#define OrderCellHeightOffset           (20.0f)

@interface OrderCommonCell ()
@property (nonatomic, weak) IBOutlet UILabel *orderStatusLabel;

@property (nonatomic, weak) IBOutlet UILabel *orderidLabel;
@property (nonatomic, weak) IBOutlet UILabel *somethingLabel;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@property (nonatomic, weak) IBOutlet UILabel *wayLabel;
@property (nonatomic, weak) IBOutlet UIView *payView;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *phoneLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;

@property (nonatomic, weak) IBOutlet UIButton *rejectButton;
@property (nonatomic, weak) IBOutlet UIView *contactView;
@property (nonatomic, weak) IBOutlet UIView *productView;
@property (nonatomic, weak) IBOutlet UIImageView *separatorImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *callPhoeViewTraling;

@property (nonatomic, copy) OrderCommonCellButtonPressedBlock buttonPressedBlock;
@end

@implementation OrderCommonCell

- (void)awakeFromNib {
    // Initialization code
    //[self.payView exCircleWithColor:COLOR_HEX(0xEB161F) border:1.0f];
    [self.contactView exSetBorder:[UIColor lightGrayColor] width:1.0f radius:2.0f];
    [self.rejectButton exSetBorder:[UIColor lightGrayColor] width:1.0f radius:2.0f];
    [self.acceptButton exSetBorder:[UIColor clearColor] width:1.0f radius:2.0f];
    [self.separatorImageView setHidden:YES];
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

- (void)setupButtonPressedBlock:(OrderCommonCellButtonPressedBlock)buttonPressedBlock {
    self.buttonPressedBlock = buttonPressedBlock;
}

- (void)configOrder:(OrderModel *)order type:(OrderType)type {
    if (order.orderDetailList.count > 0) {
        [self.separatorImageView setHidden:NO];
    }else {
        [self.separatorImageView setHidden:YES];
    }
    
    _orderStatusLabel.text = @"";
    [_acceptButton setTitle:@"确认" forState:UIControlStateNormal];
     _acceptButton.enabled = YES;
    
    
    // 新增 未响应(收衣未响应，订单未响应) 已处理
    if (type == OrderTypeAdded || type == OrderTypeUnhandled || type == OrderTypehandled || type == OrderTypeRectClothes) {
        [self.payView setHidden:NO];
        self.amountLabel.text = [NSString stringWithFormat:@"%.2f", order.orderPayDto.totalPrice];
        self.wayLabel.text = order.orderPayDto.payment == 0 ? @"线下支付" : @"线上支付";
        
        NSString *opptionTime =  JudgeContainerCountIsNull(order.appointTime) ? @"":order.appointTime;
        self.somethingLabel.text = [NSString stringWithFormat:@"预约取货时间：%@", opptionTime];
        
        if (type == OrderTypehandled) {
            _rejectButton.hidden = YES;
            _acceptButton.hidden = YES;
            _callPhoeViewTraling.constant = SCREEN_WIDTH - 92;
            
        }
        else
        {
            _rejectButton.hidden = NO;
            _acceptButton.hidden = NO;
            _callPhoeViewTraling.constant = 12;
        }

    }
        // 已完成
    else if (type == OrderTypeFinished) {
        // self.somethingLabel.text = [NSString stringWithFormat:@"预约取货时间：%@", order.appointTime];
        [self.payView setHidden:YES];
    }else {
        // self.somethingLabel.text = [NSString stringWithFormat:@"预约取货时间：%@", order.appointTime];
        [self.payView setHidden:YES];
    }
    
    if (type == OrderTypeRectClothes)
    {
        [_acceptButton setTitle:@"确认收衣" forState:UIControlStateNormal];
        [_acceptButton setTitle:@"等待确认" forState:UIControlStateDisabled];
        [_acceptButton setBackgroundImage:[UIImage creatImageWithColor:[UIColor darkGrayColor] andSize:_acceptButton.size] forState:UIControlStateDisabled];
        _acceptButton.enabled = !order.collectedByMerchant;
        
    }
    
    if (type == OrderTypeUnhandled || order.status == 12) {
        
        _orderStatusLabel.text = order.status == 12 ? @"收衣未响应" : @"新增未响应";
        
    }

    
    self.orderidLabel.text = [NSString stringWithFormat:@"订单号：%@", order.orderid];
    self.nameLabel.text = order.customerName;
    self.phoneLabel.text = order.customerTelephone;
    self.addressLabel.text = order.customerAddress;
    
    for (int i = 0; i < order.orderDetailList.count; ++i) {
        OrderDetailModel *detail = order.orderDetailList[i];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self.productView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.productView);
            make.top.equalTo(self.productView).offset(i * 20 + 4);
            make.trailing.equalTo(self.productView);
            make.height.equalTo(@20);
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.backgroundColor = [UIColor whiteColor];
        nameLabel.textColor = JXColorHex(0x666666);
        nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        nameLabel.text = [NSString stringWithFormat:@"%@ %@",detail.productName,detail.specName];
        [view addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(view).offset(12.0f);
            make.top.equalTo(view);
            make.bottom.equalTo(view);
        }];
        
        UILabel *countLabel = [[UILabel alloc] init];
        countLabel.backgroundColor = [UIColor whiteColor];
        countLabel.textColor = JXColorHex(0x666666);
        countLabel.font = [UIFont systemFontOfSize:14.0f];
        countLabel.text = [NSString stringWithFormat:@"%ld件", (long)detail.count];
        [view addSubview:countLabel];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(view).offset(-8.0f);
            make.top.equalTo(view);
            make.bottom.equalTo(view);
        }];
    }
}

+ (NSString *)identifier {
    return @"OrderCommonCellIdentifier";
}

+ (CGFloat)heightForOrder:(OrderModel *)order {
    CGFloat height = OrderCellHeightBase;
    if (order.orderDetailList.count > 0) {
        height += order.orderDetailList.count * OrderCellHeightOffset + 8;
    }
    return height;
}

@end
