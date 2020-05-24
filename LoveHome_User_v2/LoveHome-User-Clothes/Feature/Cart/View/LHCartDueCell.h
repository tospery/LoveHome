//
//  LHCartDueCell.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/4.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHCartDueCell : UITableViewCell
@property (nonatomic, strong) LHSpecify *sp;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
