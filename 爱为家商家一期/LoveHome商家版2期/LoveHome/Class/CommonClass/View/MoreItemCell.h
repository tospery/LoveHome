//
//  MoreItemCell.h
//  LoveHome
//
//  Created by MRH-MAC on 15/8/25.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"
@interface MoreItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *textName;
@property (nonatomic,strong) CategoryModel *categroy;
@end
