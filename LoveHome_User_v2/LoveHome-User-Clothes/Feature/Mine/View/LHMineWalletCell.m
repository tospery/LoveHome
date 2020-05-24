//
//  LHMineWalletCell.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/24.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHMineWalletCell.h"

@interface LHMineWalletCell ()
@property (nonatomic, copy) LHMineWalletCellPressedBlock pressedBlock;
@end

@implementation LHMineWalletCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupPressedBlock:(LHMineWalletCellPressedBlock)pressedBlock {
    self.pressedBlock = pressedBlock;
}

- (IBAction)topButtonPressed:(id)sender {
    if (self.pressedBlock) {
        self.pressedBlock(0);
    }
}

- (IBAction)buttonPressed:(id)sender {
    if (self.pressedBlock) {
        self.pressedBlock([(UIButton *)sender tag]);
    }
}

+ (NSString *)identifier {
    return @"LHMineWalletCellIdentifier";
}

+ (CGFloat)height {
    return 120.0f;
}
@end
