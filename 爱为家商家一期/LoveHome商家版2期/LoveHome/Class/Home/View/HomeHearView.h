//
//  HomeHearView.h
//  LoveHome
//
//  Created by MRH-MAC on 15/8/26.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderButton.h"
@protocol HomeHearViewDeleage <NSObject>

- (void)homeHearViewDeleageWaittingOrder:(UIButton *)sender;
- (void)homeHearViewDeleageOrderList:(UIButton *)sender;
- (void)homeHearViewDeleageOrderDetail:(UIButton *)sender;

- (void)homeHearViewDeleageAcceptBatchOrders:(UIButton *)sender;
- (void)homeHearViewDeleageSelectAll:(UIButton *)sender;
@end

@interface HomeHearView : UIView
@property (nonatomic,strong) OrderButton *waitingButton;
@property (nonatomic,strong) OrderButton *orderListButton;
@property (nonatomic,strong) OrderButton *orderDetailButton;

@property (nonatomic,strong) UIButton *allReciveOrderBtn;

@property (nonatomic,assign) id <HomeHearViewDeleage>delegate;

@end
