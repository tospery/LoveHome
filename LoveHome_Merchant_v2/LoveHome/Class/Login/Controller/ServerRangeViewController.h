//
//  ServerRangeViewController.h
//  LoveHome
//
//  Created by MRH-MAC on 15/11/23.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import "ModelViewController.h"

@interface ServerRangeViewController : ModelViewController
@property (nonatomic,copy) void(^chooseServerRange)(void);
@end
