//
//  LHCartDueCell.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/4.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import "LHCartDueCell.h"

@interface LHCartDueCell ()
@property (nonatomic, weak) IBOutlet UIButton *logoButton;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@end

@implementation LHCartDueCell
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSp:(LHSpecify *)sp {
    _sp = sp;
    
    [_logoButton sd_setImageWithURL:[NSURL URLWithString:sp.url] forState:UIControlStateNormal placeholderImage:kImagePHProductIcon];
    _nameLabel.text = sp.name;
}

+ (NSString *)identifier {
    return @"LHCartDueCellIdentifier";
}

+ (CGFloat)height {
    return 70.0f;
}
@end
