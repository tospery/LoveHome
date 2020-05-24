//
//  CustomAlertView.h
//  LoveHome
//
//  Created by MRH-MAC on 15/1/19.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomAlertView;

@protocol  CustomAlertViewDelegate<NSObject>

- (void)customAlertViewClickButton:(CustomAlertView *)alertView andContent:(NSString *)title;

@end

@interface CustomAlertView : UIView
@property (nonatomic, strong) UITextField *texfild;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) id <CustomAlertViewDelegate>delegate;

- (id)initWithMessage:(NSString *)message;

- (void)show;

@end
