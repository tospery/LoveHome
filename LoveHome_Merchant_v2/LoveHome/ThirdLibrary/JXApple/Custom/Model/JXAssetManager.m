//
//  JXAssetManager.m
//  AuraU
//
//  Created by 杨建祥 on 15/3/21.
//  Copyright (c) 2015年 Thundersoft. All rights reserved.
//

#import "JXAssetManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "JXAssetPhotoGroup.h"

@interface JXAssetManager ()
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic, copy) void(^photoGroupStartBlock)();
@property (nonatomic, copy) void(^photoGroupSuccessBlock)(NSArray *groups);
@property (nonatomic, copy) void(^photoGroupFailureBlock)(NSError *error);
@property (nonatomic, copy) void(^photoGroupCompletionBlock)();
@end

@implementation JXAssetManager
#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return self;
}

#pragma mark - Private methods
- (void)callbackForPhotoGroupStart {
    if (_photoGroupStartBlock) {
        _photoGroupStartBlock();
    }
}

- (void)callbackForPhotoGroupCompletion {
    if (_photoGroupCompletionBlock) {
        _photoGroupCompletionBlock();
    }
}

#pragma mark - Public methods
- (void)setupPhotoGroupBlocksWithStart:(void(^)())startBlock
                               success:(void(^)(NSArray *groups))successBlock
                               failure:(void(^)(NSError *error))failureBlock
                            completion:(void(^)())completionBlock {
    _photoGroupStartBlock = startBlock;
    _photoGroupSuccessBlock = successBlock;
    _photoGroupFailureBlock = failureBlock;
    _photoGroupCompletionBlock = completionBlock;
}

- (void)fetchPhotoGroup {
    NSMutableArray *photoGroups = [NSMutableArray arrayWithCapacity:1];
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_photoGroupFailureBlock) {
                _photoGroupFailureBlock(error);
            }
            [self callbackForPhotoGroupCompletion];
        });
    };
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group,BOOL *stop) {
        if (group) {
            JXAssetPhotoGroup *photoGroup = [[JXAssetPhotoGroup alloc] initWithAssetsGroup:group];
            [photoGroups addObject:photoGroup];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_photoGroupSuccessBlock) {
                    _photoGroupSuccessBlock(photoGroups);
                }
                [self callbackForPhotoGroupCompletion];
            });
        }
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self callbackForPhotoGroupStart];
        });
        [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
    });
}

#pragma mark - Class methods
+ (JXAssetManager *)sharedInstance {
    static JXAssetManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JXAssetManager alloc] init];
    });
    return instance;
}
@end
