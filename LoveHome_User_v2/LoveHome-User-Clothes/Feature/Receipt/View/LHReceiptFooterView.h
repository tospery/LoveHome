//
//  LHReceiptFooterView.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/25.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LHReceiptFooterViewAddPressedBlock)(UIButton *button);

@interface LHReceiptFooterView : UIView
- (void)setupAddPressedBlock:(LHReceiptFooterViewAddPressedBlock)addPressedBlock;

@end
