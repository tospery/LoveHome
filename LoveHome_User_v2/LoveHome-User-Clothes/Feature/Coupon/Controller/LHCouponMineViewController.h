//
//  LHCouponMineViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/2.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHBaseViewController.h"

@interface LHCouponMineViewController : LHBaseViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) NSDictionary *shopParams;
@property (nonatomic, assign) BOOL canSelected;
@property (nonatomic, assign) CGFloat actualPrice;
@property (nonatomic, assign) CGFloat totalPrice;

@end
