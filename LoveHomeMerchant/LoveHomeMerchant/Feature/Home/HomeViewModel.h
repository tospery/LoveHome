//
//  HomeViewModel.h
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/19.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "JXViewModel.h"
#import "JXTableViewModel.h"
#import "HomeHeaderViewModel.h"

@interface HomeViewModel : JXTableViewModel
@property (nonatomic, strong, readonly) HomeHeaderViewModel *headerViewModel;

@end
