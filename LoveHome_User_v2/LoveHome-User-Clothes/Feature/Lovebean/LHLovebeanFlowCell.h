//
//  LHLovebeanFlowCell.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/1.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHLovebeanFlow.h"

@interface LHLovebeanFlowCell : UITableViewCell
@property (nonatomic, strong) LHLovebeanFlow *flow;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
