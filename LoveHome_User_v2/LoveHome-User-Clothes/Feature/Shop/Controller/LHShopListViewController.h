//
//  LHShopListViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/16.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHBaseViewController.h"
#import "JCSegmentConditionChildMenu.h"
#import "JCSegmentMenuChildItemView.h"
#import "LHActivity.h"

@interface LHShopListViewController : LHBaseViewController <UITableViewDataSource, UITableViewDelegate, JCSegmentConditionChildMenuDelegate, JCSegmentConditionMenuDeleagate, JCSegmentMenuBaseItemViewDelegate, BMKLocationServiceDelegate>
@property (nonatomic, strong) LHActivity *activity;
@property (nonatomic, assign) LHEntryFrom from;
@property (nonatomic, strong) NSArray *shopsForCoupon;

@end
