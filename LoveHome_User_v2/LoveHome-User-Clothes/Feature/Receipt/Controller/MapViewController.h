//
//  MaoViewController.h
//  LoveHome
//
//  Created by MRH-MAC on 15/9/7.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

@interface MapViewController : LHBaseViewController

@property (nonatomic,copy)void(^adressBlcok)(NSString *adressString,CGFloat latitude,CGFloat longitude);

@end
