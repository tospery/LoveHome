//
//  ServerMaoViewController.h
//  LoveHome
//
//  Created by MRH on 15/12/9.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import "ModelViewController.h"

@interface ServerMapViewController : ModelViewController
@property (nonatomic,strong) NSString *rangeValue;
@property (nonatomic,copy)void(^adressBlcok)(NSString *adressString,CGFloat latitude,CGFloat longitude);


@end
