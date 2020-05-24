//
//  LHProfileCommonCell.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/24.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHProfileCommonCell.h"

@implementation LHProfileCommonCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)identifier {
    return @"LHProfileCommonCellIdentifier";
}

+ (CGFloat)height {
    return 48.0f;
}
@end
