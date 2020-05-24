//
//  MyCollectionViewCell.m
//  SGCollectionViewGo
//
//  Created by 石光 on 16/3/3.
//  Copyright © 2016年 CDCalabar. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createSubs];
    }
    return self;
}

- (void)createSubs
{   self.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    self.imageView.layer.borderWidth = 0.5;
    self.imageView.layer.borderColor = JXColorHex(0xeeeeee).CGColor;
    _imageView.layer.cornerRadius = 2;
    _imageView.layer.masksToBounds = YES;
    _imageView.clipsToBounds = YES;
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 0, 15, 15)];
    
    // self.imageView.backgroundColor = [UIColor lightGrayColor];
    self.TLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 60, 30)];
    self.TLabel.font = [UIFont systemFontOfSize:11];
    self.TLabel.numberOfLines = 0;
    self.TLabel.textAlignment = NSTextAlignmentCenter;
    _TLabel.textColor = JXColorHex(0x666666);
   // self.TLabel.backgroundColor = [UIColor whiteColor];
    self.NLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 60, 15)];
    self.NLabel.font = [UIFont systemFontOfSize:12];
    self.NLabel.textAlignment = NSTextAlignmentCenter;
    self.NLabel.textColor = JXColorHex(0x666666);
   // self.NLabel.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:_imageView];
    [self.contentView addSubview:_iconImageView];
    [self.contentView bringSubviewToFront:_iconImageView];
    [self.contentView addSubview:_TLabel];
    [self.contentView addSubview:_NLabel];
}

@end
