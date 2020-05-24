//
//  LHOrderFooter.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/11.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHOrderFooter.h"

@interface LHOrderFooter ()
@property (nonatomic, assign) LHOrderRequestType type;
@property (nonatomic, strong) LHOrder *order;

@property (nonatomic, weak) IBOutlet UILabel *totalInfoLabel;
@property (nonatomic, weak) IBOutlet UIButton *commentButton;
@property (nonatomic, weak) IBOutlet UIButton *confirmButton;

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *normalButtons;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *importButtons;
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *actionViews;
@end

@implementation LHOrderFooter
- (void)awakeFromNib {
    for (UIButton *btn in self.importButtons) {
        ConfigButtonStyle(btn);
    }
    
    for (UIButton *btn in self.normalButtons) {
        [btn setBackgroundImage:[UIImage exImageWithColor:JXColorHex(0xF4F4F4)] forState:UIControlStateHighlighted];
        [btn exSetBorder:JXColorHex(0x666666) width:1.0 radius:4.0];
    }
}


- (IBAction)cancelButtonPressed:(id)sender {
    if (self.callback) {
        self.callback(self.order, LHOrderActionTypeCancel);
    }
}

- (IBAction)payButtonPressed:(id)sender {
    if (self.callback) {
        self.callback(self.order, LHOrderActionTypePay);
    }
}

- (IBAction)reciveButtonPressed:(id)sender {
    if (self.callback) {
        self.callback(self.order, LHOrderActionTypeReceive);
    }
}

- (IBAction)deleteButtonPressed:(id)sender {
    if (self.callback) {
        self.callback(self.order, LHOrderActionTypeDelete);
    }
}

- (IBAction)commentButtonPressed:(id)sender {
    if (self.callback) {
        self.callback(self.order, LHOrderActionTypeComment);
    }
}

- (IBAction)againButtonPressed:(id)sender {
    if (self.callback) {
        self.callback(self.order, LHOrderActionTypeAgain);
    }
}

- (IBAction)confirmButtonPressed:(id)sender {
    if (self.callback) {
        self.callback(self.order, LHOrderActionTypeConfirm);
    }
}

- (void)configOrder:(LHOrder *)order type:(LHOrderRequestType)type {
    self.type = type;
    self.order = order;
    
    for (int i = 0; i < self.actionViews.count; ++i) {
        if (i == (type - 1)) {
            [self.actionViews[i] setHidden:NO];
        }else {
            [self.actionViews[i] setHidden:YES];
        }
    }
}

- (void)setOrder:(LHOrder *)order {
    _order = order;
    
    if (order.status == LHOrderResponseTypeToComment) {
        [self.commentButton setHidden:NO];
    }else {
        [self.commentButton setHidden:YES];
    }
    
    if (_type == LHOrderRequestTypeCollect) {
        if (order.collectedByMerchant) {
            ConfigButtonStyle(_confirmButton);
            [_confirmButton setEnabled:YES];
        }else {
            [_confirmButton setBackgroundImage:[UIImage exImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
            [_confirmButton exSetBorder:[UIColor clearColor] width:0.1 radius:4];
            [_confirmButton setEnabled:NO];
        }
    }
    
    NSInteger totalProduct = 0;
    for (LHOrderProduct *p in order.products) {
        totalProduct += p.pieces;
    }
    
//    [self.shopNameButton setTitle:order.shopName forState:UIControlStateNormal];
    
    NSString *totalString = [NSString stringWithFormat:@"共%ld件商品    实付：￥%.2f", (long)totalProduct, order.pay.payPrice];
    NSRange range1 = [totalString rangeOfString:@"："];
    NSRange range2 = NSMakeRange(range1.location + range1.length, totalString.length - range1.location - range1.length);
    self.totalInfoLabel.attributedText = [NSAttributedString exAttributedStringWithString:totalString color:[UIColor orangeColor] font:[UIFont boldSystemFontOfSize:15.0f] range:range2];
}

+ (NSString *)identifier {
    return @"LHOrderFooterIdentifier";
}

+ (CGFloat)height {
    return 88.0f;
}
@end
