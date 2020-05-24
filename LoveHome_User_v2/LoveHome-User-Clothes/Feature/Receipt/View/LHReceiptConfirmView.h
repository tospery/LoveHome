//
//  LHReceiptConfirmView.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/30.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LHReceiptConfirmType){
    LHReceiptConfirmTypeClose,
    LHReceiptConfirmTypeOK,
    LHReceiptConfirmTypeEntry
};

typedef void(^LHReceiptConfirmBlock)(LHReceiptConfirmType type, UIButton *checkButton);

@interface LHReceiptConfirmView : UIView
@property (nonatomic, copy) LHReceiptConfirmBlock clickBlock;

@end
