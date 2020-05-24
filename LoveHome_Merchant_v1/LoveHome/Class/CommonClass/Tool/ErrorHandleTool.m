//
//  ErrorHandleTool.m
//  LoveHome
//
//  Created by MRH-MAC on 15/9/23.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "ErrorHandleTool.h"


#define kErrorCodeToken 401 ///> token失效


@implementation ErrorHandleTool

+ (NSError *)errorWithCode:(NSError *)error
{
    NSString *description;

    switch (error.code) {
        case -1009:
            description = @"请检查您的网络连接";
            break;
        case 500:
            description = @"服务器异常请稍后再试";
            break;
        case -1001:
            description = @"亲~您的网络不给力哦~";
            break;
        default:
            description = @"服务器异常请稍后再试";
            break;
    }
    
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                               code:error.code
                           userInfo:@{NSLocalizedDescriptionKey: description}];
}

+ (NSError *)errorWithCode:(RHErrorCode)code description:(NSString *)description
{
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey: description}];
}


+ (void)handleErrorWithCode:(NSError *)error toShowView:(UIView *)toShow didFinshi:(CompleteBlock)didFinsh cancel:(CompleteBlock)cancel;
{
    if (error.code == kErrorCodeToken) {
        

        UIViewController *vc  = [[UIApplication sharedApplication].delegate window].rootViewController;
        
        if ([UserTools sharedUserTools].isLoginWindow) {
            return;
        }

        
        
        [[UserTools sharedUserTools] loginIfNeedWithTarget:vc error:error didFinished:didFinsh];
        ShowAlertView(@"温馨提示", @"您的账号在另一设备上登录,请重新登录", nil, @"确认");
       
        return;
    }

    ShowWaringAlertHUD(error.localizedDescription, toShow);

}


+(void)handleLoadViewWithCode:(NSError *)error toShowView:(UIView *)toShow didFinshi:(CompleteBlock)didFinsh cancel:(CompleteBlock)cancel
{
    
    if (error.code == kErrorCodeToken) {
        
        ShowWaringAlertHUD(@"登录过期请重新登录", toShow);
        UIViewController *vc  = [[UIApplication sharedApplication].delegate window].rootViewController;
        [[UserTools sharedUserTools] loginIfNeedWithTarget:vc error:error didFinished:didFinsh];
        return;
    }


    [JXLoadingView showFailedAddedTo:toShow error:error retry:didFinsh];


}

@end
