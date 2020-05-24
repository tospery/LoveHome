//
//  LoginViewModel.m
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/17.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "LoginViewModel.h"
#import "JXViewModelServices.h"
#import "MainViewModel.h"
#import "MemoryCache.h"

@interface LoginViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *captchaCommand;
@property (nonatomic, strong, readwrite) RACCommand *loginCommand;

@property (nonatomic, strong, readwrite) RACSignal *validLoginSignal;

@end

@implementation LoginViewModel
- (void)initialize {
    [super initialize];
    
    @weakify(self)
    self.captchaCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self.services.webAPIService requestWithParam:[HTTPRequestParam paramObtainCaptchaWithPhone:self.phone]];
    }];
    
    void (^loginDoNext)(id) = ^(User *user) {
        @strongify(self)
        [[MemoryCache sharedInstance] setObject:user forKey:MemoryCacheUser toCached:YES];
        [[MemoryCache sharedInstance] setupUsername:self.phone password:nil];
        
        MainViewModel *viewModel = [[MainViewModel alloc] initWithServices:self.services params:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.services resetRootViewModel:viewModel]; // YJX_TODO animated参数
        });
    };
    self.loginCommand = [[RACCommand alloc] initWithEnabled:self.validLoginSignal signalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[self.services.webAPIService requestWithParam:[HTTPRequestParam paramLoginWithPhone:self.phone captcha:self.captcha] class:User.class] doNext:loginDoNext];
    }];
    [self.loginCommand.errors subscribe:self.errors];
}

- (RACSignal *)validLoginSignal {
    if (!_validLoginSignal) {
        _validLoginSignal = [[RACSignal combineLatest:@[RACObserve(self, phone), RACObserve(self, captcha)] reduce:^(NSString *phone, NSString *captcha){
            BOOL isValidPhone = [JXInputManager verifyPhone:phone original:nil].length == 0;
            BOOL isValidCaptcha = captcha.length == 6;
            return @(isValidPhone && isValidCaptcha);
        }] distinctUntilChanged];
    }
    return _validLoginSignal;
}

- (RACSignal *)requestObtainCaptcha {
    return [self.services.webAPIService requestWithParam:[HTTPRequestParam paramObtainCaptchaWithPhone:self.phone]];
}

@end


