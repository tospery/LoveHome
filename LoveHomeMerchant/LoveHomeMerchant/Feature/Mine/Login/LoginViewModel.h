//
//  LoginViewModel.h
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/17.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "JXViewModel.h"

@interface LoginViewModel : JXViewModel
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *captcha;

@property (nonatomic, strong, readonly) RACCommand *captchaCommand;
@property (nonatomic, strong, readonly) RACCommand *loginCommand;

@end
