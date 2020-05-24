//
//  JXAssetPhoto.h
//  AuraU
//
//  Created by 杨建祥 on 15/3/21.
//  Copyright (c) 2015年 Thundersoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface JXAssetPhoto : NSObject
- (instancetype)initWithAsset:(ALAsset *)asset;

@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, strong, readonly) UIImage *thumbnail;
@end
