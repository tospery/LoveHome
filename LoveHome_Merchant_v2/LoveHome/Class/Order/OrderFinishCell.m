//
//  OrderFinishCell.m
//  LoveHome
//
//  Created by 杨建祥 on 15/8/28.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "OrderFinishCell.h"


@interface OrderFinishCell ()
//订单号
@property (nonatomic, weak) IBOutlet UILabel *orderidLabel;
//收货时间
@property (nonatomic, weak) IBOutlet UILabel *somethingLabel;
//付款金额
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
//付款方式
@property (nonatomic, weak) IBOutlet UILabel *wayLabel;
//付款view
@property (nonatomic, weak) IBOutlet UIView *payView;
//客户姓名
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *commitCustomerLabel;

@property (nonatomic, strong) UILabel *customName;
//评论
@property (nonatomic, weak) IBOutlet UILabel *commentLabel;
//星
@property (nonatomic, weak) IBOutlet LHStarView *starView;
//联系客户
@property (nonatomic, weak) IBOutlet UIView *contactView;
@property (strong, nonatomic) IBOutlet UIView *allView;
@property (strong, nonatomic) IBOutlet UIView *buttonView;

@property (nonatomic, strong) UILabel *phoneLabel;


@property (nonatomic, copy) OrderFinishCellButtonPressedBlock buttonPressedBlock;
@end

@implementation OrderFinishCell
#pragma mark - 已完成
- (void)awakeFromNib {
    // Initialization code
    
    [self resetUI];
    [self.contactView exSetBorder:JXColorHex(0xff4400) width:1.0f radius:2.0f];
    
    self.starView.level = 0;
    self.starView.enabled = NO;
    [self.starView loadData];
}

#pragma mark - 重写UI
- (void)resetUI
{
    //总视图
    [self.contentView addSubview:_allView];
    [_allView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.contentView).offset(10);
        make.left.mas_equalTo(self.contentView).offset(0);
        make.right.mas_equalTo(self.contentView).offset([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo(250);
    }];
    //订单号
    _orderidLabel.textColor = JXColorHex(0x666666);
    _orderidLabel.font = [UIFont systemFontOfSize:14];
    [_allView addSubview:_orderidLabel];
    [_orderidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.allView).offset(10);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(20);
        
    }];
    //第一条分割线
    UIView *spView0 = [[UIView alloc] init];
    spView0.backgroundColor = JXColorHex(0xcccccc);
    //测试用
    //spView1.backgroundColor = [UIColor redColor];
    [self.allView addSubview:spView0];
    
    [spView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_orderidLabel).offset(30);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    //订单状态label
    UILabel *orderStatusLabel = [[UILabel alloc] init];
    orderStatusLabel.text = @"已完成";
    orderStatusLabel.font = [UIFont systemFontOfSize:14];
    orderStatusLabel.textColor = JXColorHex(0xff4400);
    orderStatusLabel.textAlignment = NSTextAlignmentRight;
    [self.allView addSubview:orderStatusLabel];
    [orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(_orderidLabel);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo(150);
    }];

    
    //预约取货时间label
    
    _somethingLabel.textColor = JXColorHex(0x666666);
    _somethingLabel.font = [UIFont systemFontOfSize:14];
    [self.allView addSubview:_somethingLabel];
    [_somethingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(spView0).offset(10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(20);
    }];
    
    
    //用户信息View
    
//    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.mas_equalTo(spView1).offset(1);
//        make.left.mas_equalTo(self.contentView).offset(0);
//        make.right.mas_equalTo(self.contentView).offset([UIScreen mainScreen].bounds.size.width);
//        make.height.mas_equalTo(90);
//        
//    }];
    //客户姓名提示label
    UILabel *namePromptLabel = [[UILabel alloc] init];
    namePromptLabel.text = @"客户姓名:  ";
    namePromptLabel.font = [UIFont systemFontOfSize:14];
    namePromptLabel.textColor = JXColorHex(0x666666);
    [self.allView addSubview:namePromptLabel];
    
    [namePromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_somethingLabel).offset(30);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(20);
    }];
    
    //客户姓名label
    _nameLabel.textColor = JXColorHex(0x666666);
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [_allView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_somethingLabel).offset(30);
        make.left.mas_equalTo(namePromptLabel).offset(65);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    //电话号码label
    self.phoneLabel = [[UILabel alloc] init];
    _phoneLabel.font = [UIFont systemFontOfSize:14];
    _phoneLabel.textColor = JXColorHex(0x666666);
    _phoneLabel.textAlignment = NSTextAlignmentRight;
    //_phoneLabel.backgroundColor = [UIColor blueColor];
    [self.allView addSubview:_phoneLabel];
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_somethingLabel).offset(30);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(20);
    }];
    
    //电话号码文字label
    
//    UILabel *phonePromptLabel = [[UILabel alloc] init];
//    phonePromptLabel.text = @"客户电话:";
//    phonePromptLabel.font = [UIFont systemFontOfSize:14];
//    phonePromptLabel.textColor = JXColorHex(0x666666);
//    [self.allView addSubview:phonePromptLabel];
//    
//    [phonePromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.mas_equalTo(_somethingLabel).offset(30);
//        make.right.mas_equalTo(_phoneLabel).offset(-85);
//        make.width.mas_equalTo(65);
//        make.height.mas_equalTo(20);
//    }];
    
    //付款金额 以及 付款方式
    _amountLabel.font = [UIFont systemFontOfSize:18];
    [_allView addSubview:_amountLabel];
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_nameLabel).offset(25);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(25);
    }];
    
    _wayLabel.font = [UIFont systemFontOfSize:14];
    [_allView addSubview:_wayLabel];
    
    [_wayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_nameLabel).offset(27);
        make.left.mas_equalTo(_amountLabel).offset(80);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
        //第一条分割线
        UIView *spView1 = [[UIView alloc] init];
        spView1.backgroundColor = JXColorHex(0xeeeeee);
        //测试用
        //spView1.backgroundColor = [UIColor redColor];
        [self.allView addSubview:spView1];
    
        [spView1 mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.top.mas_equalTo(_wayLabel).offset(30);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    
        _customName = [[UILabel alloc] init];
    
        _customName.font = [UIFont systemFontOfSize:14];
        _customName.textColor = JXColorHex(0x666666);
        [self.allView addSubview:_customName];
    
        [_customName mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.top.mas_equalTo(spView1).offset(10);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(65);
            make.height.mas_equalTo(20);
        }];
    
        //_commentLabel.backgroundColor = [UIColor blueColor];
        [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(_customName).offset(30);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(self.contactView).offset(-15);
            make.height.mas_equalTo(20);
        }];
    
      [_allView addSubview:_starView];
      [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
         
          make.top.mas_equalTo(spView1).offset(10);
          make.right.mas_equalTo(self.contentView).offset(-15);
          make.height.mas_equalTo(20);
      }];
    
    //第一条分割线
    UIView *spView2 = [[UIView alloc] init];
    spView2.backgroundColor = JXColorHex(0xeeeeee);
    //测试用
    //spView1.backgroundColor = [UIColor redColor];
    [self.allView addSubview:spView2];
    
    [spView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_commentLabel).offset(30);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];

    _commitCustomerLabel.textColor = JXColorHex(0xff4400);
    //_buttonView.backgroundColor = [UIColor yellowColor];
    [_allView addSubview:_buttonView];
    [_buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_commentLabel).offset(31);
        make.left.mas_equalTo(self.contentView).offset(0);
        make.right.mas_equalTo(self.contentView).offset([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo(50);
    }];
    
    [_buttonView addSubview:_contactView];
    [_contactView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(spView2).offset(11);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(self.contentView).offset(-15);
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

- (void)setupButtonPressedBlock:(OrderFinishCellButtonPressedBlock)buttonPressedBlock {
    self.buttonPressedBlock = buttonPressedBlock;
}

- (void)configOrder:(OrderModel *)order {
    self.orderidLabel.text = [NSString stringWithFormat:@"订单号：%@", order.orderid];
    self.amountLabel.text = [NSString stringWithFormat:@"¥%.2f", order.orderPayDto.totalPrice];
    self.wayLabel.text = order.orderPayDto.payment == 0 ? @"线下支付" : @"线上支付";
    self.somethingLabel.text = [NSString stringWithFormat:@"收货时间：%@",order.receiptTime];
    
    self.nameLabel.text = order.customerName;
    self.customName.text = order.customerName;
    
    self.phoneLabel.text = [NSString stringWithFormat:@"客户电话: %@", order.customerTelephone];
    NSArray *attArr = @[@"0",@"1",@"2",@"3",@"4",@"5"];
    NSString *att = [NSString stringWithFormat:@"%ld",(long)order.attitude];
    if (![attArr containsObject:att]) {
        self.starView.hidden = YES;
        UILabel *warn = [[UILabel alloc] init];
         warn.text = @"暂无星级评分";
        warn.textColor = JXColorHex(0x666666);
        warn.textAlignment = NSTextAlignmentRight;
        warn.font = [UIFont systemFontOfSize:14];
        warn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 115, 150, 100, 20);
        [self.allView addSubview:warn];
              //[self.starView bringSubviewToFront:warn];
    } else {
        self.starView.hidden = NO;
        self.starView.level = order.attitude;

        
    }
    
    [self.starView loadData];
    NSLog(@"评论 == %@", order.content);
    if ([order.content isEqual: @""]) {
        self.commentLabel.text = @"暂无评论";
    } else {
     self.commentLabel.text = order.content;
    }
    
}

+ (NSString *)identifier {
    return @"OrderFinishCellIdentifier";
}

+ (CGFloat)heightForOrder:(OrderModel *)order {
    CGFloat height = 270.0f;
    if (order.content.length != 0) {
        CGSize size = [order.content exSizeWithFont:[UIFont systemFontOfSize:13.0f] width:(kJXMetricScreenWidth - 12 - 8)];
        height += size.height;
    }
    return height;
}
@end
