//
//  LHNearbyMapViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/31.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHBaseViewController.h"

@interface LHShopMapViewController : LHBaseViewController <BMKMapViewDelegate, BMKLocationServiceDelegate>
@property (nonatomic, assign) BOOL isSingle;
- (instancetype)initWithShops:(NSArray *)shops;
@end
