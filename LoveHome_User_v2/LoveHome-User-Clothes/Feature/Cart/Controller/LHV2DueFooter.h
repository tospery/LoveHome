//
//  LHV2DueFooter.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 16/3/7.
//  Copyright © 2016年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LHV2DueFooterClearCallback)();

@interface LHV2DueFooter : UITableViewHeaderFooterView
@property (nonatomic, copy) LHV2DueFooterClearCallback clearCallback;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
