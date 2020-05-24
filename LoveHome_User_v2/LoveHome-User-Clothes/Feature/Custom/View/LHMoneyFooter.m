//
//  LHMoneyFooter.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/11.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHMoneyFooter.h"

@interface LHMoneyFooter ()
@property (nonatomic, weak) IBOutlet UILabel *totalInfoLabel;
@end

@implementation LHMoneyFooter

- (void)setCartShop:(LHCartShop *)cartShop {
    _cartShop = cartShop;
    
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

+ (NSString *)identifier {
    return @"LHMoneyFooterIdentifier";
}

+ (CGFloat)height {
    return 52.0f;
}
@end
