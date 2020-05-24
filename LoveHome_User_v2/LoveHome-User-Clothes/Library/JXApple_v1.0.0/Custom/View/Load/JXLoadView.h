//
//  JXLoadView.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/1.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXLoadView : UIView
+ (void)showProcessingAddedTo:(UIView *)view rect:(CGRect)rect;

+ (void)showResultAddedTo:(UIView *)view
                     rect:(CGRect)rect
                    error:(NSError *)error
                 callback:(JXLoadResultCallback)callback;
+ (void)showResultAddedTo:(UIView *)view
                     rect:(CGRect)rect
                    image:(UIImage *)image
                  message:(NSString *)message
                functitle:(NSString *)functitle
                 callback:(JXLoadResultCallback)callback;

+ (void)hideForView:(UIView *)view;
+ (JXLoadView *)loadForView:(UIView *)view;
@end


@interface JXLoadViewManager : NSObject
+ (void)setBackgroundColor:(UIColor *)backgroundColor;
+ (UIColor *)backgroundColor;
@end
