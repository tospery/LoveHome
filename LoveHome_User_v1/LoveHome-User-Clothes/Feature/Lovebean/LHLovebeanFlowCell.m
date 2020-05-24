//
//  LHLovebeanFlowCell.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/1.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHLovebeanFlowCell.h"

@interface LHLovebeanFlowCell ()
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@end

@implementation LHLovebeanFlowCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFlow:(LHLovebeanFlow *)flow {
    _flow = flow;
    
    self.typeLabel.text = flow.fromto;
    self.timeLabel.text = flow.changetime;
    
    if (flow.changenumber < 0) {
        self.countLabel.textColor = ColorHex(0xFF6600);
        self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)flow.changenumber];
    }else {
        self.countLabel.textColor = ColorHex(0x339900);
        self.countLabel.text = [NSString stringWithFormat:@"+%ld", (long)flow.changenumber];
    }
}

+ (NSString *)identifier {
    return @"LHLovebeanFlowCellIdentifier";
}

+ (CGFloat)height {
    return 64.0f;
}
@end
