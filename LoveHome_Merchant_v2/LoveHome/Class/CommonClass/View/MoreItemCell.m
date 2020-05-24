//
//  MoreItemCell.m
//  LoveHome
//
//  Created by MRH-MAC on 15/8/25.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "MoreItemCell.h"

@interface MoreItemCell ()



@end

@implementation MoreItemCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _selectButton.userInteractionEnabled = NO;
}

- (void)setCategroy:(CategoryModel *)categroy
{
    _categroy = categroy;
    _textName.text = _categroy.categName;
    _selectButton.selected = _categroy.isSelect;
}
- (IBAction)selectButtonClick:(id)sender
{
//    _selectButton.selected = !_selectButton.selected;
//    _categroy.isSelect = _selectButton.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
