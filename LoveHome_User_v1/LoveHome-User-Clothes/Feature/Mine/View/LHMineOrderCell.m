//
//  LHMineOrderCell.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/24.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHMineOrderCell.h"

@interface LHMineOrderCell ()
@property (nonatomic, copy) LHMineOrderCellPressedBlock pressedBlock;
@end

@implementation LHMineOrderCell

- (void)awakeFromNib {
    // Initialization code
    [self.waitingToPayCountLabel exSetBorder:[UIColor redColor] width:1.0 radius:4.0];
    [self.waitingToHandleCountLabel exSetBorder:[UIColor redColor] width:1.0 radius:4.0];
    [self.collectingCountLabel exSetBorder:[UIColor redColor] width:1.0 radius:4.0];
    [self.tradingCountLabel exSetBorder:[UIColor redColor] width:1.0 radius:4.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupPressedBlock:(LHMineOrderCellPressedBlock)pressedBlock {
    self.pressedBlock = pressedBlock;
}

- (IBAction)buttonPressed:(id)sender {
    if (self.pressedBlock) {
        self.pressedBlock([(UIButton *)sender tag]);
    }
}

+ (NSString *)identifier {
    return @"LHMineOrderCellIdentifier";
}

+ (CGFloat)height {
    return 120.0f;
}

@end
