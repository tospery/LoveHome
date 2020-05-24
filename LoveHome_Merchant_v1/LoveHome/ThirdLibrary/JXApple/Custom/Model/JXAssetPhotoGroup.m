//
//  JXPhotoGroup.m
//  AuraU
//
//  Created by 杨建祥 on 15/3/21.
//  Copyright (c) 2015年 Thundersoft. All rights reserved.
//

#import "JXAssetPhotoGroup.h"
#import "JXAssetPhoto.h"

@interface JXAssetPhotoGroup ()
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@property (nonatomic, assign, readwrite) NSInteger numberOfPhotos;
@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSString *type;
@property (nonatomic, strong, readwrite) NSString *persistentID;
@property (nonatomic, strong, readwrite) NSString *url;
@property (nonatomic, strong, readwrite) UIImage *posterImage;
@end

@implementation JXAssetPhotoGroup
- (instancetype)initWithAssetsGroup:(ALAssetsGroup *)assetsGroup {
    if (self = [self init]) {
        _assetsGroup = assetsGroup;
        [_assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        _numberOfPhotos = [_assetsGroup numberOfAssets];
        _name = [_assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        _type = [_assetsGroup valueForProperty:ALAssetsGroupPropertyType];
        _persistentID = [_assetsGroup valueForProperty:ALAssetsGroupPropertyPersistentID];
        _url = [_assetsGroup valueForProperty:ALAssetsGroupPropertyURL];
        _posterImage = [UIImage imageWithCGImage:_assetsGroup.posterImage
                                           scale:1.0f
                                     orientation:UIImageOrientationUp];
    }
    return self;
}

- (void)fetchPhotosWithStartBlock:(void(^)())startBlock
                  completionBlock:(void(^)(NSArray *groups))completionBlock {
    NSMutableArray *photos = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (startBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                startBlock();
            });
        }

        [_assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result &&
                [[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                JXAssetPhoto *photo = [[JXAssetPhoto alloc] initWithAsset:result];
                [photos addObject:photo];
            } else {
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(photos);
                    });
                }
            }
        }];
    });
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ : %p, %@>",[self class], self, @{@"name":_name, @"type":_type, @"persistentID":_persistentID, @"url":_url, @"numberOfPhotos":[NSNumber numberWithInteger:_numberOfPhotos], @"posterImage":_posterImage}];
}
@end
