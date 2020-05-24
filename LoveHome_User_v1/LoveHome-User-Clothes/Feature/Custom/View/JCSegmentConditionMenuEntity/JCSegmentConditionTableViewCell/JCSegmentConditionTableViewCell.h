//
//  JCSegmentConditionTableViewCell.h
//  LoveHome
//
//  Created by Joe Chen on 15/2/12.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCSegmentConditionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *showTitleLabel;

- (void)setCellStateIsHighlight:(BOOL)isHighlight;

@end
