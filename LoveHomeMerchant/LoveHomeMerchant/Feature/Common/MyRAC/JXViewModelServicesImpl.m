//
//  JXViewModelServicesImpl.m
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/17.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "JXViewModelServicesImpl.h"
#import "JXWebAPIServiceImpl.h"
#import "JXAppStoreServiceImpl.h"
#import "JXViewModel.h"

@implementation JXViewModelServicesImpl
@synthesize webAPIService = _webAPIService;
@synthesize appStoreService = _appStoreService;

- (instancetype)init {
    self = [super init];
    if (self) {
        _webAPIService = [[JXWebAPIServiceImpl alloc] init];
        _appStoreService   = [[JXAppStoreServiceImpl alloc] init];
    }
    return self;
}

- (void)pushViewModel:(JXViewModel *)viewModel animated:(BOOL)animated {}

- (void)popViewModelAnimated:(BOOL)animated {}

- (void)popToRootViewModelAnimated:(BOOL)animated {}

- (void)presentViewModel:(JXViewModel *)viewModel animated:(BOOL)animated completion:(JXVoidBlock)completion {}

- (void)dismissViewModelAnimated:(BOOL)animated completion:(JXVoidBlock)completion {}

- (void)resetRootViewModel:(JXViewModel *)viewModel {}
@end
