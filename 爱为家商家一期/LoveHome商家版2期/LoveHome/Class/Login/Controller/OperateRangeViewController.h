//
//  OperateRangeViewController.h
//  LoveHome
//
//  Created by MRH-MAC on 15/8/25.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "ModelViewController.h"



@interface OperateRangeViewController : ModelViewController

@property (nonatomic,copy) void(^changeCategory)(NSArray *cates);
@end
