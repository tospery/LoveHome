//
//  OrderAddedCell.m
//  LoveHome
//
//  Created by 杨建祥 on 15/8/29.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "OrderAddedCell.h"
#import "OrderTools.h"
#import "ErrorHandleTool.h"

#import "MyCollectionViewCell.h"

//static UIButton *_allowRefuseButton;

@interface OrderAddedCell () <UIAlertViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
//订单号
@property (nonatomic, weak) IBOutlet UILabel *orderidLabel;
//预约取货时间
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
//收货地址
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
//付款方式
@property (nonatomic, weak) IBOutlet UILabel *payLabel;

//拒单和接单
@property (nonatomic, weak) IBOutlet UIButton *rejectButton;
@property (nonatomic, weak) IBOutlet UIButton *acceptButton;
//选择订单
@property (weak, nonatomic) IBOutlet UIButton *selectOrderButton;
@property (weak, nonatomic) IBOutlet UIView *buttonView;

//新增 imageView
@property (nonatomic, strong) UIImageView *clothImage;
@property (strong, nonatomic) IBOutlet UIView *upView;


//允许用户拒单按钮
@property (nonatomic, strong) UIButton *allowRefuseButton;



@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, copy) OrderAddedCellFuncBlock funcBlock;
@property (nonatomic, copy) OrderAddedCellSelectBlock selectBlock;
#pragma mark - 修改主页 新加入的

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) UICollectionView *myCollectionView;



@end

@implementation OrderAddedCell

- (void)awakeFromNib {
    // Initialization code
    [self.rejectButton exSetBorder:JXColorHex(0x666666) width:1.0 radius:2];
    [self.rejectButton removeFromSuperview];
    
    [self resetNewUI];
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

#pragma mark - 重写UI
- (void)resetNewUI
{
    //上面view
    _upView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 260);
    //重写 选择订单按钮 坐标
    [_selectOrderButton removeFromSuperview];
    //重写预约取货时间 坐标
    
    _timeLabel.textColor = JXColorHex(0x666666);
    _timeLabel.font = [UIFont systemFontOfSize:14];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(25);
        
    }];
    
    //中间分割线1
    
    UIView *spView1 = [[UIView alloc] init];
    spView1.backgroundColor = JXColorHex(0xeeeeee);
    //测试用
    //spView1.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:spView1];
    
    [spView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(35);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    //客户姓名提示label
    UILabel *namePromptLabel = [[UILabel alloc] init];
    namePromptLabel.text = @"客户姓名:";
    namePromptLabel.font = [UIFont systemFontOfSize:14];
    namePromptLabel.textColor = JXColorHex(0x666666);
    [self.upView addSubview:namePromptLabel];
    
    [namePromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(spView1).offset(10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(20);
    }];
    
    //客户姓名label
    self.nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = JXColorHex(0x666666);
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.upView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(spView1).offset(10);
        make.left.mas_equalTo(namePromptLabel).offset(65);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
//
    //电话号码label
    self.phoneLabel = [[UILabel alloc] init];
    _phoneLabel.font = [UIFont systemFontOfSize:14];
    [self.upView addSubview:_phoneLabel];
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(spView1).offset(10);
        make.right.mas_equalTo(self.upView).offset(-15);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];

    //电话号码文字label
    
    UILabel *phonePromptLabel = [[UILabel alloc] init];
    phonePromptLabel.text = @"客户电话:";
    phonePromptLabel.font = [UIFont systemFontOfSize:14];
    phonePromptLabel.textColor = JXColorHex(0x666666);
    [self.upView addSubview:phonePromptLabel];
    
    [phonePromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(spView1).offset(10);
        make.right.mas_equalTo(_phoneLabel).offset(-95);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(20);
    }];
    
    //收货地址label
    _addressLabel.font = [UIFont systemFontOfSize:14];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(namePromptLabel).offset(25);
        make.left.mas_equalTo(self.upView).offset(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(40);
    }];
    
    //重写支付方式 坐标
    
    [_payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_addressLabel).offset(40);
        make.left.mas_equalTo(self.upView).offset(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    
    
    //第二条分割线
    UIView *spView2 = [[UIView alloc] init];
    spView2.backgroundColor = JXColorHex(0xeeeeee);
    //测试用
    //spView2.backgroundColor =[UIColor redColor];
    [self.contentView addSubview:spView2];
    
    [spView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_upView).offset(260);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    //接单按钮
    [self.acceptButton setTitleColor:JXColorHex(0xff4400) forState:UIControlStateNormal];
    [self.acceptButton exSetBorder:JXColorHex(0xff4400) width:1.0 radius:2];
    [_acceptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(spView2).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(25);
    }];
    //buttonView
    _buttonView.frame = CGRectMake(0, 260, [UIScreen mainScreen].bounds.size.width, 45);

#pragma mark - 允许用户拒单按钮点击事件要弹出alert
    //允许用户拒单 按钮
    
    _allowRefuseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_allowRefuseButton setImage:[UIImage imageNamed:@"ic_check_normal"] forState:UIControlStateNormal];
    [_allowRefuseButton addTarget:self action:@selector(allowRefuseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonView addSubview:_allowRefuseButton];
    
    [_allowRefuseButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_buttonView).offset(10);
        make.left.mas_equalTo(self).offset(11);
         make.size.mas_equalTo(CGSizeMake(22,22));
    }];
    
    //允许用户拒绝订单
    UILabel *allowRefuseLabel = [[UILabel alloc] init];
    allowRefuseLabel.text = @"允许用户取消此订单";
    allowRefuseLabel.font = [UIFont systemFontOfSize:14];
    allowRefuseLabel.textColor = JXColorHex(0x666666);
    [self.buttonView addSubview:allowRefuseLabel];
    
    [allowRefuseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_buttonView).offset(10);
        make.left.mas_equalTo(_allowRefuseButton).offset(35);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(25);
        
    }];
    
}
#pragma mark - 允许用户拒单点击事件
- (void)allowRefuseAction:(UIButton *)button
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"允许用户取消订单?选择后将不可修改" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    
    [alert show];
    
}
#pragma mark - UIAlerViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
    if (buttonIndex == 0) {
        [_allowRefuseButton setImage:[UIImage imageNamed:@"ic_check_normal"] forState:UIControlStateNormal];
    } else {
        
        [OrderTools allowCustomerRefuseWithOrderId:self.orderId success:^(AFHTTPRequestOperation *operation, NSNumber *result) {
            //弹出提示框
            [_allowRefuseButton setImage:[UIImage imageNamed:@"home_add_checked"] forState:UIControlStateNormal];
            JXToast(@"允许用户取消订单成功");
            //self.cancelable = 1;
            _allowRefuseButton.enabled = NO;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            JXToast(@"允许用户取消订单失败")
        }];

        
    }
}
- (void)setupFuncBlock:(OrderAddedCellFuncBlock)funcBlock {
    self.funcBlock = funcBlock;
}

- (void)setupSelectBlock:(OrderAddedCellSelectBlock)selectBlock {
    self.selectBlock = selectBlock;
}

- (void)configOrder:(OrderModel *)order {
    self.order = order;
    
    NSLog(@"=========%ld, %ld==============", order.collectedByMerchant, order.cancelable);
    if (order.collectedByMerchant != 0) {
        self.acceptButton.backgroundColor = [UIColor lightGrayColor];
        [self.acceptButton exSetBorder:[UIColor lightGrayColor] width:1 radius:2];
        [self.acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _acceptButton.enabled = NO;
        _allowRefuseButton.enabled = NO;
    } else  {
        
        [self.acceptButton setTitleColor:JXColorHex(0xff4400) forState:UIControlStateNormal];
        self.acceptButton.backgroundColor = [UIColor whiteColor];
        [self.acceptButton exSetBorder:JXColorHex(0xff4400) width:1.0 radius:2];
        _acceptButton.enabled = YES;
        _allowRefuseButton.enabled = YES;
        
    }
    if (order.cancelable == 1) {
        NSLog(@"+++++");
        [_allowRefuseButton setImage:[UIImage imageNamed:@"home_add_checked"] forState:UIControlStateNormal];
        _allowRefuseButton.enabled = NO;
//        [_allowRefuseButton setBackgroundImage:[UIImage imageNamed:@"home_add_checked"] forState:UIControlStateDisabled];
    } else if(order.cancelable == 0){
        [_allowRefuseButton setImage:[UIImage imageNamed:@"ic_check_normal"] forState:UIControlStateNormal];
        
    }

    //订单号
    self.orderidLabel.text = [NSString stringWithFormat:@"订单号: %@", order.orderid];
    self.orderId = order.orderid;
    //预约取货时间
    self.timeLabel.text = [NSString stringWithFormat:@"预约取货时间: %@",order.appointTime];
    //收货地址
    NSString *testText = @"";
    self.addressLabel.text = [NSString stringWithFormat:@"收货地址: %@%@", order.customerAddress,testText];
    
    self.nameLabel.text = order.customerName;
    self.phoneLabel.text = order.customerTelephone;
    self.phoneLabel.textColor = JXColorHex(0x666666);
    //支付方式
       self.payLabel.text = [NSString stringWithFormat:@"¥%.2lf   %@",order.orderPayDto.totalPrice, (order.orderPayDto.payment == 0 ? @"线下支付" : @"线上支付")];
   #pragma mark - 修改颜色
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.payLabel.text];
    
    NSInteger colorRange = 0;
    if (order.orderPayDto.totalPrice >= 0 && order.orderPayDto.totalPrice < 10) {
        colorRange = 5;
    } else if (order.orderPayDto.totalPrice >= 10 && order.orderPayDto.totalPrice < 100) {
        colorRange = 6;
    } else if (order.orderPayDto.totalPrice >= 100 && order.orderPayDto.totalPrice < 1000){
        colorRange = 7;
    }
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, colorRange)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, colorRange)];
    self.payLabel.attributedText = str;
    
    self.selectOrderButton.selected = order.selected;
    
    
#warning 修改图片的显示方式
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.itemSize = CGSizeMake(60, 105);
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 150, [UIScreen mainScreen].bounds.size.width - 30, 30 + 60 + 15) collectionViewLayout:flowlayout];
    _myCollectionView.backgroundColor = [UIColor whiteColor];
    _myCollectionView.dataSource = self;
    _myCollectionView.delegate = self;
    
    [_myCollectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"重用池"];
    [self.upView addSubview:_myCollectionView];
    
}
#pragma mark - 选择订单
- (IBAction)checkButtonPressed:(id)sender {
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    
    if (self.selectBlock) {
        self.selectBlock(btn.selected);
    }
}
#pragma mark - 确认收衣
- (IBAction)funcButtonPressed:(id)sender {
    if (self.funcBlock) {
        self.funcBlock(sender, self.order);
    }
}

+ (NSString *)identifier {
    return @"OrderAddedCellIdentifier";
}

+ (CGFloat)height {
    return 320.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
