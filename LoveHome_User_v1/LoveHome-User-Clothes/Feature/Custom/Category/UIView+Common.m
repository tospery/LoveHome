//
//  UIView+Common.m
//  LoveHome-User-Clothes
//
//  Created by 李俊辉 on 15/8/5.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "UIView+Common.h"
#import <objc/runtime.h>
@implementation UIView (Common)
static char BlankPageViewKey;
- (void)doCircleFrame{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = ColorHex(0xdddddd).CGColor;
}
- (void)doNotCircleFrame{
    self.layer.cornerRadius = 0.0;
    self.layer.borderWidth = 0.0;
}

- (void)doBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = width;
    if (!color) {
        self.layer.borderColor = ColorHex(0xdddddd).CGColor;
    }else{
        self.layer.borderColor = color.CGColor;
    }
}

- (UIViewController *)findViewController
{
    for (UIView* next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size.width = size.width;
    frame.size.height = size.height;
    self.frame = frame;
}

- (CGFloat)maxXOfFrame{
    return CGRectGetMaxX(self.frame);
}



#pragma mark BlankPageView
- (void)setBlankPageView:(EaseBlankPageView *)blankPageView{
    [self willChangeValueForKey:@"BlankPageViewKey"];
    objc_setAssociatedObject(self, &BlankPageViewKey,
                             blankPageView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"BlankPageViewKey"];
}

- (EaseBlankPageView *)blankPageView{
    return objc_getAssociatedObject(self, &BlankPageViewKey);
}

- (void)configBlankPage:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)(id))block{
    if (hasData) {
        if (self.blankPageView) {
            self.blankPageView.hidden = YES;
            [self.blankPageView removeFromSuperview];
        }
    }else{
        if (!self.blankPageView) {
            self.blankPageView = [[EaseBlankPageView alloc] initWithFrame:self.bounds];
        }
        self.blankPageView.hidden = NO;
        [self.blankPageContainer addSubview:self.blankPageView];
        
        //        [self.blankPageContainer insertSubview:self.blankPageView atIndex:0];
        //        [self.blankPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.size.equalTo(self);
        //            make.top.left.equalTo(self.blankPageContainer);
        //        }];
        [self.blankPageView configWithType:blankPageType hasData:hasData hasError:hasError reloadButtonBlock:block];
    }
}

- (UIView *)blankPageContainer{
    UIView *blankPageContainer = self;
    for (UIView *aView in [self subviews]) {
        if ([aView isKindOfClass:[UITableView class]]) {
            blankPageContainer = aView;
        }
    }
    return blankPageContainer;
}

@end


@implementation EaseBlankPageView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)configWithType:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)(id))block
{
    if (hasData) {
        [self removeFromSuperview];
        return;
    }
    self.alpha = 1.0;
    //    图片
    if (!_displayView) {
        _displayView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_displayView];
    }
    
    //    文字
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = [UIFont systemFontOfSize:18];
        _tipLabel.textColor = ColorHex(0xcccccc);
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
    }
    
    //    布局
    [_displayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_centerY).offset(- 50);
    }];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerX.equalTo(self);
        make.top.equalTo(_displayView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    _reloadButtonBlock = nil;
    if (hasError)
    {
        //        加载失败
        if (!_reloadButton)
        {
            _reloadButton = [[UIButton alloc] initWithFrame:CGRectZero];
            _reloadButton.layer.masksToBounds = YES;
            _reloadButton.layer.cornerRadius = 4;
            _reloadButton.layer.borderWidth  = .5;
            _reloadButton.layer.borderColor = ColorHex(0x666666).CGColor;
            [_reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
            [_reloadButton setTitleColor:ColorHex(0x666666) forState:UIControlStateNormal];
            _reloadButton.titleLabel.font = [UIFont systemFontOfSize:16];
            _reloadButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            _reloadButton.adjustsImageWhenHighlighted = YES;
            [_reloadButton addTarget:self action:@selector(reloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_reloadButton];
            [_reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_tipLabel.mas_bottom);
                make.size.mas_equalTo(CGSizeMake(120, 44));
            }];
        }
        _reloadButton.hidden = NO;
        _reloadButtonBlock = block;
        [_displayView setImage:[UIImage imageNamed:@"network_error"]];
        _tipLabel.text = @"无网络信号，请稍后再试";
    }
    else
    {
        //        空白数据
        if (_reloadButton) {
            _reloadButton.hidden = YES;
        }
        NSString *tipStr = @"";
        if (blankPageType == EaseBlankPageTypeOrder)
        {
            tipStr = @"没有相关订单";
        }
        else if (blankPageType == EaseBlankPageTypeFollowShop)
        {
            tipStr = @"没有关注的店铺";
        }
        else if (blankPageType == EaseBlankPageTypeCoupon)
        {
            tipStr = @"没有优惠券";
        }
        _displayView.hidden = YES;
        _tipLabel.text = tipStr;
    }
}

- (void)reloadButtonClicked:(id)sender{
    self.hidden = YES;
    [self removeFromSuperview];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_reloadButtonBlock) {
            _reloadButtonBlock(sender);
        }
    });
}

@end




