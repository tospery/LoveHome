//
//  Util.m
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/17.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "Util.h"

void ConfigNavBarStyle1(UINavigationBar *navBar) {
    [navBar exConfigWithTranslucent:NO barColor:kColorBlack titleColor:[UIColor whiteColor] font:[UIFont exDeviceFontOfSize:17.0f]];
}

void ConfigButtonStyle1(UIButton *btn) {
    btn.titleLabel.font = [UIFont exDeviceFontOfSize:18.0f];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage exImageWithColor:kColorRed] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage exImageWithColor:JXColorHex(0xFF0000)] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage exImageWithColor:JXColorHex(0xCCCCCC)] forState:UIControlStateDisabled];
    [btn exBorderWithColor:[UIColor clearColor] width:0.0 radius:2.0];
}