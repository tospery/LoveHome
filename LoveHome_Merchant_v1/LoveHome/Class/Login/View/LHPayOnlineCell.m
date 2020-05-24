//
//  PayOnlineCell.m
//  LoveHome
//
//  Created by MRH-MAC on 15/3/9.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "LHPayOnlineCell.h"

@implementation LHPayOnlineCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(PayOnlineMentModel *)model
{
    _model = model;

    _selectButton.selected = model.isSelect ? YES : NO;

    _titleName.text = _model.payMentName;
    _descriptionLable.text = _model.payMentDescription;
    _iconImage.image = [UIImage imageNamed:_model.iconUrl];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
