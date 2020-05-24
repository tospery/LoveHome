//
//  LHOrderConfirmFooter.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/11.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHLeaveFooter : UITableViewHeaderFooterView
@property (nonatomic, strong) LHOrder *order;
@property (nonatomic, strong) LHCartShop *cartShop;

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalInfoLabel;
@property (nonatomic, weak) IBOutlet UIView *bgView;

+ (NSString *)identifier;
+ (CGFloat)height;
+ (CGFloat)heightNoTotal;
@end
