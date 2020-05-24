//
//  LHPaywordViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/26.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHBaseViewController.h"
#import "LHCaptchaButton.h"

typedef NS_ENUM(NSInteger, LHAccountMode){
    LHAccountModeVerifySetPayword,
    LHAccountModeVerifyChangePhone,
    LHAccountModeChangePhone,
    LHAccountModeVerifyPay
};

@interface LHPhoneVerifyViewController : LHBaseViewController <LHCaptchaButtonDelegate>
- (instancetype)initWithMode:(LHAccountMode)mode;
@end
