//
//  LHV2ShopHeader.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 16/3/7.
//  Copyright © 2016年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHV2ShopHeader : UITableViewHeaderFooterView
@property (nonatomic, strong) LHCartShop *cartShop;

@property (nonatomic, weak) IBOutlet UILabel *cancelReasonLabel;
@property (nonatomic, weak) IBOutlet UIButton *editButton;
@property (nonatomic, weak) IBOutlet UIButton *checkButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *widthConstraint;

@property (nonatomic, copy) LHShopHeaderCheckCallback checkCallback;
@property (nonatomic, copy) LHShopHeaderEditCallback editCallback;
@property (nonatomic, copy) LHShopHeaderPressCallback pressCallback;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
