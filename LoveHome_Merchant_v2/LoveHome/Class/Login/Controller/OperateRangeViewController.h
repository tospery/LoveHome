//
//  OperateRangeViewController.h
//  LoveHome
//
//  Created by MRH-MAC on 15/8/25.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "ModelViewController.h"

@protocol OperateRangeViewControllerDelegate <NSObject>

- (void)chooseSelectCategory:(NSArray *)cates;

@end

@interface OperateRangeViewController : ModelViewController

@property (nonatomic,copy) void(^changeCategory)(NSArray *cates);
@property (nonatomic,assign) id <OperateRangeViewControllerDelegate>delegate;

@end
