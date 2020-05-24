//
//  LHMineOrderCell.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/24.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LHMineOrderCellPressedBlock)(NSUInteger index);

@interface LHMineOrderCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *waitingToPayCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *waitingToHandleCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *collectingCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *tradingCountLabel;

- (void)setupPressedBlock:(LHMineOrderCellPressedBlock)pressedBlock;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
