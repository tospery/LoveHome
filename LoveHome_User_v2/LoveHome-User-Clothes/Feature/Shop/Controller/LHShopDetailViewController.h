//
//  LHShopDetailViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/3.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHBaseViewController.h"
#import "MWPhotoBrowser.h"

@interface LHShopDetailViewController : LHBaseViewController <UMSocialUIDelegate, MWPhotoBrowserDelegate>
@property (nonatomic, strong) LHShopDetailViewController *fristVC;
@property (nonatomic, assign) BOOL outOfService;
@property (nonatomic, assign) BOOL activityFlag;

@property (nonatomic, assign) LHEntryFrom from;
@property (nonatomic, assign) CGFloat distanceForFavorite;

//@property (nonatomic, assign) BOOL isFromFavorite;
//@property (nonatomic, assign) BOOL isPresented;
//@property (nonatomic, assign) LHShopListFrom from;
////@property (nonatomic, assign) NSUInteger productsInCart;

//- (instancetype)initWithShop:(LHShop *)shop;
- (instancetype)initWithShopid:(NSInteger)shopid;
//- (instancetype)initWithShopid:(NSInteger)shopid activityId:(NSInteger)activityId;

@end
