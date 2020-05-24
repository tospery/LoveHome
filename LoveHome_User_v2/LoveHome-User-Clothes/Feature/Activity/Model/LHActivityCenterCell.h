//
//  LHActivityCenterCell.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/1.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHActivityCenterCell : UITableViewCell
@property (nonatomic, strong) LHActivityCenter *ac;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
