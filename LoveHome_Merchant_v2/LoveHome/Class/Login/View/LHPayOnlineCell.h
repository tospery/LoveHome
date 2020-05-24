//
//  PayOnlineCell.h
//  LoveHome
//
//  Created by MRH-MAC on 15/3/9.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayOnlineMentModel.h"

@interface LHPayOnlineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel     *titleName;
@property (weak, nonatomic) IBOutlet UILabel     *descriptionLable;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIButton    *selectButton;


@property (nonatomic, strong) PayOnlineMentModel *model;
@end
