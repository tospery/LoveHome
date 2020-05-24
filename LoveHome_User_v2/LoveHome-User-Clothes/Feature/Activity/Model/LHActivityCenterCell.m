//
//  LHActivityCenterCell.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/1.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import "LHActivityCenterCell.h"

@interface LHActivityCenterCell ()
@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@end

@implementation LHActivityCenterCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAc:(LHActivityCenter *)ac {
    _ac = ac;
    
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:_ac.url] placeholderImage:[UIImage imageNamed:@"ic_activity_default"]];
    
    NSUInteger oneDay = 24 * 60 * 60;
    NSInteger totalDay = 1;
    if (_ac.surplusTotalSecond <= oneDay) {
        totalDay = 1;
    }else {
        totalDay = _ac.surplusTotalSecond / oneDay;
    }
    
    NSString *str = [NSString stringWithFormat:@"活动仅剩%ld天", (long)totalDay];
    NSRange range = [str rangeOfString:JXStringFromInteger(totalDay)];
    _dateLabel.attributedText = [NSAttributedString exAttributedStringWithString:str color:JXColorHex(0x31B8AE) font:[UIFont systemFontOfSize:15.0f] range:range];
    
    _countLabel.text = [NSString stringWithFormat:@"已售%ld件", (long)_ac.saleCounts];
}

+ (NSString *)identifier {
    return @"LHActivityCenterCellIdentifier";
}

+ (CGFloat)height {
    return 180.0f;
}

@end
