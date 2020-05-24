//
//  LHRechargeViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/2.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHBaseViewController.h"

typedef NS_ENUM(NSInteger, LHRechargeReason){
    LHRechargeReasonNormal,
    LHRechargeReasonPay
};

@interface LHRechargeViewController : LHBaseViewController <UIAlertViewDelegate>
@property (nonatomic, assign) LHRechargeReason reason;

@end
