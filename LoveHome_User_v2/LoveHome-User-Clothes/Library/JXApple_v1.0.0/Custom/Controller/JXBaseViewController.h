//
//  JXBaseViewController.h
//  iOSLibrary
//
//  Created by 杨建祥 on 15/7/26.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^JXBasePhotoWillSuccessBlock)(UIImage *image);
typedef void(^JXBasePhotoDidSuccessBlock)(UIImage *image);
typedef void(^JXBaseLocationSuccessBlock)(CLPlacemark *placemark);
typedef void(^JXBaseFailureBlock)(NSError *error);

@interface JXBaseViewController : UIViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) NSMutableArray *operaters;

/**
 *  展示一个图片选择Sheet
 *
 *  @param willSuccess 将要成功
 *  @param didSuccess  已经成功
 *  @param failure     失败
 */
- (void)displayPhotoSheetWithWillSuccess:(JXBasePhotoWillSuccessBlock)willSuccess
                              didSuccess:(JXBasePhotoDidSuccessBlock)didSuccess
                                 failure:(JXBaseFailureBlock)failure;


/**
 *  开始定位
 *
 *  @param success 成功
 *  @param failure 失败
 */
- (void)startLocatingWithSuccess:(JXBaseLocationSuccessBlock)success
                         failure:(JXBaseFailureBlock)failure;
@end
