//
//  LHAddressCell.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/25.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LHReceiptCellEditPressedBlock)(UIButton *button);
typedef void(^LHReceiptCellDeletePressedBlock)(UIButton *button);

@interface LHReceiptCell : UITableViewCell
@property (nonatomic, strong) LHReceipt *receipt;

- (void)setupEditPressedBlock:(LHReceiptCellEditPressedBlock)editPressedBlock
           deletePressedBlock:(LHReceiptCellDeletePressedBlock)deletePressedBlock;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
