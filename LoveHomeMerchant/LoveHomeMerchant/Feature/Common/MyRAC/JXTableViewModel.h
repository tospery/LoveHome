//
//  JXTableViewModel.h
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/19.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "JXViewModel.h"

@interface JXTableViewModel : JXViewModel
/// The data source of table view.
@property (nonatomic, copy) NSArray *dataSource;

/// The list of section titles to display in section index view.
@property (nonatomic, copy) NSArray *sectionIndexTitles;

@property (nonatomic, assign) NSUInteger page;      // YJX_TODO JXPage
@property (nonatomic, assign) NSUInteger perPage;

@property (nonatomic, assign) BOOL shouldPullToRefresh;
@property (nonatomic, assign) BOOL shouldInfiniteScrolling;

@property (nonatomic, copy) NSString *keyword;

@property (nonatomic, strong) RACCommand *didSelectCommand;
@property (nonatomic, strong, readonly) RACCommand *requestRemoteDataCommand;

- (id)fetchLocalData;

- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter;

- (NSUInteger)offsetForPage:(NSUInteger)page;

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page;

@end
