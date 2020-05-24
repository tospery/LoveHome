//
//  MainViewModel.h
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/19.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "JXViewModel.h"
#import "HomeViewModel.h"
#import "OrderViewModel.h"
#import "StatViewModel.h"

@interface MainViewModel : JXViewModel
@property (nonatomic, strong, readonly) HomeViewModel *homeViewModel;
@property (nonatomic, strong, readonly) OrderViewModel *orderViewModel;
@property (nonatomic, strong, readonly) StatViewModel *statViewModel;

@end
