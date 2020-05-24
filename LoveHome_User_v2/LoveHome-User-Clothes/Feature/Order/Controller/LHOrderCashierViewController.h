//
//  LHOrderCashierViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/7.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHBaseViewController.h"

@interface LHOrderCashierViewController : LHBaseViewController <UIAlertViewDelegate>
@property (nonatomic, assign) LHEntryFrom from;
@property (nonatomic, strong) LHOrder *order;
@property (nonatomic, strong) LHOrderPay *pay;

//- (instancetype)initWithPay:(LHOrderPay *)pay;

@end
