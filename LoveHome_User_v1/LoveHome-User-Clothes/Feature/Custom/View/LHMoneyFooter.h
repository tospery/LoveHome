//
//  LHMoneyFooter.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/11.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHMoneyFooter : UITableViewHeaderFooterView
@property (nonatomic, strong) LHCartShop *cartShop;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
