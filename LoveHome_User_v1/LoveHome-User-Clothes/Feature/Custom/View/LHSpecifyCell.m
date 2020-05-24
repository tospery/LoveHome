//
//  LHSpecifyCell.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/11.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHSpecifyCell.h"

@interface LHSpecifyCell ()
@property (nonatomic, strong) LHSpecify *specify;

@property (nonatomic, weak) IBOutlet UIView *showView;
@property (nonatomic, weak) IBOutlet UIView *editView;

@property (nonatomic, weak) IBOutlet UIButton *logoButton;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UIButton *countButton;
@end

@implementation LHSpecifyCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)checkButtonPressed:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.specify.selected = btn.selected;
    
    if (self.checkCallback) {
        self.checkCallback();
    }
}

- (IBAction)minusButtonPressed:(UIButton *)btn {
    if (self.specify.pieces == 1) {
        return;
    }
    self.specify.pieces -= 1;
    [self.countButton setTitle:[NSString stringWithFormat:@"%ld", (long)self.specify.pieces] forState:UIControlStateNormal];
    
    if (self.countCallback) {
        self.countCallback();
    }
}

- (IBAction)plusButtonPressed:(UIButton *)btn {
    self.specify.pieces += 1;
    [self.countButton setTitle:[NSString stringWithFormat:@"%ld", (long)self.specify.pieces] forState:UIControlStateNormal];
    self.countLabel.text = [NSString stringWithFormat:@"x%ld", (long)self.specify.pieces];
    
    if (self.countCallback) {
        self.countCallback();
    }
}

- (IBAction)delButtonPressed:(UIButton *)btn {
    if (self.deleteCallback) {
        self.deleteCallback(self.specify);
    }
}

- (void)configSpecify:(LHSpecify *)specify inCart:(BOOL)inCart {
    _specify = specify;
    
    [self.logoButton sd_setBackgroundImageWithURL:[NSURL URLWithString:specify.url] forState:UIControlStateNormal placeholderImage:kImagePHProductIcon];
    self.nameLabel.text = specify.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", specify.price.floatValue];
    self.countLabel.text = [NSString stringWithFormat:@"x%ld", (long)specify.pieces];
    [self.countButton setTitle:[NSString stringWithFormat:@"%ld", (long)specify.pieces] forState:UIControlStateNormal];
    
    self.checkButton.selected = specify.selected;
    
    if (inCart) {
        if (specify.isEditing) {
            [_editView setHidden:NO];
            [_showView setHidden:YES];
        }else {
            [_editView setHidden:YES];
            [_showView setHidden:NO];
        }
    }else {
        [_editView setHidden:YES];
        [_showView setHidden:NO];
    }
}

//- (void)setSpecify:(LHSpecify *)specify {
//    _specify = specify;
//    
//    [self.logoButton sd_setBackgroundImageWithURL:[NSURL URLWithString:specify.url] forState:UIControlStateNormal placeholderImage:kImagePHProductIcon];
//    self.nameLabel.text = specify.name;
//    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", specify.price.floatValue];
//    self.countLabel.text = [NSString stringWithFormat:@"x%ld", (long)specify.pieces];
//    [self.countButton setTitle:[NSString stringWithFormat:@"%ld", (long)specify.pieces] forState:UIControlStateNormal];
//    
//    self.checkButton.selected = specify.selected;
//    
//    if (specify.isEditing) {
//        [_editView setHidden:NO];
//        [_showView setHidden:YES];
//    }else {
//        [_editView setHidden:YES];
//        [_showView setHidden:NO];
//    }
//}

+ (NSString *)identifier {
    return @"LHSpecifyCellIdentifier";
}

+ (CGFloat)height {
    return 80.0f;
}
        
@end
