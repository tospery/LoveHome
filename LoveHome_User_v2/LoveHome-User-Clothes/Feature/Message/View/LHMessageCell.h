//
//  LHMessageCell.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/20.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHMessage.h"

@interface LHMessageCell : UITableViewCell
@property (nonatomic, strong) LHMessage *message;

+ (NSString *)identifier;
+ (CGFloat)height;
+ (CGFloat)heightForMessage:(LHMessage *)message;
@end
