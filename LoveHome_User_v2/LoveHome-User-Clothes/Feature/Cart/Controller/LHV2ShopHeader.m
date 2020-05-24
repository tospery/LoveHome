//
//  LHV2ShopHeader.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 16/3/7.
//  Copyright © 2016年 艾维科思. All rights reserved.
//

#import "LHV2ShopHeader.h"

@interface LHV2ShopHeader ()
@property (nonatomic, assign) LHOrderRequestType type;
@property (nonatomic, strong) LHOrder *order;

@property (nonatomic, weak) IBOutlet UIButton *shopNameButton;
@end

@implementation LHV2ShopHeader
- (void)configEditInfo:(BOOL)isEditing {
    self.editButton.selected = isEditing;
}

- (void)configCheckInfo {
    BOOL allChecked = YES;
    for (LHSpecify *s in self.cartShop.specifies) {
        if (!s.selected) {
            allChecked = NO;
            break;
        }
    }
    
    self.checkButton.selected = allChecked;
}


- (IBAction)editButtonPressed:(UIButton *)btn {
    btn.selected = !btn.selected;
    
    self.cartShop.isEditing = btn.selected;
    for (LHSpecify *s in self.cartShop.specifies) {
        s.isEditing = btn.selected;
    }
    
    if (self.editCallback) {
        self.editCallback();
    }
}

- (IBAction)checkButtonPressed:(UIButton *)btn {
    btn.selected = !btn.selected;
    
    for (LHSpecify *s in self.cartShop.specifies) {
        s.selected = btn.selected;
    }
    
    if (self.checkCallback) {
        self.checkCallback();
    }
}

- (IBAction)shopButtonPressed:(UIButton *)btn {
    //    btn.selected = !btn.selected;
    //
    //    for (LHSpecify *s in self.cartShop.specifies) {
    //        s.selected = btn.selected;
    //    }
    
    NSInteger shopId = 0;
    if (self.order) {
        shopId = self.order.shopId.integerValue;
    }else if (self.cartShop) {
        shopId = self.cartShop.shopID.integerValue;
    }
    
    if (self.pressCallback) {
        self.pressCallback(shopId);
    }
}

- (void)setCartShop:(LHCartShop *)cartShop {
    _cartShop = cartShop;
    
    [_editButton setHidden:NO];
    [_cancelReasonLabel setHidden:YES];
    
    [self.shopNameButton setTitle:cartShop.shopName forState:UIControlStateNormal];
    [self configEditInfo:cartShop.isEditing];
    [self configCheckInfo];
}

- (void)setPressCallback:(LHShopHeaderPressCallback)pressCallback {
    _pressCallback = pressCallback;
    self.shopNameButton.userInteractionEnabled = YES;
}

+ (NSString *)identifier {
    return @"LHV2ShopHeaderIdentifier";
}

+ (CGFloat)height {
    return 44.0f;
}
@end
