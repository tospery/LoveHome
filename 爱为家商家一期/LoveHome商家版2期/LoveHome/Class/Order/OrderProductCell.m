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

@end

@implementation OrderProductCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDetailMolde:(OrderDetailModel *)detailMolde
{
    _detailMolde = detailMolde;
    _productName.text = [NSString stringWithFormat:@"%@ %@",_detailMolde.productName,_detailMolde.specName];;
    _priceLable.text = [NSString stringWithFormat:@"￥%.2lf",_detailMolde.specPrice];
    _productCount.text = [NSString stringWithFormat:@"x%ld",_detailMolde.count];
    [ImageTool downloadImage:_detailMolde.imageUrl placeholder:[UIImage imageNamed:@"editProductModule_imageDefault"] imageView:_productImageView];
}

@end
