//
//  MainViewModel.m
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/19.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "MainViewModel.h"

@interface MainViewModel ()
@property (nonatomic, strong, readwrite) HomeViewModel *homeViewModel;
@property (nonatomic, strong, readwrite) OrderViewModel *orderViewModel;
@property (nonatomic, strong, readwrite) StatViewModel *statViewModel;

@end

@implementation MainViewModel
- (void)initialize {
    [super initialize];
    
    self.homeViewModel    = [[HomeViewModel alloc] initWithServices:self.services params:@{@"title": @"爱为家商家版"}];
    self.orderViewModel   = [[OrderViewModel alloc] initWithServices:self.services params:nil];
    self.statViewModel  = [[StatViewModel alloc] initWithServices:self.services params:nil];
}

@end