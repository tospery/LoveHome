//
//  LHPorfileAvatarCell.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/24.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHProfileAvatarCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
