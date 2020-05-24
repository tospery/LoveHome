//
//  LHSearchBackView.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/23.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LHSearchBackViewPressBlock)();

@interface LHSearchBackView : UIView
@property (nonatomic, copy) LHSearchBackViewPressBlock pressBlock;

@end
