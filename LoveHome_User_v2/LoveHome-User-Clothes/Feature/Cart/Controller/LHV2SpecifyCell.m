//
//  LHV2SpecifyCell.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 16/3/7.
//  Copyright © 2016年 艾维科思. All rights reserved.
//

#import "LHV2SpecifyCell.h"

@interface LHV2SpecifyCell ()
@property (nonatomic, strong) LHSpecify *specify;

@property (nonatomic, weak) IBOutlet UIView *showView;
@property (nonatomic, weak) IBOutlet UIView *editView;

@property (nonatomic, weak) IBOutlet UIButton *logoButton;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UIButton *countButton;

@property (nonatomic, weak) IBOutlet UIImageView *activityImageView;

@property (nonatomic, weak) IBOutlet UILabel *actNameLabel;
@property (nonatomic, weak) IBOutlet UIView *actBgView;

@property (nonatomic, weak) IBOutlet UIView *dueBgView;
@end

@implementation LHV2SpecifyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

    if (self.countCallback) {
        self.countCallback(NO);
    }
}

- (IBAction)plusButtonPressed:(UIButton *)btn {
    if (self.countCallback) {
        self.countCallback(YES);
    }
}

- (IBAction)delButtonPressed:(UIButton *)btn {
    if (self.deleteCallback) {
        self.deleteCallback(self.specify);
    }
}

- (void)configSpecify:(LHSpecify *)specify inCart:(BOOL)inCart {
    _specify = specify;
    
    if (specify.activityId.length == 0) {
        [self.activityImageView setHidden:YES];
        [self.actBgView setHidden:YES];
        self.actNameLabel.text = nil;
    }else {
        [self.activityImageView setHidden:NO];
        [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:specify.actProductImgUrl] placeholderImage:self.activityImageView.image];
        if (specify.actCategoryFlag) {
            [self.actBgView setHidden:NO];
            self.actNameLabel.text = [NSString stringWithFormat:@"活动：%@", specify.activityTitle];
        }else {
            [self.actBgView setHidden:YES];
            self.actNameLabel.text = nil;
        }
    }
    self.nameLabel.text = specify.name;
    
    if (specify.dueFlag) {
        [self.dueBgView setHidden:NO];
        [self.checkButton setHidden:YES];
        self.widthConstraint.constant = 8.0f;
    }else {
        [self.dueBgView setHidden:YES];
        [self.checkButton setHidden:NO];
        self.widthConstraint.constant = 50.0f;
    }
    
    [self.logoButton sd_setBackgroundImageWithURL:[NSURL URLWithString:specify.url] forState:UIControlStateNormal placeholderImage:kImagePHProductIcon];
    self.countLabel.text = [NSString stringWithFormat:@"x%ld", (long)specify.pieces];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", specify.price.floatValue];
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

+ (NSString *)identifier {
    return @"LHV2SpecifyCellIdentifier";
}

+ (CGFloat)heightWithSpecify:(LHSpecify *)specify {
    return specify.actCategoryFlag ? 104 : 81;
}
@end


