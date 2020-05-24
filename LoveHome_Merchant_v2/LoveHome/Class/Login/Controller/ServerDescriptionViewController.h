//
//  ServerDescriptionViewController.h
//  LoveHome
//
//  Created by MRH on 15/11/23.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import "ModelViewController.h"

@interface ServerDescriptionViewController : ModelViewController
@property (nonatomic,copy) void(^contentBlcok)(NSString *content);

@end
