//
//  HomeHeaderViewModel.h
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/19.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXViewModel.h"
#import "OrderCount.h"

@interface HomeHeaderViewModel : JXViewModel // YJX_TODO 统一继承至JXViewModel

//@property (nonatomic, strong, readonly) OCTUser *user;
//
///// The contentOffset of the scroll view.
//@property (nonatomic, assign) CGPoint contentOffset;
//
//@property (nonatomic, strong) RACCommand *operationCommand;
//@property (nonatomic, strong) RACCommand *followersCommand;
//@property (nonatomic, strong) RACCommand *repositoriesCommand;
//@property (nonatomic, strong) RACCommand *followingCommand;
//
//- (instancetype)initWithUser:(OCTUser *)user;

//@property (nonatomic, strong) User *user;

@property (nonatomic, assign) NSInteger unreadCount;
@property (nonatomic, assign) NSInteger visitCount;
@property (nonatomic, strong) OrderCount *orderCount;

//@property (nonatomic, strong, readonly) RACCommand *requestRemoteDataCommand;

@property (nonatomic, strong, readonly) RACCommand *requestOrderCountCommand;
@property (nonatomic, strong, readonly) RACCommand *requestUnreadCountCommand;
@property (nonatomic, strong, readonly) RACCommand *requestVisitTotalCommand;

//- (instancetype)initWithUser:(User *)user;
//- (void)initialize;
@end
