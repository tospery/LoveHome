//
//  JXAssetPhoto.m
//  AuraU
//
//  Created by 杨建祥 on 15/3/21.
//  Copyright (c) 2015年 Thundersoft. All rights reserved.
//

#import "JXAssetPhoto.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface JXAssetPhoto ()
@property (nonatomic, strong) ALAsset *asset;

@property (nonatomic, strong, readwrite) NSURL *url;
@property (nonatomic, strong, readwrite) UIImage *thumbnail;
@end

@implementation JXAssetPhoto
- (instancetype)initWithAsset:(ALAsset *)asset {
    if (self = [self init]) {
        _asset = asset;
        
        _url = _asset.defaultRepresentation.url;
        _thumbnail = [UIImage imageWithCGImage:_asset.thumbnail];
    }
    return self;
}
@end
