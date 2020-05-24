//
//  JXDevice.m
//  iOSLibrary
//
//  Created by 杨建祥 on 15/5/10.
//  Copyright (c) 2015年 Thundersoft. All rights reserved.
//

#import "JXDevice.h"
#import "JXApple.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

//#include <dlfcn.h>
//#define PRIVATE_PATH  "/System/Library/PrivateFrameworks/CoreTelephony.framework/CoreTelephony"

@interface JXDevice ()
@property (assign, nonatomic, readwrite) JXDeviceResolution resolution;
@property (assign, nonatomic, readwrite) CGSize mainScreenSize;
@property (assign, nonatomic, readwrite) CGSize appFrameSize;
@property (assign, nonatomic, readwrite) CGFloat statusBarHeight;
@property (assign, nonatomic, readwrite) CGFloat navBarHeight;
@property (nonatomic, copy) void(^sendMessageFinishBlock)(MFMessageComposeViewController *controller, MessageComposeResult result);
@end

@implementation JXDevice
#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
        CGSize resolution = [UIScreen mainScreen].currentMode.size;
        if (CGSizeEqualToSize(resolution, CGSizeMake(640, 960))) {
             _resolution = JXDeviceResolution640x960;
        }else if (CGSizeEqualToSize(resolution, CGSizeMake(640, 1136))) {
            _resolution = JXDeviceResolution640x1136;
        }else if (CGSizeEqualToSize(resolution, CGSizeMake(750, 1334))) {
            _resolution = JXDeviceResolution750x1334;
        }else if (CGSizeEqualToSize(resolution, CGSizeMake(1242, 2208))) {
            _resolution = JXDeviceResolution1242x2208;
        }else {
            NSLog(kStringNotSupportThisDevice);
        }

        _mainScreenSize = [UIScreen mainScreen].bounds.size;
        _appFrameSize = [UIScreen mainScreen ].applicationFrame.size;
        _statusBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
        
        if (JXiOSVersionGreaterThanOrEqual(7.0)) {
            _navBarHeight = JXDeviceNavBarHeightIntertwine; // combine with status bar
        }else {
            _navBarHeight = JXDeviceNavBarHeightStandalone; // don't combine with status bar
        }
    }
    return self;
}

#pragma mark - Public methods
- (void)sendMessage:(NSString *)message
          receivers:(NSArray *)receivers
          container:(UIViewController *)container
         completion:(void (^)(void))completion
             finish:(void(^)(MFMessageComposeViewController *controller, MessageComposeResult result))finish {
    if (JXDeviceTypeiPhone != [[self class] type]) {
        NSLog(kStringYourDeviceNotSupportMessageFunction);
        JXAlert(kStringTips, kStringYourDeviceNotSupportMessageFunction);
        return;
    }
    _sendMessageFinishBlock = finish;
    
    MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
    messageVC.messageComposeDelegate = self;
    messageVC.recipients = receivers;
    messageVC.body = message;
    [container presentViewController:messageVC animated:YES completion:completion];
}

#pragma mark - Delegate methods
#pragma mark MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    if (_sendMessageFinishBlock) {
        _sendMessageFinishBlock(controller, result);
    }
}

#pragma mark - Class methods
+ (JXDevice *)sharedInstance {
    static JXDevice *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

+ (JXDeviceType)type {
    JXDeviceType type;
    NSString *model = [UIDevice currentDevice].model;
    if ([model rangeOfString:@"Simulator"].location != NSNotFound) {
        type = JXDeviceTypeSimulator;
    }else if ([model rangeOfString:@"iPhone"].location != NSNotFound) {
        type = JXDeviceTypeiPhone;
    }else if ([model rangeOfString:@"iPod"].location != NSNotFound) {
        type = JXDeviceTypeiPod;
    }else {
        type = JXDeviceTypeiPad;
    }
    return type;
}

+ (void)callNumber:(NSString *)number {
    if (JXDeviceTypeiPhone != [[self class] type]) {
        NSLog(kStringYourDeviceNotSupportCallFunction);
        JXAlert(kStringTips, kStringYourDeviceNotSupportCallFunction);
        return;
    }
    
    NSURL *numberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", number]];
    static UIWebView *callWebView;
    if (!callWebView) {
        callWebView = [[UIWebView alloc]initWithFrame:CGRectZero];
    }
    [callWebView loadRequest:[NSURLRequest requestWithURL:numberURL]];
}

+ (void)browseWeb:(NSString *)urlString {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

//+ (CGFloat)screenWidth {
//    static CGFloat result;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        result = [UIScreen mainScreen].bounds.size.width;
//    });
//    return result;
//}
//
//+ (CGFloat)screenHeight {
//    static CGFloat result;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        result = [UIScreen mainScreen].bounds.size.height;
//    });
//    return result;
//}
//
//+ (CGFloat)statusBarHeight {
//    static CGFloat result;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        result = [UIScreen mainScreen].bounds.size.height;
//    });
//    return result;
//}

+ (NSString *)brief {
    UIDevice *device = [UIDevice currentDevice];
    return [NSString stringWithFormat:@"%@_%@_%@", device.model, device.systemName, device.systemVersion];
}

+ (NSString *)imsi {
//#if TARGET_IPHONE_SIMULATOR
//    return nil;
//#else
//    {
//        void *kit = dlopen(PRIVATE_PATH,RTLD_LAZY);
//        NSString *imsi = nil;
//        NSString *(*CTSIMSupportCopyMobileSubscriberIdentity)() = dlsym(kit, "CTSIMSupportCopyMobileSubscriberIdentity");
//        imsi = (NSString *)CTSIMSupportCopyMobileSubscriberIdentity(nil);
//        dlclose(kit);
//        
//        return imsi;
//    }
//#endif
    
    return nil;
}

+ (NSString *)ip {
    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
        return nil;
    }
    
    NSString *address = @"";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    
    return address;
}
@end



