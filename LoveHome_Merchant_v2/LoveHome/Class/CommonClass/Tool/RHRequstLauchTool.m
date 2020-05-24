//
//  RHRuqestLauchTool.m
//  LoveHome
//
//  Created by MRH on 15/12/9.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import "RHRequstLauchTool.h"
#import "RHLoadView.h"
@implementation RHRequstLauchTool


+(void)showLauchWithType:(RHWebLaunchType)lauchType toView:(UIView *)view {
    
    [RHLoadView hideForView:view];
    switch (lauchType) {
        case RHWebLaunchTypeHUD:
            ShowProgressHUD(YES, view);
            break;
        case RHWebLaunchTypeLoad:
            // 调用LoadView控件
            [RHLoadView showProcessingAddedTo:view rect:CGRectZero];
            break;
        default:
            break;
    }
    

}


+ (void)handleSuceessRequestType:(RHWebLaunchType)lauchType toView:(UIView *)view {

    switch (lauchType) {
        case RHWebLaunchTypeHUD:
            ShowProgressHUD(NO, view);
            break;
            
        case RHWebLaunchTypeLoad:{
            // 隐藏loadView
            [RHLoadView hideForView:view];
            break;
        }
        case RHWebLaunchTypeRefresh:{
            // tableview停止刷新方法
            UITableView *tableVie = (UITableView *)view;
            [tableVie.header endRefreshing];
            break;
        }
        case RHWebLaunchTypeMore:{
            // tableviewfooter停止刷新方法
            UITableView *tableVie = (UITableView *)view;
            [tableVie.footer endRefreshing];
            break;
        }
        default:
            break;
    }
}

+ (void)handleErrorFailureForView:(UIView *)view  lauchType:(RHWebLaunchType)lauchType ToastWay:(RHErrorShowType)way error:(NSError *)error callback:(RHLoadResultCallback)callback {
    
    switch (lauchType) {
        case RHWebLaunchTypeHUD:
            ShowProgressHUD(NO, view);
            break;
            
        case RHWebLaunchTypeLoad:{
            // 隐藏loadView
            [RHLoadView hideForView:view];
            
            break;
        }
        case RHWebLaunchTypeRefresh:{
            // tableview停止刷新方法
            UITableView *tableVie = (UITableView *)view;
            [tableVie.header endRefreshing];
            break;
        }
        case RHWebLaunchTypeMore:{
            // tableviewfooter停止刷新方法
            UITableView *tableVie = (UITableView *)view;
            [tableVie.footer endRefreshing];
            break;
        }
        default:
            break;
    }
    
    // 1.优先
    if (error.code == RHErrorCodeTokenInvalid) {
        UIViewController *vc  = [[UIApplication sharedApplication].delegate window].rootViewController;
        if ([UserTools sharedUserTools].isLoginWindow) {
            return;
        }
        [[UserTools sharedUserTools] loginIfNeedWithTarget:vc error:error didFinished:callback];
        ShowAlertView(@"温馨提示", @"您的账号在另一设备上登录,请重新登录", nil, @"确认");
        return;
    }
    
    if (way == RHErrorShowTypeHUD) {
        ShowWaringAlertHUD(error.localizedDescription, view);
        return;
    }
    if (way == RHErrorShowTypeLoad) {
        // 此处更具error 展示load
        [RHLoadView showResultAddedTo:view rect:CGRectZero error:error callback:callback];
    }
    
    
    


    
}
@end
