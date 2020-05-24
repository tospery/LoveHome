//
//  JXFilterViewCategory.h
//  iOSLibrary
//
//  Created by 杨建祥 on 15/9/26.
//  Copyright © 2015年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXFilterViewCategory;

@protocol JXFilterViewCategoryDelegate <NSObject>
@required
- (void)filterViewCategory:(JXFilterViewCategory *)category
            didSelectIndex:(NSInteger)index;

@end

@interface JXFilterViewCategory : UIView
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *indicatorImageView;
@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic, weak) id<JXFilterViewCategoryDelegate> delegate;

@end
