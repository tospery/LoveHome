//
//  LHOrderConfirmViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/6.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHBaseViewController.h"

//typedef NS_ENUM(NSInteger, LHOrderConfirmFrom){
//    LHOrderConfirmFromCart,
//    LHOrderConfirmFromActivity,
//    LHOrderConfirmFromOrder,
//    LHOrderConfirmFromSearch
//};

@interface LHOrderConfirmViewController : LHBaseViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) LHEntryFrom from;

- (instancetype)initWithCartShops:(NSArray *)cartShops;

@end
