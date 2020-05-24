//
//  LHMineWalletCell.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/24.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LHMineWalletCellPressedBlock)(NSUInteger index);

@interface LHMineWalletCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *balanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *couponLabel;
@property (nonatomic, weak) IBOutlet UILabel *pointsLabel;

- (void)setupPressedBlock:(LHMineWalletCellPressedBlock)pressedBlock;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
