//
//  LHBaseViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/16.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "LHBaseViewController.h"
#import "LHLoginViewController.h"

@interface LHBaseViewController ()
@property (nonatomic, copy) JXBasePhotoWillSuccessBlock willSuccess;
@property (nonatomic, copy) JXBasePhotoDidSuccessBlock didSuccess;
@property (nonatomic, copy) JXBaseFailureBlock photoFailure;
@end

@implementation LHBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBack;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.tabBarController.tabBar.alpha = 0.7;
    self.navigationController.navigationBar.barTintColor = kColorBack;
    self.navigationController.navigationBar.translucent = NO;
}

//#pragma mark - Private methods
//- (void)pickMediaFromSource:(UIImagePickerControllerSourceType)sourceType {
//    NSArray *mediaTypes = [UIImagePickerController
//                           availableMediaTypesForSourceType:sourceType];
//    if ([UIImagePickerController isSourceTypeAvailable:
//         sourceType] && [mediaTypes count] > 0) {
//        NSArray *mediaTypes = [UIImagePickerController
//                               availableMediaTypesForSourceType:sourceType];
//        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//        picker.mediaTypes = mediaTypes;
//        picker.delegate = self;
//        picker.allowsEditing = YES;
//        picker.sourceType = sourceType;
//        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        [self presentViewController:picker animated:YES completion:NULL];
//    } else {
//        if (self.photoFailure) {
//            self.photoFailure([NSError exErrorWithCode:LHErrorCodeDeviceNotSupport description:@"您的设备不支持该功能"]);
//        }
//    }
//}
//
//
//#pragma mark - Public methods
//- (void)displayPhotoSheetWithWillSuccess:(JXBasePhotoWillSuccessBlock)willSuccess
//                              didSuccess:(JXBasePhotoDidSuccessBlock)didSuccess
//                                 failure:(JXBaseFailureBlock)failure {
//    self.willSuccess = willSuccess;
//    self.didSuccess = didSuccess;
//    self.photoFailure = failure;
//    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                             delegate:self
//                                                    cancelButtonTitle:kStringCancel
//                                               destructiveButtonTitle:@"拍照"
//                                                    otherButtonTitles:@"从相册中选取", nil];
//    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
//    [actionSheet showInView:self.view];
//}
//
//
//#pragma mark - Delegate methods
//#pragma mark UIActionSheetDelegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (0 == buttonIndex) {
//        [self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
//    }else if (1 == buttonIndex) {
//        [self pickMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
//    }else {
//    }
//}
//
//
//#pragma mark - UIImagePickerControllerDelegate methods
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//    if (![mediaType isEqualToString:@"public.image"]) {
//        [picker dismissViewControllerAnimated:YES completion:^{
//            if (self.photoFailure) {
//                self.photoFailure([NSError exErrorWithCode:LHErrorCodeOperateInvalid description:@"所选文件不是一张图片，请重新选择"]);
//            }
//        }];
//        return;
//    }
//    
//    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
//        UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//    }
//    
//    UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
//    
//    if (self.willSuccess) {
//        self.willSuccess(image);
//    }
//    [picker dismissViewControllerAnimated:YES completion:^{
//        if (self.didSuccess) {
//            self.didSuccess(image);
//        }
//    }];
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//}

//#pragma mark - Public methods
//- (void)handleSuccessWithOperation:(AFHTTPRequestOperation *)operation error:(NSError *)error view:(UIView *)view {
//    HUDHide();
//    [JXLoadView hideForView:view];
//}
//
//- (void)handleFailureWithOperation:(AFHTTPRequestOperation *)operation
//                             error:(NSError *)error
//                              view:(UIView *)view
//                             retry:(void (^)(void))retry {
//    [self handleFailureWithOperation:operation error:error message:nil view:view retry:retry];
//}
//
//- (void)handleFailureWithOperation:(AFHTTPRequestOperation *)operation
//                           message:(NSString *)message
//                              view:(UIView *)view
//                             retry:(void (^)(void))retry {
//    [self handleFailureWithOperation:operation error:nil message:message view:view retry:retry];
//}
//
//- (void)handleFailureWithOperation:(AFHTTPRequestOperation *)operation
//                             error:(NSError *)error
//                           message:(NSString *)message
//                              view:(UIView *)view
//                             retry:(void (^)(void))retry {
//    BOOL isToast = YES;
//    if (view && [JXLoadView loadForView:view]) {
//        isToast = NO;
//    }
//    
//    if (isToast) {
//        HUDHide();
//        [[LHLoginViewController sharedController] loginIfNeedWithTarget:self error:error willPresent:^{
//            
//        } didPresented:^{
//            if (error) {
//                Toast(error.localizedDescription);
//            }
//        } willCancel:^{
//            
//        } didCancelled:^{
//            
//        } willFinish:^{
//            if (retry) {
//                retry();
//            }
//        } didFinished:^{
//            
//        } hasLoginned:^{
//            if (error) {
//                Toast(error.localizedDescription);
//            }
//        }];
//    }else {
//        [[LHLoginViewController sharedController] loginIfNeedWithTarget:self error:error willPresent:^{
//            
//        } didPresented:^{
//            if (error) {
//                Toast(error.localizedDescription);
//            }
//            
//            if (message) {
//                //[JXLoadView showFailedForView:view error:[NSError exErrorWithCode:JXErrorCodeDataEmpty] callback:retry];
//            }else {
//                //[JXProcessView showFailedForView:view error:error callback:retry];
//            }
//        } willCancel:^{
//            
//        } didCancelled:^{
//            
//        } willFinish:^{
//            
//        } didFinished:^{
//            if (retry) {
//                retry();
//            }
//        } hasLoginned:^{
//            if (message) {
//                //[JXProcessView showFailedForView:view error:[NSError exErrorWithCode:JXErrorCodeDataEmpty] callback:retry];
//            }else {
//                //[JXProcessView showFailedForView:view error:error callback:retry];
//            }
//        }];
//    }
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
