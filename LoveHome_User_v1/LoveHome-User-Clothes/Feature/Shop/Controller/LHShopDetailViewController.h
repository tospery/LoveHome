//
//  LHShopDetailViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/3.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHBaseViewController.h"

@interface LHShopDetailViewController : LHBaseViewController <UMSocialUIDelegate>

@property (nonatomic, assign) LHEntryFrom from;
@property (nonatomic, assign) CGFloat distanceForFavorite;

//@property (nonatomic, assign) BOOL isFromFavorite;
//@property (nonatomic, assign) BOOL isPresented;
//@property (nonatomic, assign) LHShopListFrom from;
////@property (nonatomic, assign) NSUInteger productsInCart;

- (instancetype)initWithShop:(LHShop *)shop;
- (instancetype)initWithShopid:(NSInteger)shopid;

@end
