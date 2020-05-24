//
//  LHBalanceFlowCell.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/27.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHBalanceFlowCell : UITableViewCell
@property (nonatomic, strong) LHBalanceFlow *flow;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
