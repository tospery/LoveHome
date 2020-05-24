//
//  SYHeadInfoView3.m
//  Seeyou
//
//  Created by upin on 13-12-20.
//  Copyright (c) 2013年 linggan. All rights reserved.
//

#import "LHMineHeaderView.h"
@interface LHMineHeaderView()

@property BOOL requested;
@property BOOL requesting;
@property (nonatomic, copy) LHMineHeaderViewSettingPressedBlock settingPressed;
@property (nonatomic, copy) LHMineHeaderViewProfilePressedBlock profilePressed;
@property (nonatomic, copy) LHMineHeaderViewFavoritePressedBlock favoritePressed;
@end

@implementation LHMineHeaderView
- (void)awakeFromNib {
    [self.avatarButton exCircleWithColor:[UIColor clearColor] border:0];
}

- (void)setupSettingPressed:(LHMineHeaderViewSettingPressedBlock)settingPressed
             profilePressed:(LHMineHeaderViewProfilePressedBlock)profilePressed
            favoritePressed:(LHMineHeaderViewFavoritePressedBlock)favoritePressed {
    self.settingPressed = settingPressed;
    self.profilePressed = profilePressed;
    self.favoritePressed = favoritePressed;
}

- (IBAction)settingButtonPressed:(id)sender {
    if (self.settingPressed) {
        self.settingPressed();
    }
}

- (IBAction)profileButtonPressed:(id)sender {
    if (self.profilePressed) {
        self.profilePressed();
    }
}

- (IBAction)favoriteButtonPressed:(id)sender {
    if (self.favoritePressed) {
        self.favoritePressed();
    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

-(void)setIsRefreshed:(BOOL)b {
    isrefreshed = b;
}

-(void)setTouching:(BOOL)touching {
    if(touching) {
        if(hasStop)
        {
            [self resetTouch];
        }
        
        if(touch1)
        {
            touch2 = YES;
        }
    }
    _touching = touching;
}
-(void)resetTouch
{
    touch1 = NO;
    touch2 = NO;
    hasStop = NO;
    isrefreshed = NO;
}
-(void)stopRefresh
{
    if(_touching == NO)
    {
        [self resetTouch];
    }
    else
    {
        hasStop = YES;
    }
}
-(void)setOffsetY:(float)y
{
    _offsetY = y;
    
    if (y >=0 && touch1 && _touching && isrefreshed) {
        touch2 = YES;
    }
    
    UIView* bannerSuper = _img_banner.superview;
    CGRect bframe = bannerSuper.frame;
    if(y<0)
    {
        bframe.origin.y = y;
        bframe.size.height = -y + bannerSuper.superview.frame.size.height;
        bannerSuper.frame = bframe;
        
        CGPoint center =  _img_banner.center;
        center.y = bannerSuper.frame.size.height/2;
        _img_banner.center = center;
    }
    else{
        if(bframe.origin.y != 0)
        {
            bframe.origin.y = 0;
            bframe.size.height = bannerSuper.superview.frame.size.height;
            bannerSuper.frame = bframe;
        }
        if(y<bframe.size.height)
        {
            CGPoint center =  _img_banner.center;
            center.y = bannerSuper.frame.size.height/2 + 0.5*y;
            _img_banner.center = center;
        }
    }
}
@end
