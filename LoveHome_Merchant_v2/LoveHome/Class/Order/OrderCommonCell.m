//
//  OrderCell.m
//  LoveHome
//
//  Created by 杨建祥 on 15/8/27.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "OrderCommonCell.h"
#import "UIImage+ImageEffects.h"

#import "MyCollectionViewCell.h"

#define OrderCellHeightBase             (240.0f)
#define OrderCellHeightOffset           (10.0f)

@interface OrderCommonCell () <UIAlertViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
//订单状态
@property (nonatomic, weak) IBOutlet UILabel *orderStatusLabel;

//预约取货时间
@property (nonatomic, weak) IBOutlet UILabel *somethingLabel;
//支付金额
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
//支付方式
@property (nonatomic, weak) IBOutlet UILabel *wayLabel;
//姓名
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
//电话号
@property (nonatomic, weak) IBOutlet UILabel *phoneLabel;
//地址
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
//小电话图标 + 联系客户 + [小电话和联系客户上面的透明按钮] 共三个控件
@property (nonatomic, weak) IBOutlet UIView *contactView;
//产品栏
@property (nonatomic, weak) IBOutlet UIView *productView;
//分隔线-----貌似没用
//@property (nonatomic, weak) IBOutlet UIImageView *separatorImageView;
//约束
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *callPhoeViewTraling;
//按钮 block,初步判断用于传值
@property (nonatomic, copy) OrderCommonCellButtonPressedBlock buttonPressedBlock;
#warning NEW
//预约取货时间view
@property (strong, nonatomic) IBOutlet UIView *appointmentView;
//总视图
@property (strong, nonatomic) IBOutlet UIView *allView;
//客户信息
@property (strong, nonatomic) IBOutlet UIView *infoView;
//按钮图
@property (strong, nonatomic) IBOutlet UIView *allButtonView;
//用户信息下面与按钮
@property (nonatomic, strong) UIView *spMidView;
@property (strong, nonatomic) IBOutlet UILabel *connectionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *icoImageView;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;

@property (nonatomic, strong) UIButton *allowRefuseButton;
@property (nonatomic, strong) UILabel *allowRefuseLabel;


@property (nonatomic, copy) NSString *orderId;


@property (nonatomic, strong) UICollectionView *myCollectionView;


@end

@implementation OrderCommonCell

- (void)awakeFromNib {
    // Initialization code
    
    
    [self resetNewUI];
   
}

- (void)resetNewUI
{
    //订单编号label被移除
    
    
    //总视图
    [_allView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.contentView).offset(10);
        make.left.mas_equalTo(self.contentView).offset(0);
        make.right.mas_equalTo(self.contentView).offset([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo(220);
    }];
    //第一条分割线
    UIView *spView0 = [[UIView alloc] init];
    spView0.backgroundColor = JXColorHex(0xcccccc);
    //测试用
    //spView1.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:spView0];
    
    [spView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_appointmentView).offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];

    //预约取货时间view
    [_appointmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.contentView).offset(10);
        make.left.mas_equalTo(self.contentView).offset(0);
        make.right.mas_equalTo(self.contentView).offset([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo(44);
    }];
    
    //预约取货时间label
    
    _somethingLabel.textColor = JXColorHex(0x666666);
    _somethingLabel.font = [UIFont systemFontOfSize:14];
    [_somethingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
       // make.centerY.mas_equalTo(_appointmentView);
        make.top.mas_equalTo(_appointmentView).offset(22);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 15);
    }];
    
    //订单状态label
    _orderStatusLabel.font = [UIFont systemFontOfSize:14];
    _orderStatusLabel.textAlignment = NSTextAlignmentRight;
    [_orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
       // make.centerY.mas_equalTo(_appointmentView);
        make.top.mas_equalTo(_appointmentView).offset(5);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 30);
    }];

    //第一条分割线
    UIView *spView1 = [[UIView alloc] init];
    spView1.backgroundColor = JXColorHex(0xeeeeee);
    //测试用
    //spView1.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:spView1];
    
    [spView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_appointmentView).offset(44);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    //用户信息View
    
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(spView1).offset(1);
        make.left.mas_equalTo(self.contentView).offset(0);
        make.right.mas_equalTo(self.contentView).offset([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo(100);
        
    }];
    
    
    //客户姓名提示label
    UILabel *namePromptLabel = [[UILabel alloc] init];
    namePromptLabel.text = @"客户姓名:";
    namePromptLabel.font = [UIFont systemFontOfSize:14];
    namePromptLabel.textColor = JXColorHex(0x666666);
    [self.infoView addSubview:namePromptLabel];
    
    [namePromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_infoView).offset(10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(20);
    }];
    
    //客户姓名label
    _nameLabel.textColor = JXColorHex(0x666666);
    _nameLabel.font = [UIFont systemFontOfSize:14];
     [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.top.mas_equalTo(_infoView).offset(10);
         make.left.mas_equalTo(namePromptLabel).offset(65);
         make.width.mas_equalTo(60);
         make.height.mas_equalTo(20);
     }];
    
    //电话号码label
    _phoneLabel.font = [UIFont systemFontOfSize:14];
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_infoView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    //电话号码文字label
    
    UILabel *phonePromptLabel = [[UILabel alloc] init];
    phonePromptLabel.text = @"客户电话:";
    phonePromptLabel.font = [UIFont systemFontOfSize:14];
    phonePromptLabel.textColor = JXColorHex(0x666666);
    [self.infoView addSubview:phonePromptLabel];
    
    [phonePromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_infoView).offset(10);
        make.right.mas_equalTo(_phoneLabel).offset(-90);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(20);
    }];
    
   //收货地址label
    _addressLabel.font = [UIFont systemFontOfSize:14];
    _addressLabel.numberOfLines = 0;
    //_addressLabel.backgroundColor = [UIColor redColor];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(namePromptLabel).offset(20);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(40);
    }];
    //付款金额
    [self.infoView addSubview:_amountLabel];
    _amountLabel.font = [UIFont systemFontOfSize:18];
    _amountLabel.textColor = JXColorHex(0xff4400);
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_addressLabel).offset(45);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(25);
    }];

    //付款方式
    [self.infoView addSubview:_wayLabel];
    _wayLabel.font = [UIFont systemFontOfSize:14];
    _wayLabel.textColor = JXColorHex(0x666666);
    [_wayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_addressLabel).offset(48);
        make.left.mas_equalTo(_amountLabel).offset(80);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    //分割线mid
    self.spMidView = [[UIView alloc] init];
    _spMidView.backgroundColor = JXColorHex(0xeeeeee);
    //测试用
    //_spMidView.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:_spMidView];
    
    [_spMidView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_productView).offset(105);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];

    
    //productView
   // _productView.backgroundColor = [UIColor greenColor];
    [_productView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_infoView).offset(105);
        make.left.mas_equalTo(self.contentView).offset(0);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo(100);
    }];
    
    //所有按钮视图
    //_allButtonView.backgroundColor = [UIColor yellowColor];
    [_allButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_productView).offset(100);
        make.left.mas_equalTo(self.contentView).offset(0);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo(50);

    }];
    //接单
    [_acceptButton exSetBorder:JXColorHex(0xff4400) width:1 radius:2];
    _acceptButton.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_acceptButton];
    [_acceptButton setTitleColor:JXColorHex(0xff4400) forState:UIControlStateNormal];
    [_acceptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_spMidView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    //联系客户一大堆
    //[_allButtonView addSubview:_contactView];
    [self.contentView addSubview:_contactView];
    [_contactView exSetBorder:JXColorHex(0xff4400) width:1 radius:2];
    _contactView.layer.borderColor = JXColorHex(0xff4400).CGColor;
    [_contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_spMidView).offset(10);
        make.right.mas_equalTo(_acceptButton).offset(-15 - 60);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(30);
    }];
    
    _icoImageView.frame = CGRectMake(5, 8, 15, 15);
    _connectionLabel.frame = CGRectMake(25, 5, 60, 20);
    _connectionLabel.textColor = JXColorHex(0xff4400);
    
    [self.contactView addSubview:_clearButton];
    _clearButton.backgroundColor = [UIColor clearColor];
    [_clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_spMidView).offset(10);
        make.right.mas_equalTo(_acceptButton).offset(-15 - 60);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(30);
        
    }];
    
    //允许用户拒单 按钮
    
    self.allowRefuseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_allowRefuseButton setImage:[UIImage imageNamed:@"ic_check_normal"] forState:UIControlStateNormal];
    
    [_allowRefuseButton addTarget:self action:@selector(allowRefuseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_allowRefuseButton];
    
    [_allowRefuseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_spMidView).offset(15);
        make.left.mas_equalTo(self).offset(11);
        make.size.mas_equalTo(CGSizeMake(22,22));
    }];
    
    //允许用户拒绝订单
   self.allowRefuseLabel = [[UILabel alloc] init];
    _allowRefuseLabel.text = @"允许用户取消";
    _allowRefuseLabel.font = [UIFont systemFontOfSize:14];
    _allowRefuseLabel.textColor = JXColorHex(0x666666);
    [self.contentView addSubview:_allowRefuseLabel];
    
    [_allowRefuseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_spMidView).offset(13);
        make.left.mas_equalTo(_allowRefuseButton).offset(30);
        make.width.mas_equalTo(86);
        make.height.mas_equalTo(25);
    }];
    
    [_allButtonView removeFromSuperview];
    
    [self.contentView addSubview:_allButtonView];
    [_allButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_productView).offset(100);
        make.left.mas_equalTo(self.contentView).offset(0);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo(50);
        
    }];
    [self.contentView sendSubviewToBack:_allButtonView];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)allowRefuseButtonAction:(UIButton *)button
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"允许用户取消订单,选择后将不可修改" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
    if (buttonIndex == alertView.cancelButtonIndex) {
        [_allowRefuseButton setImage:[UIImage imageNamed:@"ic_check_normal"] forState:UIControlStateNormal];
    
    } else {
        
        [OrderTools allowCustomerRefuseWithOrderId:self.orderId success:^(AFHTTPRequestOperation *operation, NSNumber *result) {
            //弹出提示框
            ShowWaringAlertHUD(@"允许用户取消订单成功", nil);
            
            [_allowRefuseButton setImage:[UIImage imageNamed:@"home_add_checked"] forState:UIControlStateNormal];
            _allowRefuseButton.enabled = NO;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            JXToast(@"允许用户取消订单失败");
        }];
    }
}

//按钮的点击事件
- (IBAction)buttonPressed:(id)sender{
    if (self.buttonPressedBlock) {
        self.buttonPressedBlock(sender, self.order, self.cancelable);
    }
}

- (void)setupButtonPressedBlock:(OrderCommonCellButtonPressedBlock)buttonPressedBlock {
    self.buttonPressedBlock = buttonPressedBlock;
}

- (void)configOrder:(OrderModel *)order type:(OrderType)type {
    
    self.order = order;
    if (order.collectedByMerchant != 0) {
        
        [_acceptButton exSetBorder:[UIColor lightGrayColor] width:1 radius:2];
        _acceptButton.enabled = NO;
        [_acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        _acceptButton.backgroundColor = [UIColor lightGrayColor];
        _allowRefuseButton.enabled = NO;
    }else  {
        
        [self.acceptButton setTitleColor:JXColorHex(0xff4400) forState:UIControlStateNormal];
        [self.acceptButton exSetBorder:JXColorHex(0xff4400) width:1.0 radius:2];
        self.acceptButton.backgroundColor = [UIColor whiteColor];
        _allowRefuseButton.enabled = YES;
        _acceptButton.enabled = YES;
        
    }

    if (order.cancelable != 0) {
        [_allowRefuseButton setImage:[UIImage imageNamed:@"home_add_checked"] forState:UIControlStateNormal];
        _allowRefuseButton.enabled = NO;
    } else {
        
        [_allowRefuseButton setImage:[UIImage imageNamed:@"ic_check_normal"] forState:UIControlStateNormal];
        _allowRefuseButton.enabled = YES;

    }
    
    self.amountLabel.text = [NSString stringWithFormat:@"￥%.2f", order.orderPayDto.totalPrice];
    self.orderId = order.orderid;
    self.cancelable = order.cancelable;
    self.wayLabel.text = order.orderPayDto.payment == 0 ? @"线下支付" : @"线上支付";
    //self.orderStatusLabel.text = order.status == 2 ? @"新增" : @"收衣未响应";
    NSString *opptionTime =  JudgeContainerCountIsNull(order.appointTime) ? @"":order.appointTime;
    self.somethingLabel.text = [NSString stringWithFormat:@"预约取货时间: %@", opptionTime];
    
    // 新增 未响应(收衣未响应，订单未响应) 已处理
    if (type == OrderTypeAdded) {
        
        if (order.status == 2) {
            self.orderStatusLabel.text = @"新增";
        } else if (order.status == 12) {
            self.orderStatusLabel.text = @"收衣未响应";
            _appointmentView.backgroundColor = JXColorRGB(255 , 231 , 222);
        }
       
        
    } else if (type == OrderTypehandled) {
            _orderStatusLabel.text = @"服务中";
        _allowRefuseButton.hidden = YES;
        _allowRefuseLabel.hidden = YES;
            _acceptButton.hidden = YES;
        [_contactView removeFromSuperview];
        
        [self.contentView addSubview:_contactView];
        [_contactView exSetBorder:JXColorHex(0xff4400) width:1.0 radius:2];
        [_contactView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(_spMidView).offset(10);
            make.right.mas_equalTo(self.contentView).offset(-15);
            make.width.mas_equalTo(85);
            make.height.mas_equalTo(30);
        }];
        [_contactView addSubview:_clearButton];
        [_clearButton mas_remakeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(_spMidView).offset(10);
            make.right.mas_equalTo(self.contentView).offset(-15);
            make.width.mas_equalTo(85);
            make.height.mas_equalTo(30);
            
        }];
        }
    
    self.nameLabel.text = order.customerName;
    self.phoneLabel.text = order.customerTelephone;
    self.addressLabel.text = [NSString stringWithFormat:@"收货地址: %@", order.customerAddress];
    //产品view
    
    UIView *view = [[UIView alloc] init];
    //view.backgroundColor = [UIColor redColor];
    [self.productView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.productView);
       // make.top.equalTo(self.productView).offset(i * 20 + 4);
        make.top.mas_equalTo(_productView).offset(0);
        make.trailing.equalTo(self.productView);
        make.height.equalTo(@100);
    }];
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.itemSize = CGSizeMake(60, 105);
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 30, 30 + 60 + 15) collectionViewLayout:flowlayout];
    _myCollectionView.backgroundColor = [UIColor yellowColor];
    _myCollectionView.backgroundColor = [UIColor whiteColor];
    _myCollectionView.dataSource = self;
    _myCollectionView.delegate = self;
    
    [_myCollectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"重用池"];
    [view addSubview:_myCollectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _order.orderDetailList.count;
}
//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *cell = [_myCollectionView dequeueReusableCellWithReuseIdentifier:@"重用池" forIndexPath:indexPath];
    OrderDetailModel *detail = self.order.orderDetailList[indexPath.row];
    OrderModel *mo = self.order;
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:mo.activityIcon] placeholderImage:nil];
    [cell.imageView setImageWithURL:[NSURL URLWithString:detail.imageUrl]];
    cell.TLabel.text = [NSString stringWithFormat:@"%@ %@",detail.productName,detail.specName];
    cell.NLabel.text = [NSString stringWithFormat:@"(%ld)", (long)detail.count];
    //cell.layer.cornerRadius = 10;
    return cell;
}

+ (NSString *)identifier {
    return @"OrderCommonCellIdentifier";
}

+ (CGFloat)heightForOrder:(OrderModel *)order {
    CGFloat height = OrderCellHeightBase;
    if (order.orderDetailList.count > 0) {
        height += order.orderDetailList.count * OrderCellHeightOffset + 40;
    }
    return 310;
}

@end
