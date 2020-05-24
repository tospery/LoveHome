//
//  LHV2SpecifyCell.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 16/3/7.
//  Copyright © 2016年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHV2SpecifyCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIButton *checkButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *widthConstraint;

@property (nonatomic, copy) LHSpecifyCellCheckCallback checkCallback;
@property (nonatomic, copy) LHSpecifyCellCountCallback countCallback;
@property (nonatomic, copy) LHSpecifyCellDeleteCallback deleteCallback;

- (void)configSpecify:(LHSpecify *)specify inCart:(BOOL)inCart;

+ (NSString *)identifier;
+ (CGFloat)heightWithSpecify:(LHSpecify *)specify;
@end
