//
//  JCSegmentConditionTableViewCell.m
//  LoveHome
//
//  Created by Joe Chen on 15/2/12.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "JCSegmentConditionTableViewCell.h"

@interface JCSegmentConditionTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView        *chooseIconImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperateLineViewHeight;
@property (weak, nonatomic) IBOutlet UIView             *customBacgroudView;

@end

@implementation JCSegmentConditionTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];

    _seperateLineViewHeight.constant = 0.5f;
    [self updateConstraints];
    
    _customBacgroudView.backgroundColor = JXColorRGB(251.0f, 251.0f, 251.0f) ;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellStateIsHighlight:(BOOL)isHighlight
{
    [_chooseIconImageView setHidden:!isHighlight];
    [_customBacgroudView  setHidden:!isHighlight];
    if (isHighlight)
    {
        //[UIColor colorWithRed:33.0f/255.0f green:156.0f/255.0f blue:228.0f/255.0f alpha:1.0]
        [_showTitleLabel setTextColor: JXColorHex(0x38D8D5)];
    }else
    {
        [_showTitleLabel setTextColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0]];
    }
}

@end
