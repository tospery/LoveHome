//
//  LHSpecifyCell.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/11.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHSpecifyCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIButton *checkButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *widthConstraint;

@property (nonatomic, copy) LHSpecifyCellCheckCallback checkCallback;
@property (nonatomic, copy) LHSpecifyCellCountCallback countCallback;
@property (nonatomic, copy) LHSpecifyCellDeleteCallback deleteCallback;

- (void)configSpecify:(LHSpecify *)specify inCart:(BOOL)inCart;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
