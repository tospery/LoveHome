//
//  LHShopDetailTitleView.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/12.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LHShopDetailTitleViewPressedBlock)(UIButton *btn);

@interface LHShopDetailTitleView : UIView
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *arrowImageView;

- (void)recoverArrow;
- (void)setupPressedBlock:(LHShopDetailTitleViewPressedBlock)pressedBlock;

@end
