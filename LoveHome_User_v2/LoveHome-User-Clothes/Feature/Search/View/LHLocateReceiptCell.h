//
//  LHLocateReceiptCell.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/17.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHReceipt.h"

@interface LHLocateReceiptCell : UITableViewCell
@property (nonatomic, strong) LHReceipt *receipt;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
