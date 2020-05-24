//
//  LHMineCommonCell.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/24.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHMineCommonCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *myNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *myIconLabel;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
