//
//  LHOrderProductCell.m
//  LoveHome-User-Clothes
//
//  Created by 李俊辉 on 15/7/27.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHOrderProductCell.h"

#define kLHOrderProductCellIconWH 70
#define kLHOrderProductCellTextFont [UIFont systemFontOfSize:14]
@interface LHOrderProductCell()
@property (nonatomic, strong) UIImageView *productIconView;
@property (nonatomic, strong) UILabel     *productNameView;
@property (nonatomic, strong) UILabel     *specPriceView;
@property (nonatomic, strong) UILabel     *countView;
@end

@implementation LHOrderProductCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView
{
    [self.contentView addSubview:self.productIconView];
    [self.contentView addSubview:self.productNameView];
    [self.contentView addSubview:self.specPriceView];
    [self.contentView addSubview:self.countView];
    
    [self.productIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@(kLHOrderProductCellIconWH));
        make.height.equalTo(@(kLHOrderProductCellIconWH));
    }];
    
//    _specPriceView.textColor = JXColorHex(0xff4400);
//    _specPriceView.font = [UIFont systemFontOfSize:15];
    [self.specPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productIconView.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.specPriceView.mas_bottom).offset(5);
        make.right.equalTo(self.specPriceView.mas_right);
    }];
    
    [self.productNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productIconView.mas_top);
        make.left.equalTo(self.productIconView.mas_right).offset(15);
        //        make.right.equalTo(self.specPriceView.mas_left).offset(-35);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (UILabel *)getPlainTextLabelWithTextColor:(UIColor *)textColor font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = 0;
    return label;
}

#pragma mark - getters and setters
- (UIImageView *)productIconView
{
    if (!_productIconView)
    {
        _productIconView = [[UIImageView alloc] init];
    }
    return _productIconView;
}

- (UILabel *)productNameView
{
    if (!_productNameView)
    {
        _productNameView = [self getPlainTextLabelWithTextColor:kPlainTextLightColor font:kLHOrderProductCellTextFont];
    }
    return _productNameView;
}

- (UILabel *)specPriceView
{
    if (!_specPriceView)
    {
        _specPriceView = [self getPlainTextLabelWithTextColor:kPlainTextLightColor font:kLHOrderProductCellTextFont];
    }
    return _specPriceView;
}

- (UILabel *)countView
{
    if (!_countView) {
        _countView = [self getPlainTextLabelWithTextColor:ColorHex(0x999999) font:kLHOrderProductCellTextFont];
    }
    return _countView;
}

- (void)setOrderProduct:(OrderDetailModel *)orderProduct
{
    _orderProduct = orderProduct;
    
//    [self.productIconView sd_setImageWithURL:[NSURL URLWithString:orderProduct.imageUrl] placeholderImage:PlaceHolderImage];
    self.productNameView.text = [NSString stringWithFormat:@"%@ %@",orderProduct.productName,orderProduct.specName];
    self.specPriceView.text = [NSString stringWithFormat:@"￥%.2f",orderProduct.specPrice];
    self.countView.text = [NSString stringWithFormat:@"x%ld",orderProduct.count];
}

- (void)configCellData:(id)data
{
//    LHOrderProductEntity *product = data;
////    [self.productIconView sd_setImageWithURL:[NSURL URLWithString:product.imageUrl] placeholderImage:PlaceHolderImage];
//    self.productNameView.text = product.name;
//    self.specPriceView.text = [NSString stringWithFormat:@"￥%.2f",[product.price floatValue]];
//    self.countView.text = [NSString stringWithFormat:@"x%@",[product proCount]];
    
}

+ (CGFloat)cellHeight
{
    return 100;
}
@end
