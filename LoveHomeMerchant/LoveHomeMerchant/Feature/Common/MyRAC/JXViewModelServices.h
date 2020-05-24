//
//  JXViewModelServices.h
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/17.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXWebAPIService.h"
#import "JXAppStoreService.h"
#import "JXNavigationProtocol.h"

@protocol JXViewModelServices <NSObject, JXNavigationProtocol>

@required
@property (nonatomic, strong, readonly) id<JXWebAPIService> webAPIService;
@property (nonatomic, strong, readonly) id<JXAppStoreService> appStoreService;

@end
