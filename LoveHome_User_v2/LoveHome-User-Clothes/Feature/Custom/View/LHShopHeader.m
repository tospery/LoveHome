//
//  LHShopHeader.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/11.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHShopHeader.h"


@interface LHShopHeader ()
@property (nonatomic, assign) LHOrderRequestType type;
@property (nonatomic, strong) LHOrder *order;

@property (nonatomic, weak) IBOutlet UIButton *shopNameButton;
@end

@implementation LHShopHeader

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

- (void)configOrder:(LHOrder *)order type:(LHOrderRequestType)type {
    _type = type;
    self.order = order;
}

- (void)setOrder:(LHOrder *)order {
    _order = order;
    
    [_editButton setHidden:YES];
    [_cancelReasonLabel setHidden:NO];
    
    [self.shopNameButton setTitle:order.shopName forState:UIControlStateNormal];
    
    
    if (_type == LHOrderRequestTypeHandle) {
        //        if (order.status == LHOrderResponseTypeToAccept ||
        //            order.status == LHOrderResponseTypeForAppvworksCheck ||
        //            order.status == LHOrderResponseTypeDeleted) {
        //            if (order.pay.payment == LHPayWayByCard) {
        //                self.cancelReasonLabel.text = @"店铺会员卡支付";
        //            }else {
        //                self.cancelReasonLabel.text = @"线上支付";
        //            }
        //        }else {
        //            self.cancelReasonLabel.text = nil;
        //        }
        
        if (order.pay.payment == LHPayWayByCard) {
            self.cancelReasonLabel.text = @"店铺会员卡支付";
        }else if (order.pay.payment == LHPayWayOnLine){
            self.cancelReasonLabel.text = @"线上支付";
        }else {
            self.cancelReasonLabel.text = nil;
        }
        
    }else if (_type == LHOrderRequestTypeCancel) {
        if (_order.cancelFlag == LHOrderCancelReasonCustomerPayed) {
            self.cancelReasonLabel.text = @"用户取消(未支付)";
        }else if(_order.cancelFlag == LHOrderCancelReasonCustomerNoPay) {
            self.cancelReasonLabel.text = @"用户取消(已支付)";
        }else if(_order.cancelFlag == LHOrderCancelReasonCustomerCollecting) {
            self.cancelReasonLabel.text = @"用户取消(收衣中)";
        }else if(_order.cancelFlag == LHOrderCancelReasonAppvworks) {
            self.cancelReasonLabel.text = @"爱为家管理员拒绝";
        }else if(_order.cancelFlag == LHOrderCancelReasonMerchant) {
            self.cancelReasonLabel.text = @"商家拒绝(新增)";
        }else if(_order.cancelFlag == LHOrderCancelReasonMerchantCollecting) {
            self.cancelReasonLabel.text = @"商家拒绝(收衣)";
        }else {
            self.cancelReasonLabel.text = nil;
        }
    }else {
        self.cancelReasonLabel.text = nil;
    }
}

+ (NSString *)identifier {
    return @"LHShopHeaderIdentifier";
}

+ (CGFloat)height {
    return 44.0f;
}

@end
