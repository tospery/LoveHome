//
//  HomeHeaderViewModel.m
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/19.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "HomeHeaderViewModel.h"

@interface HomeHeaderViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;

@property (nonatomic, strong, readwrite) RACCommand *requestOrderCountCommand;
@property (nonatomic, strong, readwrite) RACCommand *requestUnreadCountCommand;
@property (nonatomic, strong, readwrite) RACCommand *requestVisitTotalCommand;
@end

@implementation HomeHeaderViewModel
//- (instancetype)initWithUser:(User *)user {
//    if (self = [super init]) {
//        _user = user;
//    }
//    return self;
//}

- (void)initialize {
    [super initialize];
    
    //    RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    //    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    //
    //    [[[fetchLocalDataSignal
    //       merge:requestRemoteDataSignal]
    //     	deliverOnMainThread]
    //    	subscribeNext:^(OCTUser *user) {
    //            @strongify(self)
    //            [self willChangeValueForKey:@"user"];
    //            user.followingStatus = self.user.followingStatus;
    //            [self.user mergeValuesForKeysFromModel:user];
    //            [self didChangeValueForKey:@"user"];
    //        }];
    
    //    @weakify(self)
    //    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    //        @strongify(self)
    //        return [[self requestRemoteDataSignalWithParam:input] takeUntil:self.rac_willDeallocSignal];
    //    }];
    //
    //    RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    //    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    //
    ////    [[[[[fetchLocalDataSignal merge:requestRemoteDataSignal] ignore:nil] distinctUntilChanged] deliverOnMainThread] subscribeNext:^(OrderCount *orderCount) {
    //////        @strongify(self)
    //////        if (orderCount) {
    //////            self.orderCount = orderCount;
    //////            [[MemoryCache sharedInstance] setObject:orderCount forKey:MemoryCacheOrderCount toCached:YES];
    //////        }
    ////    }];
    //
    ////    [[[[fetchLocalDataSignal merge:requestRemoteDataSignal] ignore:nil] distinctUntilChanged] map:^id(id value) {
    ////        if (![value isKindOfClass:[RACTuple class]]) {
    ////            return RACTuplePack(value);
    ////        }
    ////        return value;
    ////    }];
    
    @weakify(self)
    
    // 订单个数
    self.requestOrderCountCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[self requestOrderCountSignal] takeUntil:self.rac_willDeallocSignal];
    }];
    RACSignal *fetchOrderCountSignal = [RACSignal return:[self fetchOrderCount]];
    RACSignal *requestOrderCountSignal = self.requestOrderCountCommand.executionSignals.switchToLatest;
    [[[[fetchOrderCountSignal merge:requestOrderCountSignal] ignore:nil] distinctUntilChanged] subscribeNext:^(OrderCount *orderCount) {
        @strongify(self)
        self.orderCount = orderCount;
        [[MemoryCache sharedInstance] setObject:orderCount forKey:MemoryCacheOrderCount toCached:YES];
    }];
    
    // 未读消息
    self.requestUnreadCountCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[self requestUnreadCountSignal] takeUntil:self.rac_willDeallocSignal];
    }];
    RACSignal *fetchUnreadCountSignal = [RACSignal return:[self fetchUnreadCount]];
    RACSignal *requestUnreadCountSignal = self.requestUnreadCountCommand.executionSignals.switchToLatest;
    [[[fetchUnreadCountSignal merge:requestUnreadCountSignal] distinctUntilChanged] subscribeNext:^(NSNumber *unreadCount) {
        @strongify(self)
        self.unreadCount = unreadCount.integerValue;
        [MemoryCache sharedInstance].unreadCount = unreadCount.integerValue;
    }];
    
    // 昨日访问量
    self.requestVisitTotalCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[self requestVisitCountSignal] takeUntil:self.rac_willDeallocSignal];
    }];
    RACSignal *fetchVisitTotalSignal = [RACSignal return:[self fetchVisitCount]];
    RACSignal *requestVisitTotalSignal = self.requestVisitTotalCommand.executionSignals.switchToLatest;
    [[[fetchVisitTotalSignal merge:requestVisitTotalSignal] distinctUntilChanged] subscribeNext:^(NSNumber *visitCount) {
        @strongify(self)
        self.visitCount = visitCount.integerValue;
        [MemoryCache sharedInstance].visitCount = visitCount.integerValue;
    }];
}

- (OrderCount *)fetchOrderCount {
    return [OrderCount fetch];
}

- (RACSignal *)requestOrderCountSignal {
    return [self.services.webAPIService requestWithParam:[HTTPRequestParam paramObtainOrderCount] class:OrderCount.class];
}

- (NSNumber *)fetchUnreadCount {
    return @([MemoryCache sharedInstance].unreadCount);
}

- (RACSignal *)requestUnreadCountSignal {
    return [self.services.webAPIService requestWithParam:[HTTPRequestParam paramObtainUnreadCount]];
}

- (NSNumber *)fetchVisitCount {
    return @([MemoryCache sharedInstance].visitCount);
}

- (RACSignal *)requestVisitCountSignal {
    return [self.services.webAPIService requestWithParam:[HTTPRequestParam paramObtainVisitCountYesterday]];
}

//- (OrderCount *)fetchLocalData {
////    // RACTuplePack
////    RACTuplePack
////    return [OrderCount fetch];
//    return nil;
//}
//
////- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
////    return [[self.services.client
////             fetchUserInfoForUser:self.user]
////            doNext:^(OCTUser *user) {
////                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
////                    [user mrc_saveOrUpdate];
////                });
////            }];
////}
//- (RACSignal *)requestRemoteDataSignalWithParam:(id)param {
//    return [self.services.webAPIService requestWithParam:[HTTPRequestParam paramObtainOrderCount] class:OrderCount.class];
//}
@end


//@interface MRCAvatarHeaderViewModel ()
//
//@property (nonatomic, strong, readwrite) OCTUser *user;
//
//@end
//
//@implementation MRCAvatarHeaderViewModel
//
//- (instancetype)initWithUser:(OCTUser *)user {
//    self = [super init];
//    if (self) {
//        self.user = user;
//    }
//    return self;
//}
//
//@end