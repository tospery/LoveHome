//
//  JXRacViewProtocol.h
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/19.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JXRacViewProtocol <NSObject>
/// Binds the given view model to the view.
///
/// viewModel - The view model
- (void)bindViewModel:(id)viewModel;

@end
