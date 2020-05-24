//
//  JXTermView.m
//  MyVBFPopFlatButton
//
//  Created by 杨建祥 on 15/4/6.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#ifdef JXEnableVBFPopFlatButton
#import "JXTermView.h"
#import "VBFPopFlatButton.h"
#import "JXApple.h"

@interface JXTermView ()
@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) VBFPopFlatButton *checkButton;
@end

@implementation JXTermView
#pragma mark - Override methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self custom];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self custom];
    }
    return self;
}

#pragma mark - Private methods
- (void)custom {
    CGFloat side = self.bounds.size.width > self.bounds.size.height ? self.bounds.size.height : self.bounds.size.width;
    CGFloat adopt = side / 5 * 3;
    CGFloat offset = (side - adopt) / 2;
    
    CGRect frame = CGRectMake(offset, offset, adopt, adopt);
    _borderView = [[UIView alloc] initWithFrame:frame];
    [_borderView exSetBorder:[UIColor orangeColor] width:kJXMetricBorderWidthMiddle radius:kJXMetricCornerRadiusSmall];
    [self addSubview:_borderView];
    
    frame = CGRectMake(adopt / 5 + offset,
                             offset,
                             adopt / 5 * 3,
                             adopt / 5 * 4);
    _checkButton = [[VBFPopFlatButton alloc] initWithFrame:frame
                                                       buttonType:buttonOkType
                                                      buttonStyle:buttonPlainStyle
                                            animateToInitialState:NO];
    _checkButton.lineThickness = 2.5;
    _checkButton.tintColor = [UIColor orangeColor];
    _checkButton.hidden = YES;
    [self addSubview:_checkButton];
    
    UIButton *fgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fgButton.frame = self.bounds;
    [fgButton addTarget:self action:@selector(fgButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:fgButton];
}

#pragma mark - Accessor methods
- (BOOL)checked {
    return !_checkButton.hidden;
}

#pragma mark - Action methods
- (void)fgButtonPressed:(id)sender {
    [_checkButton setHidden:!_checkButton.hidden];
}

#pragma mark - Public methods
- (void)configColor:(UIColor *)color{
    [_borderView exSetBorder:color width:kJXMetricBorderWidthMiddle radius:kJXMetricCornerRadiusSmall];
    _checkButton.tintColor = color;
}
@end
#endif