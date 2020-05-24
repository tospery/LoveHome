//
//  JXScanViewController.h
//  iOSLibrary
//
//  Created by 杨建祥 on 15/7/20.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef JXEnableZXing
#import "ZXingObjC.h"

typedef void(^JXScanViewControllerResultBlock)(ZXCapture *capture, ZXResult *result);

@interface JXScanViewController : UIViewController <ZXCaptureDelegate>
- (void)setupResultBlock:(JXScanViewControllerResultBlock)resultBlock;

@end
#endif