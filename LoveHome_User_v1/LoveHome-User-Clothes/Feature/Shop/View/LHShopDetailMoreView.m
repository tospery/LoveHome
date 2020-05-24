//
//  LHShopDetailMoreView.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/14.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHShopDetailMoreView.h"

#define LHShopDetailMoreViewMarginH      (20.0f)
#define LHShopDetailMoreViewMarginV      (12.0f)

@interface LHShopDetailMoreView ()
@property (nonatomic, assign) CGFloat totalWidth;
@property (nonatomic, assign) CGFloat btnHeight;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, copy) LHShopDetailMoreViewSelectBlock selectBlock;
@property (nonatomic, copy) LHShopDetailMoreViewCloseBlock closeBlock;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *logoWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *logoOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *rootHeightConstraint;
@end

@implementation LHShopDetailMoreView

- (void)awakeFromNib {
    JXDeviceResolution resolution = [JXDevice sharedInstance].resolution;
    if (JXDeviceResolution640x960 == resolution
        || JXDeviceResolution640x1136 == resolution) {
        self.font = [UIFont systemFontOfSize:12.0f];
        self.btnHeight = 30.0f;
    }else if (JXDeviceResolution750x1334 == resolution) {
        self.font = [UIFont systemFontOfSize:14.0f];
        self.btnHeight = 32.0f;
    }else if (JXDeviceResolution1242x2208 == resolution) {
        self.font = [UIFont systemFontOfSize:16.0f];
        self.btnHeight = 34.0f;
    }else {
        self.font = [UIFont systemFontOfSize:12.0f];
        self.btnHeight = 30.0f;
    }
    
    self.totalWidth = kScreenWidth - 12 * 2;
}

- (void)setupSelectBlock:(LHShopDetailMoreViewSelectBlock)selectBlock
              closeBlock:(LHShopDetailMoreViewCloseBlock)closeBlock {
    self.selectBlock = selectBlock;
    self.closeBlock = closeBlock;
}

- (IBAction)closeButtonPressed:(id)sender {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)productButtonPressed:(UIButton *)btn {
    if (_isOutOfService) {
        if (self.selectBlock) {
            self.selectBlock(self.product, nil, btn.selected);
        }
        return;
    }
    
    btn.selected = !btn.selected;
    
    for (LHSpecify *s in self.product.specifies) {
        if (s.uid.integerValue == btn.tag) {
//            p.proCount = btn.selected ? @1 : @0;
//
            //s.pieces = 1;
            
            if (btn.selected) {
                s.pieces += 1;
                //self.product.pieces += 1;
            }else {
                s.pieces = 0;
                //self.product.pieces -= 1;
            }
            
            if (self.selectBlock) {
                self.selectBlock(self.product, s, btn.selected);
            }
            break;
        }
    }
}

- (void)setProduct:(LHProduct *)product {
    _product = product;
    
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:product.url] placeholderImage:kImagePHProductIcon];
    self.nameLabel.text = product.name;
    
    [self.allView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat x = 0.0, y = LHShopDetailMoreViewMarginV;
    for (LHSpecify *s in product.specifies) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = self.font;
        btn.contentEdgeInsets = UIEdgeInsetsMake(4, 12, 4, 12);
        btn.tag = [s.uid integerValue];
        [btn setTitle:s.name forState:UIControlStateNormal];
        [btn setTitleColor:ColorHex(0x666666) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        //[btn setTitleColor:ColorHex(0x666666) forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage exImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage exImageWithColor:ColorHex(0x29d8d6)] forState:UIControlStateSelected];
        //[btn setBackgroundImage:[UIImage exImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(productButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        
        if (self.totalWidth - x - btn.bounds.size.width < 0) {
            x = 0;
            y += self.btnHeight + LHShopDetailMoreViewMarginV;
        }
        btn.frame = CGRectMake(x, y, btn.bounds.size.width, btn.bounds.size.height);
        [self.allView addSubview:btn];
        [btn exSetBorder:ColorHex(0xdedede) width:1 radius:2];
        
        if (s.pieces != 0) {
            [btn setSelected:YES];
        }else {
            [btn setSelected:NO];
        }
        
        x += btn.bounds.size.width + LHShopDetailMoreViewMarginH;
    }
    
    y += self.btnHeight + LHShopDetailMoreViewMarginV;
    
    self.rootHeightConstraint.constant = self.logoWidthConstraint.constant - (self.logoOffsetConstraint.constant * -1) + 8 * 2 + y;
}

@end
