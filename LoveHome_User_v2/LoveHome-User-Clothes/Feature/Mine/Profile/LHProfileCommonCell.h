//
//  LHProfileCommonCell.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/24.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHProfileCommonCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *myTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *myContentLabel;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
