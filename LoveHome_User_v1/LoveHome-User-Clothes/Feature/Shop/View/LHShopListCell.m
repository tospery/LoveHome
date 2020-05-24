//
//  LHShopListCell.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/16.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHShopListCell.h"
#import "LHStarView.h"

@interface LHShopListCell ()
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;

@property (nonatomic, weak) IBOutlet UIView *cartView;
@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;
@property (nonatomic, weak) IBOutlet LHStarView *starView;
@end


@implementation LHShopListCell

- (void)awakeFromNib {
    // Initialization code
    self.cartView.layer.shadowColor = JXColorHex(0xE1E1E1).CGColor;
    self.cartView.layer.shadowOpacity = 0.8;
    self.cartView.layer.shadowRadius = 2;
    self.cartView.layer.shadowOffset = CGSizeMake(0, -2);
    self.cartView.clipsToBounds = NO;
    
    [_logoImageView exCircleWithColor:[UIColor clearColor] border:0.0f];
    
    self.starView.enabled = NO;
    self.starView.level = 3;
    self.starView.userInteractionEnabled = NO;
    [self.starView loadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShop:(LHShop *)shop {
    _shop = shop;
    
        [_logoImageView sd_setImageWithURL:[NSURL URLWithString:shop.url] placeholderImage:kImagePHShopLogo];
    
    if (shop.distance >= 1000) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm", ((CGFloat)shop.distance / 1000)];
    }else {
        self.distanceLabel.text = [NSString stringWithFormat:@"%ldm", (long)shop.distance];
    }
    
    self.nameLabel.text = shop.shopName;
    self.addressLabel.text = shop.address;
    self.starView.level = shop.level;
    [self.starView loadData];
}

- (void)setActivityShop:(LHActivityShop *)activityShop {
    _activityShop = activityShop;
    
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:activityShop.logourl] placeholderImage:kImagePHShopLogo];
    if (activityShop.distance >= 1000) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm", ((CGFloat)activityShop.distance / 1000)];
    }else {
        self.distanceLabel.text = [NSString stringWithFormat:@"%ldm", (long)activityShop.distance];
    }
    
    self.nameLabel.text = activityShop.shopname;
    self.addressLabel.text = activityShop.address;
    self.starView.level = activityShop.starLevel;
    [self.starView loadData];
}

- (void)setFavorite:(LHFavorite *)favorite {
    _favorite = favorite;
    
     [_logoImageView sd_setImageWithURL:[NSURL URLWithString:favorite.logoUrl] placeholderImage:kImagePHShopLogo];
    
    if (favorite.distance >= 1000) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm", ((CGFloat)favorite.distance / 1000)];
    }else {
        self.distanceLabel.text = [NSString stringWithFormat:@"%ldm", (long)favorite.distance];
    }
    
    self.nameLabel.text = favorite.shopName;
    self.addressLabel.text = favorite.address;
    self.starView.level = favorite.starLevel;
    [self.starView loadData];
}

+ (NSString *)identifier {
    return @"LHShopListCellIdentifier";
}

+ (CGFloat)height {
    return 100.0f;
}
@end
