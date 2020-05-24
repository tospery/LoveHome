//
//  LHBalanceFlowCell.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/27.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHBalanceFlowCell.h"

@interface LHBalanceFlowCell ()
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *stateLabel;
@end

@implementation LHBalanceFlowCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFlow:(LHBalanceFlow *)flow {
    _flow = flow;
    
    self.typeLabel.text = flow.type;
    self.timeLabel.text = flow.dealDate; //[flow.dealDate stringWithFormat:kJXFormatDatetimeNormal];
    self.stateLabel.text = flow.state;
    
    if (flow.cash < 0) {
        self.countLabel.textColor = ColorHex(0xFF6600);
        self.countLabel.text = [NSString stringWithFormat:@"%.2f", flow.cash];
    }else {
        self.countLabel.textColor = ColorHex(0x339900);
        self.countLabel.text = [NSString stringWithFormat:@"+%.2f", flow.cash];
    }
}

+ (NSString *)identifier {
    return @"LHBalanceFlowCellIdentifier";
}

+ (CGFloat)height {
    return 64.0f;
}
@end
