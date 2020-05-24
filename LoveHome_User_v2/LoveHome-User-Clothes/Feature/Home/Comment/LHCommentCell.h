//
//  LHCommentCell.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/18.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHComment.h"

@interface LHCommentCell : UITableViewCell
@property (nonatomic, strong) LHComment *comment;

+ (NSString *)identifier;
+ (CGFloat)heightForComment:(LHComment *)comment;
@end
