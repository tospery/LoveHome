//
//  JXViewModel.m
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/17.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "JXViewModel.h"

@interface JXViewModel ()
@property (nonatomic, strong, readwrite) id<JXViewModelServices> services;
@property (nonatomic, copy, readwrite) NSDictionary *params;
@property (nonatomic, strong, readwrite) RACSubject *errors;
@property (nonatomic, strong, readwrite) RACSubject *willDisappearSignal;

@end

@implementation JXViewModel
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    JXViewModel *viewModel = [super allocWithZone:zone];
    
    @weakify(viewModel)
    [[viewModel
      rac_signalForSelector:@selector(initWithServices:params:)]
    	subscribeNext:^(id x) {
            @strongify(viewModel)
            [viewModel initialize];
        }];
    
    return viewModel;
}

- (instancetype)initWithServices:(id<JXViewModelServices>)services params:(NSDictionary *)params {
    self = [super init];
    if (self) {
        self.shouldFetchLocalDataOnViewModelInitialize = YES;
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
        self.title    = params[@"title"];
        self.backgroundColor = params[@"backgroundColor"];
        self.backgroundColor = self.backgroundColor ? self.backgroundColor : kColorWhite;
        self.services = services;
        self.params   = params;
        self.user = [User userForCurrent];
    }
    return self;
}

- (RACSubject *)errors {
    if (!_errors) {
        _errors = [RACSubject subject];
    }
    return _errors;
}

- (RACSubject *)willDisappearSignal {
    if (!_willDisappearSignal) {
        _willDisappearSignal = [RACSubject subject];
    }
    return _willDisappearSignal;
}

- (void)initialize {
}

@end
