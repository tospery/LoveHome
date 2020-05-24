//
//  LHHomeSearch.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/13.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LHHomeSearchViewPressBlock)();

@interface LHHomeSearchView : UIView
@property (nonatomic, copy) LHHomeSearchViewPressBlock pressBlock;

@end
