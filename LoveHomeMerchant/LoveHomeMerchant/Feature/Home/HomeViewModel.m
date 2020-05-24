//
//  HomeViewModel.m
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/19.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "HomeViewModel.h"

@interface HomeViewModel ()
@property (nonatomic, strong, readwrite) HomeHeaderViewModel *headerViewModel;
@end

@implementation HomeViewModel
- (void)initialize {
    [super initialize];
    
    self.headerViewModel = [[HomeHeaderViewModel alloc] initWithServices:self.services params:nil];
//    self.headerViewModel = [[HomeHeaderViewModel alloc] initWithUser:self.user];
//    [self.headerViewModel initialize];
}

//- (void)initialize {
//    [super initialize];
//    
//    self.title = @"Profile";
//    
//    self.avatarHeaderViewModel = [[MRCAvatarHeaderViewModel alloc] initWithUser:self.user];
//    
//    @weakify(self)
//    self.avatarHeaderViewModel.followersCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        @strongify(self)
//        MRCUserListViewModel *viewModel = [[MRCUserListViewModel alloc] initWithServices:self.services
//                                                                                  params:@{ @"type": @0, @"user": self.user }];
//        [self.services pushViewModel:viewModel animated:YES];
//        return [RACSignal empty];
//    }];
//    
//    self.avatarHeaderViewModel.repositoriesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        @strongify(self)
//        MRCPublicReposViewModel *viewModel = [[MRCPublicReposViewModel alloc] initWithServices:self.services
//                                                                                        params:@{ @"user": self.user }];
//        [self.services pushViewModel:viewModel animated:YES];
//        return [RACSignal empty];
//    }];
//    
//    self.avatarHeaderViewModel.followingCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        @strongify(self)
//        MRCUserListViewModel *viewModel = [[MRCUserListViewModel alloc] initWithServices:self.services
//                                                                                  params:@{ @"type": @1, @"user": self.user }];
//        [self.services pushViewModel:viewModel animated:YES];
//        return [RACSignal empty];
//    }];
//    
//    id (^map)(NSString *) = ^(NSString *value) {
//        return (value.length > 0 && ![value isEqualToString:@"(null)"]) ? value : MRC_EMPTY_PLACEHOLDER;
//    };
//    
//    RAC(self, company)  = [RACObserve(self.user, company) map:map];
//    RAC(self, location) = [RACObserve(self.user, location) map:map];
//    RAC(self, email)    = [RACObserve(self.user, email) map:map];
//    RAC(self, blog)     = [RACObserve(self.user, blog) map:map];
//    
//    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
//        @strongify(self)
//        if (indexPath.section == 1 && indexPath.row == 0) {
//            MRCSettingsViewModel *settingsViewModel = [[MRCSettingsViewModel alloc] initWithServices:self.services params:nil];
//            [self.services pushViewModel:settingsViewModel animated:YES];
//        }
//        return [RACSignal empty];
//    }];
//    
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
//}
//
//- (OCTUser *)fetchLocalData {
//    return [OCTUser mrc_fetchUser:self.user];
//}
//
//- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
//    return [[self.services.client
//             fetchUserInfoForUser:self.user]
//            doNext:^(OCTUser *user) {
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    [user mrc_saveOrUpdate];
//                });
//            }];
//}

@end
