//
//  LHCouponMineCell.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/2.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHCouponCell.h"

@interface LHCouponCell ()
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *scopeLabel;
@property (nonatomic, weak) IBOutlet UILabel *conditionLabel;
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UILabel *validLabel;
@property (nonatomic, weak) IBOutlet UIButton *receiveButton;
@property (nonatomic, weak) IBOutlet UIImageView *statusImageView;
@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet UIImageView *arrowImageView;
@end

@implementation LHCouponCell

- (void)awakeFromNib {
    // Initialization code
    [self.receiveButton exSetBorder:[UIColor clearColor] width:0.0 radius:2.0];
    [self.receiveButton setBackgroundImage:[UIImage exImageWithColor:[UIColor orangeColor]] forState:UIControlStateHighlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)receiveButtonPressed:(id)sender {
    if (self.callback) {
        self.callback();
    }
}


- (void)setCoupon:(LHCoupon *)coupon {
    _coupon = coupon;
    
    self.priceLabel.text = [NSString stringWithFormat:@"%.1f", coupon.price];
    self.scopeLabel.text = coupon.useScope;
    self.conditionLabel.text = coupon.couponType;
    self.typeLabel.text = coupon.couponScope;
    self.validLabel.text = [NSString stringWithFormat:@"%@至%@", coupon.effectiveDate, coupon.expiryDate];
    
    [self.arrowImageView setHidden:YES];
    if (LHCouponStatusNormal == coupon.status) {
        self.bgImageView.image = [UIImage imageNamed:@"bg_coupon_normal"];
        [self.statusImageView setHidden:YES];
        [self.receiveButton setHidden:YES];
        [self.arrowImageView setHidden:NO];
    }else if (LHCouponStatusUsed == coupon.status) {
        self.bgImageView.image = [UIImage imageNamed:@"bg_coupon_disabled"];
        self.statusImageView.image = [UIImage imageNamed:@"ic_coupon_used"];
        [self.statusImageView setHidden:NO];
        [self.receiveButton setHidden:YES];
    }else if (LHCouponStatusExpired == coupon.status) {
        self.bgImageView.image = [UIImage imageNamed:@"bg_coupon_disabled"];
        self.statusImageView.image = [UIImage imageNamed:@"ic_coupon_expired"];
        [self.statusImageView setHidden:NO];
        [self.receiveButton setHidden:YES];
    }else {
        [self.statusImageView setHidden:YES];
        [self.receiveButton setHidden:NO];
    }
}

+ (NSString *)identifier {
    return @"LHCouponCellIdentifier";
}

+ (CGFloat)height {
    return 108.0f;
}

@end
