//
//  LHLoginViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/16.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "LHBaseViewController.h"
#import "LHCaptchaButton.h"

typedef void(^LHLoginWillPresentBlock)();       // 将要显示
typedef void(^LHLoginDidPresentedBlock)();      // 显示完成
typedef void(^LHLoginWillCancelBlock)();        // 点击返回，将要进行dismiss
typedef void(^LHLoginDidCancelledBlock)();      // 点击返回，已经dismiss完成
typedef void(^LHLoginWillFinishBlock)();        // 登录成功，将要进行dismiss
typedef void(^LHLoginDidFinishedBlock)();       // 登录成功，已经dismiss完成
typedef void(^LHLoginHasLoginnedBlock)();       // 登录成功，已经dismiss完成

@interface LHLoginViewController : LHBaseViewController <LHCaptchaButtonDelegate>
@property (nonatomic, assign) BOOL isPresented; // 是否已显示


/**
 *  是否需要登录，如果需要就present login
 *
 *  @param target       进行present的controller
 *  @param error        HTTP返回的错误信息，不需要可传nil
 *  @param willPresent  将要显示
 *  @param didPresented 显示完成
 *  @param willCancel   点击返回，将要进行dismiss
 *  @param didCancelled 点击返回，已经dismiss完成
 *  @param willFinish   登录成功，将要进行dismiss
 *  @param didFinished  登录成功，已经dismiss完成
 *  @param hasLoginned  已经登录，不需要再次登录
 *  @return YES为需要登录
 */
- (BOOL)loginIfNeedWithTarget:(UIViewController *)target
                        error:(NSError *)error
                  willPresent:(LHLoginWillPresentBlock)willPresent
                 didPresented:(LHLoginDidPresentedBlock)didPresented
                   willCancel:(LHLoginWillCancelBlock)willCancel
                 didCancelled:(LHLoginDidCancelledBlock)didCancelled
                   willFinish:(LHLoginWillFinishBlock)willFinish
                  didFinished:(LHLoginDidFinishedBlock)didFinished
                  hasLoginned:(LHLoginHasLoginnedBlock)hasLoginned;


+ (LHLoginViewController *)sharedController;
@end
