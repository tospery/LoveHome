//
//  JXRouter.m
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/17.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "JXRouter.h"

@interface JXRouter ()
@property (nonatomic, copy) NSDictionary *viewModelViewMappings; // viewModel到view的映射
@end

@implementation JXRouter

+ (instancetype)sharedInstance {
    static JXRouter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (JXViewController *)viewControllerForViewModel:(JXViewModel *)viewModel {
    NSString *viewController = self.viewModelViewMappings[NSStringFromClass(viewModel.class)];
    
    NSParameterAssert([NSClassFromString(viewController) isSubclassOfClass:[JXViewController class]]);
    NSParameterAssert([NSClassFromString(viewController) instancesRespondToSelector:@selector(initWithViewModel:)]);
    
    return [[NSClassFromString(viewController) alloc] initWithViewModel:viewModel];
}

- (NSDictionary *)viewModelViewMappings {
    return @{@"LoginViewModel": @"LoginViewController",
             @"MainViewModel": @"MainViewController"};
}

@end