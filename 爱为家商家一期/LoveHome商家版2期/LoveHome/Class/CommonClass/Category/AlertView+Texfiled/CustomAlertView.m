//
//  CustomAlertView.m
//  LoveHome
//
//  Created by MRH-MAC on 15/1/19.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "CustomAlertView.h"

@interface CustomAlertView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *cover;

@end

@implementation CustomAlertView

- (id)initWithMessage:(NSString *)message
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.message = message;
        [self initView];
    }
    return self;
}




- (void)initView
{
    
    
    _cover = [[UIView alloc] initWithFrame:self.bounds];
    _cover.backgroundColor = COLOR_CUSTOM(0, 0, 0, 0.5);
    [self addSubview:_cover];

    
    _contentView = [[UIView alloc] init];
    _contentView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HIGHT + SCREEN_WIDTH/3);
    _contentView.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.85, SCREEN_WIDTH * 0.44);
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 10;
    _contentView.layer.borderWidth = 0.5;
    _contentView.layer.borderColor = [UIColor grayColor].CGColor;
    [self addSubview:_contentView];
    CGSize size = _contentView.bounds.size;
    
    UILabel *title = [[UILabel alloc] init];
    title.center = CGPointMake(size.width / 2, size.height *0.2);
    title.bounds = CGRectMake(0, 0,size.width / 2,size.height / 5);
    title.textAlignment = NSTextAlignmentCenter;
    title.text = _message;
    [_contentView addSubview:title];
    
    _texfild = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(title.frame) + 5, size.width - 20, 30)];
    _texfild.textAlignment = NSTextAlignmentCenter;
    _texfild.layer.cornerRadius = 4;
    _texfild.layer.borderWidth = 0.5;
    _texfild.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_contentView becomeFirstResponder];
    [_contentView addSubview:_texfild];
    
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, size.height - size.width/7,size.width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [_contentView addSubview:line];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(size.width / 2, size.height - size.width/7, 0.5,size.width/7.5)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [_contentView addSubview:line1];
    
    
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(10, size.height - size.width / 7.5 - 5, size.width/3, size.width/7.5) ;
    [cancel setTitleColor:COLOR_CUSTOM(74, 131, 255, 1) forState:UIControlStateNormal];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:cancel];
    
    
    UIButton *Ok = [UIButton buttonWithType:UIButtonTypeCustom];
    Ok.frame = CGRectMake(size.width - size.width/3 - 10 ,size.height - size.width / 7.5 - 5 , size.width/3, size.width/7.5) ;
    Ok.layer.cornerRadius = 4;
    [Ok setTitleColor:COLOR_CUSTOM(74, 131, 255, 1) forState:UIControlStateNormal];
    [Ok setTitle:@"确定" forState:UIControlStateNormal];
    [Ok addTarget:self action:@selector(okPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:Ok];


    
}


#pragma mark - 
- (void)cancelPressed:(UIButton *)sender
{
    [self hidden];
}

- (void)okPressed:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(customAlertViewClickButton:andContent:)]) {
        [_delegate customAlertViewClickButton:self andContent:_texfild.text];
    }
    [self hidden];
}


- (void)hidden
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show
{
    [UIView animateWithDuration:0.5 animations:^{
        
        _contentView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HIGHT*0.35);
    }];
}

@end
