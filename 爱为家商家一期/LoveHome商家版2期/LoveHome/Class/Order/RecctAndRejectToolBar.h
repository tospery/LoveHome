//
//  RecctAndRejectToolBar.h
//  LoveHome
//
//  Created by MRH-MAC on 15/9/2.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecctAndRejectToolBar : UIView
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic,copy) void(^rightClick)(void);
@property (nonatomic,copy) void(^leftClick)(void);


@end
