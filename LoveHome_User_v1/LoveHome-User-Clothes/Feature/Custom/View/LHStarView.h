//
//  LHStarView.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/31.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

//self.starView.level = 1;
//self.starView.enabled = NO;
//[self.starView setupDidSelectBlock:^(NSInteger level) {
//    NSLog(@"%@", @(level));
//}];
//[self.starView loadData];

typedef void(^LHStarViewDidSelectBlock)(NSInteger level);

@interface LHStarView : UIView
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *unselectedImage;

- (void)setupDidSelectBlock:(LHStarViewDidSelectBlock)didSelectBlock;
- (void)loadData;
@end
