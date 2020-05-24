//
//  JXDevice.h
//  iOSLibrary
//
//  Created by 杨建祥 on 15/5/10.
//  Copyright (c) 2015年 Thundersoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

// 设备类型
typedef NS_ENUM(NSInteger, JXDeviceType){
    JXDeviceTypeSimulator,
    JXDeviceTypeiPhone,
    JXDeviceTypeiPod,
    JXDeviceTypeiPad
};

// 设备分辨率
typedef NS_ENUM(NSInteger, JXDeviceResolution){
    JXDeviceResolution640x960,         // earlier than iPhone 5
    JXDeviceResolution640x1136,        // iPhone 5/5S
    JXDeviceResolution750x1334,        // iPhone 6
    JXDeviceResolution1242x2208        // iPhone 6 Plus
};

// 导航栏高度
typedef NS_ENUM(NSInteger, JXDeviceNavBarHeight){
    JXDeviceNavBarHeightStandalone = 44,
    JXDeviceNavBarHeightIntertwine = 64
};

@interface JXDevice : NSObject <MFMessageComposeViewControllerDelegate>
@property (assign, nonatomic, readonly) JXDeviceResolution resolution;
@property (assign, nonatomic, readonly) CGSize mainScreenSize;
@property (assign, nonatomic, readonly) CGSize appFrameSize;
@property (assign, nonatomic, readonly) CGFloat statusBarHeight;
@property (assign, nonatomic, readonly) CGFloat navBarHeight;

- (void)sendMessage:(NSString *)message
          receivers:(NSArray *)receivers
          container:(UIViewController *)container
         completion:(void (^)(void))completion
             finish:(void(^)(MFMessageComposeViewController *controller, MessageComposeResult result))finish;

+ (JXDevice *)sharedInstance;
+ (JXDeviceType)type;
+ (void)callNumber:(NSString *)number;

//+ (CGFloat)screenWidth;
+ (NSString *)brief;
@end
