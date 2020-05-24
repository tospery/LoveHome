//
//  LHProductCell.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/12.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHProductListCell.h"
#import "LHSpecify.h"

@interface LHProductListCell ()
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *nameLabels;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *priceLabels;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *logoImageViews;
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *specifyViews;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *fgButtons;
@property (nonatomic, copy) LHProductListCellPressedBlock pressedBlock;
@end

@implementation LHProductListCell
- (void)awakeFromNib {
    // Initialization code
    UIFont *font;
    JXDeviceResolution resolution = [JXDevice sharedInstance].resolution;
    if (JXDeviceResolution640x960 == resolution
        || JXDeviceResolution640x1136 == resolution) {
        font = [UIFont systemFontOfSize:10.0f];
    }else if (JXDeviceResolution750x1334 == resolution) {
        font = [UIFont systemFontOfSize:12.0f];
    }else if (JXDeviceResolution1242x2208 == resolution) {
        font = [UIFont systemFontOfSize:14.0f];
    }else {
        font = [UIFont systemFontOfSize:10.0f];
    }
    
    for (UILabel *label in self.nameLabels) {
        label.font = font;
    }
    
    for (UILabel *label in self.priceLabels) {
        label.font = font;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setupPressedBlock:(LHProductListCellPressedBlock)pressedBlock {
    self.pressedBlock = pressedBlock;
}

- (void)reloadState {
    self.products = _products;
}

- (IBAction)pressed:(UIButton *)btn {
    if (_isOutOfService) {
        if (self.pressedBlock) {
            self.pressedBlock(self, nil, btn.selected);
        }
        return;
    }
    
    // 仅仅是商品的逻辑，以前一个商品必须有一个规格，现在如果商品没有规格就是商品本身
    LHProduct *product = self.products[btn.tag];
    if (product.specifies.count == 0) {
        return;
    }
    
    if (product.specifies.count == 1) {
        LHSpecify *s = product.specifies[0];
        btn.selected = !btn.selected;
        if (btn.selected) {
            s.pieces += 1;
        }else {
            s.pieces = 0;
        }
    }
    
    if (self.pressedBlock) {
        self.pressedBlock(self, product, btn.selected);
    }
}

- (void)setProducts:(NSArray *)products {
    _products = products;
    
    if (products.count == 0) {
        return;
    }
    
    for (UIView *view in self.specifyViews) {
        [view setHidden:YES];
    }
    
    for (int i = 0; i < products.count; ++i) {
        LHProduct *product = products[i];
        
        [(UIImageView *)self.logoImageViews[i] sd_setImageWithURL:[NSURL URLWithString:product.url] placeholderImage:kImagePHProductIcon];
        [(UILabel *)self.nameLabels[i] setText:product.name];
        
        if (product.specifies.count == 1) {
            product.price = [NSString stringWithFormat:@"%.2f", [[(LHSpecify *)product.specifies[0] price] floatValue]];
        }else if (product.specifies.count == 0) {
            product.price = @"0.00";
        }else {
            NSMutableArray *prices = [NSMutableArray array];
            for (LHSpecify *specify in product.specifies) {
                if (!JudgeContainerIsEmptyOrNull(product.price)) {
                    [prices addObject:specify.price];
                }
            }
            if (prices.count != 0) {
                NSArray *results = [prices sortedArrayUsingSelector:@selector(compare:)];
                product.price = [NSString stringWithFormat:@"%.2f~%.2f", [results[0] floatValue], [results[results.count - 1] floatValue]];
            }
        }
        [(UILabel *)self.priceLabels[i] setText:product.price];
        
//        if (product.pieces == 0) {
//            [(UIButton *)self.fgButtons[i] setSelected:NO];
//        }else {
//            [(UIButton *)self.fgButtons[i] setSelected:YES];
//        }
        
        NSInteger pieces = 0;
        for (LHSpecify *s in product.specifies) {
            pieces += s.pieces;
            s.url = product.url; // 为规格添加产品的图标
        }
        
        if (pieces == 0) {
            [(UIButton *)self.fgButtons[i] setSelected:NO];
        }else {
            [(UIButton *)self.fgButtons[i] setSelected:YES];
        }
        
        [(UIView *)self.specifyViews[i] setHidden:NO];
    }
}


+ (NSString *)identifier {
    return @"LHProductListCellIdentifier";
}

+ (CGFloat)height {
    static CGFloat result = 0;
    if (0 == result) {
        JXDeviceResolution resolution = [JXDevice sharedInstance].resolution;
        if (JXDeviceResolution640x960 == resolution
            || JXDeviceResolution640x1136 == resolution) {
            result = 104.0f;
        }else if (JXDeviceResolution750x1334 == resolution) {
            result = 119.0f;
        }else if (JXDeviceResolution1242x2208 == resolution) {
            result = 130.0f;
        }else {
            result = 104.0f;
        }
    }
    return result;
}
@end
