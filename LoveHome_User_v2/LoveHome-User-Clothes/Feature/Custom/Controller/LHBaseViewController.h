//
//  LHBaseViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/16.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JXBasePhotoWillSuccessBlock)(UIImage *image);
typedef void(^JXBasePhotoDidSuccessBlock)(UIImage *image);
typedef void(^JXBaseLocationSuccessBlock)(CLPlacemark *placemark);
typedef void(^JXBaseFailureBlock)(NSError *error);

@interface LHBaseViewController : JXBaseViewController /*<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>*/
//
///**
// *  展示一个图片选择Sheet
// *
// *  @param willSuccess 将要成功
// *  @param didSuccess  已经成功
// *  @param failure     失败
// */
//- (void)displayPhotoSheetWithWillSuccess:(JXBasePhotoWillSuccessBlock)willSuccess
//                              didSuccess:(JXBasePhotoDidSuccessBlock)didSuccess
//                                 failure:(JXBaseFailureBlock)failure;

///**
// *  HTTP成功回调的通用处理
// *
// *  @param operation 操作
// *  @param error     错误
// */
//- (void)handleSuccessWithOperation:(AFHTTPRequestOperation *)operation error:(NSError *)error view:(UIView *)view;
//
///**
// *  HTTP失败回调的通用处理
// *
// *  @param operation 操作
// *  @param error     错误
// *  @param view      loading for view
// *  @param retry     重试
// */
//- (void)handleFailureWithOperation:(AFHTTPRequestOperation *)operation
//                             error:(NSError *)error
//                              view:(UIView *)view
//                             retry:(void (^)(void))retry;
//
//- (void)handleFailureWithOperation:(AFHTTPRequestOperation *)operation
//                           message:(NSString *)message
//                              view:(UIView *)view
//                             retry:(void (^)(void))retry;
@end
