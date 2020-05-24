//
//  NotificationViewCell.h
//  LoveHome
//
//  Created by MRH-MAC on 15/9/15.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationModel.h"
@interface NotificationViewCell : UITableViewCell

@property (nonatomic,strong) NotificationModel *notiModel;

+(CGFloat)cellHeightWithData:(NotificationModel *)notiModel;
@end
