//
//  DetailNormlHearCell.h
//  LoveHome
//
//  Created by MRH-MAC on 15/9/1.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderTools.h"
@interface DetailNormlHearCell : UITableViewCell

@property (nonatomic,strong) OrderModel *order;
+ (NSString *)identifier;
@end
