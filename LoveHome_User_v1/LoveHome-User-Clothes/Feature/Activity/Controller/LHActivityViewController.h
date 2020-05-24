//
//  LHActivityViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/21.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHBaseViewController.h"
#import "LHActivity.h"
#import "WebViewJavascriptBridge.h"

@interface LHActivityViewController : LHBaseViewController <UIWebViewDelegate, UIAlertViewDelegate, NJKWebViewProgressDelegate, UMSocialUIDelegate>
- (instancetype)initWithActivity:(LHActivity *)activity;

@end
