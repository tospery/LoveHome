////
////  JXLoadingView.h
////  MyiOS
////
////  Created by Thundersoft on 10/19/14.
////  Copyright (c) 2014 Thundersoft. All rights reserved.
////
//
//#ifdef JXEnableMasonry
//typedef NS_ENUM(NSInteger, JXLoadingViewType){
//    JXLoadingViewTypeActivity,
//    JXLoadingViewTypeGIF
//};
//
//typedef NS_ENUM(NSInteger, JXLoadingViewSize){
//    JXLoadingViewSizeFull,  // 全屏
//    JXLoadingViewSizePart   // 部分
//};
//
//typedef void (^JXLoadingViewRetryBlock)(void);
//
//@interface JXLoadingView : UIView
//+ (void)showProcessingAddedTo:(UIView *)view;
//+ (void)showFailedAddedTo:(UIView *)view image:(UIImage *)image message:(NSString *)message retry:(JXLoadingViewRetryBlock)retry;
//+ (void)showFailedAddedTo:(UIView *)view error:(NSError *)error retry:(void (^)(void))retry;
//
//+ (void)hideForView:(UIView *)view;
//
//
//+ (JXLoadingViewType)type;
//+ (void)setType:(JXLoadingViewType)type;
//+ (NSData *)gifData;
//+ (void)setGifData:(NSData *)data;
//+ (UIFont *)messageFont;
//+ (void)setMessageFont:(UIFont *)font;
//@end
//#endif