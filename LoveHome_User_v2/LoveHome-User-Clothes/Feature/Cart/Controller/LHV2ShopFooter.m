//
//  LHV2ShopFooter.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 16/3/7.
//  Copyright © 2016年 艾维科思. All rights reserved.
//

#import "LHV2ShopFooter.h"

@interface LHV2ShopFooter ()
@property (nonatomic, weak) IBOutlet UILabel *totalInfoLabel;
@property (nonatomic, weak) IBOutlet UIButton *funcButton;
@end

@implementation LHV2ShopFooter
- (IBAction)funcButtonPressed:(UIButton *)button {
    if (self.funcCallback) {
        self.funcCallback(self.cartShop, button.tag == 7701 ? NO : YES);
    }
}

- (void)setCartShop:(LHCartShop *)cartShop {
    _cartShop = cartShop;
    
    NSInteger totalProduct = 0;
    CGFloat totalMoney = 0;
    
    BOOL hasSelected = NO;
    NSMutableArray *actArrs = [NSMutableArray arrayWithCapacity:cartShop.specifies.count];
    for (LHSpecify *s in cartShop.specifies) {
        // 未选择
        if (!s.selected) {
            continue;
        }
        
        hasSelected = YES;
        // 普通商品
        if (s.activityId.length == 0) {
            totalProduct += s.pieces;
            totalMoney += (s.price.floatValue * s.pieces);
            continue;
        }
        
        // 折扣活动商品
        if (LHSecondActivityTypeDiscount == s.actPriceType) {
            totalProduct += s.pieces;
            totalMoney += (s.price.floatValue * s.pieces);
            continue;
        }
        
        // 组合活动商品
        if (LHSecondActivityTypeCombination == s.actPriceType) {
            BOOL has = NO;
            for (LHSpecify *sp in actArrs) {
                if ([sp.activityId isEqualToString:s.activityId]) {
                    has = YES;
                    break;
                }
            }
            
            if (!has) {
                [actArrs addObject:s];
                totalProduct += s.pieces;
                totalMoney += s.actPrice;
            }
        }
    }
    
    NSString *totalString = [NSString stringWithFormat:@"共%ld件商品  ￥%.2f", (long)totalProduct, totalMoney];
    NSRange range1 = [totalString rangeOfString:@"￥"];
    NSRange range2 = NSMakeRange(range1.location + range1.length - 1, totalString.length - range1.location - range1.length + 1);
    self.totalInfoLabel.attributedText = [NSAttributedString exAttributedStringWithString:totalString color:[UIColor orangeColor] font:[UIFont boldSystemFontOfSize:15.0f] range:range2];
    
    if (cartShop.isEditing) {
        self.funcButton.tag = 7701;
        [self.funcButton setTitle:@"全部删除" forState:UIControlStateNormal];
        [self.funcButton setBackgroundImage:[UIImage exImageWithColor:ColorHex(0xff2b2a)] forState:UIControlStateNormal];
        [self.funcButton setBackgroundImage:[UIImage exImageWithColor:ColorHex(0xd41c1c)] forState:UIControlStateHighlighted];
        [self.funcButton setBackgroundImage:[UIImage exImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
        [self.funcButton setEnabled:hasSelected];
    }else {
        self.funcButton.tag = 0;
        [self.funcButton setTitle:@"去结算" forState:UIControlStateNormal];
        [self.funcButton setBackgroundImage:[UIImage exImageWithColor:ColorHex(0x29d8d6)] forState:UIControlStateNormal];
        [self.funcButton setBackgroundImage:[UIImage exImageWithColor:ColorHex(0x26c8c6)] forState:UIControlStateHighlighted];
        [self.funcButton setBackgroundImage:[UIImage exImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
        [self.funcButton setEnabled:hasSelected];
    }
}

+ (NSString *)identifier {
    return @"LHV2ShopFooterIdentifier";
}

+ (CGFloat)height {
    return 52.0f;
}

@end
