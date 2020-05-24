//
//  JXBannerView.h
//  iOSLibrary
//
//  Created by 杨建祥 on 15/5/9.
//  Copyright (c) 2015年 Thundersoft. All rights reserved.
//

#if defined(JXEnableMasonry) && defined(JXEnableSDWebImage)
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JXBannerViewDirection){
    JXBannerViewDirectionLandscape,
    JXBannerViewDirectionPortait
};


@interface JXBannerView : UIView <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImage *placeholderImage;

- (void)setupWithLocalImages:(NSArray *)images
                      tapped:(void(^)(NSInteger index))tapped;

- (void)setupWithWebImages:(NSArray *)urlStrings
                    cached:(void(^)())cached
                    tapped:(void(^)(NSInteger index))tapped;

- (void)startRolling;
@end
#endif