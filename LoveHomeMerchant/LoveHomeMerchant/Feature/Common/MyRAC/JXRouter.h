//
//  JXRouter.h
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/17.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXViewController.h"

@interface JXRouter : NSObject
/// Retrieves the shared router instance.
///
/// Returns the shared router instance.
+ (instancetype)sharedInstance;

/// Retrieves the view corresponding to the given view model.
///
/// viewModel - The view model
///
/// Returns the view corresponding to the given view model.
- (JXViewController *)viewControllerForViewModel:(JXViewModel *)viewModel;
@end
