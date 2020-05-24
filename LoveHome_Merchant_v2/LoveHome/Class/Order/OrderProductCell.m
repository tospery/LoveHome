//
//  OrderProductCell.m
//  LoveHome
//
//  Created by MRH-MAC on 15/9/1.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "OrderProductCell.h"


@interface OrderProductCell ()
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UILabel *productCount;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

@property (nonatomic, strong) NSString *activityName;

@end

@implementation OrderProductCell

- (void)awakeFromNib {
    // Initialization code
    self.productImageView.layer.borderColor = JXColorHex(0xeeeeee).CGColor;
    self.productImageView.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setOrderModel:(OrderModel *)orderModel
{
    _orderModel = orderModel;
    [_iconImageView setImageWithURL:[NSURL URLWithString:orderModel.activityIcon] placeholderImage:nil];
    self.activityName = orderModel.activityName;
}

- (void)setDetailMolde:(OrderDetailModel *)detailMolde
{
    _detailMolde = detailMolde;
    
    if (self.activityName.length > 0) {
        self.activityName = [NSString stringWithFormat:@"[%@]", _activityName];
    }

    _productName.text = [NSString stringWithFormat:@"%@ %@%@", _detailMolde.productName,_detailMolde.specName,self.activityName];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.productName.text];
    
    NSInteger colorRange = 0;
    if (self.activityName.length > 2) {
       
        colorRange = self.activityName.length;
    }
    
    [str addAttribute:NSForegroundColorAttributeName value:JXColorHex(0xff4400) range:NSMakeRange(_detailMolde.productName.length + _detailMolde.specName.length + 1, colorRange)];
    
    self.productName.attributedText = str;
    _priceLable.textColor = kPlainCommonOrange;
    _priceLable.text = [NSString stringWithFormat:@"￥%.2lf",_detailMolde.specPrice];
    _productCount.text = [NSString stringWithFormat:@"x%ld",_detailMolde.count];
    [ImageTool downloadImage:_detailMolde.imageUrl placeholder:[UIImage imageNamed:@"editProductModule_imageDefault"] imageView:_productImageView];
}

@end
