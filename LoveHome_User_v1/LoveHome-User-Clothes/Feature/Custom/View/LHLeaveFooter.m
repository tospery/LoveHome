//
//  LHOrderConfirmFooter.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/11.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHLeaveFooter.h"

@interface LHLeaveFooter ()

@end

@implementation LHLeaveFooter
- (void)awakeFromNib {
    [_textField exSetupLimit:30];
}

- (void)setCartShop:(LHCartShop *)cartShop {
    _cartShop = cartShop;
    
    [_textField setHidden:NO];
    [_messageLabel setHidden:YES];
    
    NSInteger totalProduct = 0;
    CGFloat totalMoney = 0;
    for (LHSpecify *s in cartShop.specifies) {
        totalProduct += s.pieces;
        totalMoney += (s.price.floatValue * s.pieces);
    }
    
    NSString *totalString = [NSString stringWithFormat:@"共%ld件商品    实付：￥%.2f", (long)totalProduct, totalMoney];
    NSRange range1 = [totalString rangeOfString:@"："];
    NSRange range2 = NSMakeRange(range1.location + range1.length, totalString.length - range1.location - range1.length);
    self.totalInfoLabel.attributedText = [NSAttributedString exAttributedStringWithString:totalString color:[UIColor orangeColor] font:[UIFont boldSystemFontOfSize:15.0f] range:range2];
}

- (void)setOrder:(LHOrder *)order {
    _order = order;
    
    [_totalInfoLabel setHidden:YES];
    [_textField setHidden:YES];
    [_messageLabel setHidden:NO];
    
    _bgView.backgroundColor = [UIColor clearColor];
    _messageLabel.text = [NSString stringWithFormat:@"我的留言：%@", (order.remark.length != 0 ? order.remark : @"无")];
}

- (IBAction)messageTextFieldEditChanged:(UITextField *)textField {
    if (_cartShop) {
        _cartShop.remark = textField.text;
    }
}

+ (NSString *)identifier {
    return @"LHOrderConfirmFooterIdentifier";
}

+ (CGFloat)height {
    return 92.0f;
}

+ (CGFloat)heightNoTotal {
    return 60.0f;
}
@end
