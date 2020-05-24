//
//  LHCollection.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/20.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHMessage.h"
#import "LHBalanceFlow.h"
#import "LHLovebeanWrapper.h"
#import "LHCoupon.h"
#import "LHShop.h"
#import "LHActivityShop.h"
#import "LHActivityCenter.h"

@interface LHResponseCollection : NSObject
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger totalRows;
@end

@interface LHMessageCollection : LHResponseCollection
@property (nonatomic, strong) NSArray *messages;

@end

@interface LHBalanceFlowCollection : LHResponseCollection
@property (nonatomic, strong) NSArray *balanceFlows;

@end


@interface LHLovebeanWrapperCollection : LHResponseCollection
@property (nonatomic, strong) NSArray *lovebeanWrappers;

@end

@interface LHOrderCollection : LHResponseCollection
@property (nonatomic, strong) NSArray *orders;

@end


@interface LHShopList : LHResponseCollection
//@property (nonatomic, assign) NSUInteger total;
//@property (nonatomic, assign) NSUInteger size;
@property (nonatomic, strong) NSArray *shops;

@end


@interface LHActivityShopList : LHResponseCollection
@property (nonatomic, strong) NSArray *shops;

@end

@interface LHActivityCenterList : LHResponseCollection
@property (nonatomic, strong) NSArray *activities;

@end

