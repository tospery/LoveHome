//
//  LHShopDetailTitleView.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/12.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHShopDetailTitleView.h"

@interface LHShopDetailTitleView ()
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, copy) LHShopDetailTitleViewPressedBlock pressedBlock;
@end

@implementation LHShopDetailTitleView
- (void)awakeFromNib {
    
}

- (IBAction)pressed:(id)sender {
    if (!self.enabled) {
        return;
    }
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);;
    [UIView animateWithDuration:0.2 animations:^{
        self.arrowImageView.transform = transform;
    } completion:^(BOOL finished) {
    }];
    
    if (self.pressedBlock) {
        self.pressedBlock(sender);
    }
}

- (void)recoverArrow {
    if (!self.enabled) {
        return;
    }
    
   CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI * -2);
    [UIView animateWithDuration:0.2 animations:^{
        self.arrowImageView.transform = transform;
    } completion:NULL];
}

- (void)setupPressedBlock:(LHShopDetailTitleViewPressedBlock)pressedBlock {
    self.pressedBlock = pressedBlock;
    if (pressedBlock) {
        self.enabled = YES;
    }else {
        self.enabled = NO;
    }
}
@end
