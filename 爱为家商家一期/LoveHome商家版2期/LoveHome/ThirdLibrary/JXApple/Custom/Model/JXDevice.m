//
//  JXDevice.m
//  iOSLibrary
//
//  Created by 杨建祥 on 15/5/10.
//  Copyright (c) 2015年 Thundersoft. All rights reserved.
//

#import "JXDevice.h"
#import "JXApple.h"

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
            JXLogError(kStringNotSupportThisDevice);
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
        JXLogWarn(kStringYourDeviceNotSupportMessageFunction);
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
        JXLogWarn(kStringYourDeviceNotSupportCallFunction);
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
@end
