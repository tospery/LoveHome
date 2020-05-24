//
//  LHShopHeader.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/11.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHShopHeader : UITableViewHeaderFooterView
@property (nonatomic, strong) LHCartShop *cartShop;

@property (nonatomic, weak) IBOutlet UILabel *cancelReasonLabel;
@property (nonatomic, weak) IBOutlet UIButton *editButton;
@property (nonatomic, weak) IBOutlet UIButton *checkButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *widthConstraint;
@property (nonatomic, copy) LHShopHeaderCheckCallback checkCallback;
@property (nonatomic, copy) LHShopHeaderEditCallback editCallback;

- (void)configOrder:(LHOrder *)order type:(LHOrderRequestType)type;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
