//
//  NoOneNewOrderCell.m
//  LoveHome
//
//  Created by MRH-MAC on 15/9/22.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "NoOneNewOrderCell.h"

@implementation NoOneNewOrderCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
