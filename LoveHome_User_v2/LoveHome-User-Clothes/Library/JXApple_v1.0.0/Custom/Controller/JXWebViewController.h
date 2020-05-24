//
//  JXWebViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/2.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#ifdef JXEnableNJKWebViewProgress
#import "JXBaseViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface JXWebViewController : JXBaseViewController <UIWebViewDelegate, UIAlertViewDelegate, NJKWebViewProgressDelegate>
- (instancetype)initWithURLString:(NSString *)urlString;

@end
#endif