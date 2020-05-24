//
//  LHCouponMineCell.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/2.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHCoupon.h"

typedef void(^LHCouponCellReceiveCallback)(void);

@interface LHCouponCell : UITableViewCell
@property (nonatomic, strong) LHCoupon *coupon;
@property (nonatomic, copy) LHCouponCellReceiveCallback callback;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
