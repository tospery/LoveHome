//
//  UIViewController+JXApple.h
//  iOSLibrary
//
//  Created by 杨建祥 on 15/8/19.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXType.h"

@interface UIViewController (JXApple)
- (void)showLoginIfNotLoginedWithFinish:(JXLoginDidPassOrReloginDidFinishCallback)finish;
- (void)showLoginIfNotLoginedWithFinish:(JXLoginReloginDidFinishCallback)finish
                                   pass:(JXLoginDidPassCallback)pass;
- (void)showLoginIfTokenInvalidWithError:(NSError *)error
                                  finish:(JXLoginResultCallback)finish;

- (void)handleSuccessForTableView:(UITableView *)tableView
                        tableRect:(CGRect)tableRect
                             mode:(JXWebLaunchMode)mode
                            items:(NSMutableArray *)items
                             page:(JXPage *)page
                          results:(NSArray *)results
                          current:(NSInteger)current
                            total:(NSInteger)total
                            image:(UIImage *)image
                          message:(NSString *)message
                        functitle:(NSString *)functitle
                         callback:(JXWebResultCallback)callback;
- (void)handleFailureForView:(UIView *)view
                        rect:(CGRect)rect
                        mode:(JXWebLaunchMode)mode
                         way:(JXWebHandleWay)way
                       error:(NSError *)error
                    callback:(JXWebResultCallback)callback;
@end
