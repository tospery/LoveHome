//
//  ShopTitleCell.m
//  LoveHome
//
//  Created by MRH-MAC on 15/2/9.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "OrderTitleCell.h"

@interface OrderTitleCell ()

@property (weak, nonatomic) IBOutlet UILabel *shopName;


@end

@implementation OrderTitleCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}




- (void)setSelectButtonStatus:(BOOL)isSelect
{
    _selectButton.selected = YES;
}


- (void)setOrdeEntity:(OrderModel *)ordeEntity
{
    _ordeEntity = ordeEntity;
    _shopName.text = _ordeEntity.shopName;


}




// 选中Button
- (IBAction)selectProductButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    if (_delegate && [_delegate respondsToSelector:@selector(shopTitleSelectButton:isSelect:)]) {
        [_delegate shopTitleSelectButton:self isSelect:button.selected];
    }

}

// 编辑button
- (IBAction)editingShop:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(shopTitleEditingShop:isEditing:)]) {
        [_delegate shopTitleEditingShop:self isEditing:button.selected];
    }
    
    
}


// 跳转页面
- (IBAction)presentButton:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(shopTitleSelectShop:)]) {
        [_delegate shopTitleSelectShop:self];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
