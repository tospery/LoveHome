//
//  LHBaseCell.h
//  LoveHome-User-Clothes
//
//  Created by 李俊辉 on 15/7/22.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHBaseCell : UITableViewCell
/**
 *  是否为最后一行
 */
@property (nonatomic, assign, getter = isLastRowInSection) BOOL lastRowInSection;
@property (strong, nonatomic) UIView *topLineView;
@end
