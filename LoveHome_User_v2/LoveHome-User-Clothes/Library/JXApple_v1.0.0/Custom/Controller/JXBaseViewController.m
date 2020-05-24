//
//  JXBaseViewController.m
//  iOSLibrary
//
//  Created by 杨建祥 on 15/7/26.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "JXBaseViewController.h"
#import "JXApple.h"

@interface JXBaseViewController ()
@property (nonatomic, assign) BOOL locationFlag;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) JXBasePhotoWillSuccessBlock willSuccess;
@property (nonatomic, copy) JXBasePhotoDidSuccessBlock didSuccess;
@property (nonatomic, copy) JXBaseFailureBlock photoFailure;
@property (nonatomic, copy) JXBaseLocationSuccessBlock locationSuccess;
@property (nonatomic, copy) JXBaseFailureBlock locationFailure;
@end

@implementation JXBaseViewController
- (NSMutableArray *)operaters {
    if (!_operaters) {
        _operaters = [NSMutableArray array];
    }
    return _operaters;
}

- (void)dealloc {
    if (!_operaters) {
        return;
    }
    
    for (AFHTTPRequestOperation *op in _operaters) {
        if (op.isExecuting) {
            [op cancel];
        }
    }
}

#pragma mark - Private methods
- (void)pickMediaFromSource:(UIImagePickerControllerSourceType)sourceType {
    NSArray *mediaTypes = [UIImagePickerController
                           availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:
         sourceType] && [mediaTypes count] > 0) {
        NSArray *mediaTypes = [UIImagePickerController
                               availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:picker animated:YES completion:NULL];
    } else {
        if (self.photoFailure) {
            self.photoFailure([NSError exErrorWithCode:JXErrorCodeDeviceNotSupport description:kStringDeviceNotSupport]);
        }
    }
}


#pragma mark - Public methods
- (void)displayPhotoSheetWithWillSuccess:(JXBasePhotoWillSuccessBlock)willSuccess
                              didSuccess:(JXBasePhotoDidSuccessBlock)didSuccess
                                 failure:(JXBaseFailureBlock)failure {
    self.willSuccess = willSuccess;
    self.didSuccess = didSuccess;
    self.photoFailure = failure;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:kStringCancel
                                               destructiveButtonTitle:kStringCapture
                                                    otherButtonTitles:kStringChooseFromAlbum, nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)startLocatingWithSuccess:(JXBaseLocationSuccessBlock)success
                         failure:(JXBaseFailureBlock)failure{
    if (![CLLocationManager locationServicesEnabled]) {
        if (failure) {
            failure([NSError exErrorWithCode:JXErrorCodeCommon description:kStringLocateClosed]);
        }
        return;
    }
    
    self.locationSuccess = success;
    self.locationFailure = failure;
    
    if(!self.locationManager) {
        self.locationManager=[[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.delegate = self;
    }
    
    [self.locationManager startUpdatingLocation];
}


#pragma mark - Delegate methods
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (0 == buttonIndex) {
        [self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
    }else if (1 == buttonIndex) {
        [self pickMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
    }else {
    }
}


#pragma mark - UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if (![mediaType isEqualToString:@"public.image"]) {
        [picker dismissViewControllerAnimated:YES completion:^{
            if (self.photoFailure) {
                self.photoFailure([NSError exErrorWithCode:JXErrorCodeFileNotPicture description:kStringFileNotPicture]);
            }
        }];
        return;
    }
    
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
        UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    
    if (self.willSuccess) {
        self.willSuccess(image);
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.didSuccess) {
            self.didSuccess(image);
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *newLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: newLocation
                   completionHandler: ^(NSArray* placemarks, NSError* error) {
                       if (error) {
                           if (!self.locationFlag) {
                               self.locationFlag = YES;
                               if (self.locationFailure) {
                                   self.locationFailure([NSError exErrorWithCode:JXErrorCodeLocateFailure description:kStringLocateFailure]);
                               }
                           }
                       }else {
                           if (placemarks.count > 0) {
                               CLPlacemark *placemark = [placemarks objectAtIndex:0];
                               if (self.locationSuccess) {
                                   self.locationSuccess(placemark);
                               }
                           }else {
                               if (!self.locationFlag) {
                                   self.locationFlag = YES;
                                   if (self.locationFailure) {
                                       self.locationFailure([NSError exErrorWithCode:JXErrorCodeLocateFailure description:kStringLocateFailure]);
                                   }
                               }
                           }
                       }
                   }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (kCLAuthorizationStatusNotDetermined == status) {
        [manager requestWhenInUseAuthorization];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.locationManager stopUpdatingLocation];
    if (kCLErrorDenied == error.code) {
        if (self.locationFailure) {
            self.locationFailure([NSError exErrorWithCode:JXErrorCodeLocateDenied description:kStringLocateDenied]);
        }
    }else {
        if (!self.locationFlag) {
            self.locationFlag = YES;
            if (self.locationFailure) {
                self.locationFailure([NSError exErrorWithCode:JXErrorCodeLocateFailure description:kStringLocateFailure]);
            }
        }
    }
}
@end
