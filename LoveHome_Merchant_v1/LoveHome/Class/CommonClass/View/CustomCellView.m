//
//  CustomCellView.m
//  Love_Home
//
//  Created by MRH-MAC on 14/11/14.
//  Copyright (c) 2014年 MRH-MAC. All rights reserved.
//

#import "CustomCellView.h"

@implementation CustomCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor  whiteColor];
    
    //标题栏
    _titleName               = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 30)];
    _titleName.text          = @"名字";
    _titleName.font          = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    _titleName.textAlignment = NSTextAlignmentRight;
    [self addSubview:_titleName];
    
    //输入框
    _CustomTextFiled                    = [[UITextField alloc] initWithFrame:CGRectMake(80, 10, 200, 30)];
    _CustomTextFiled.autocorrectionType = UITextAutocorrectionTypeNo;
    _CustomTextFiled.font               = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    _CustomTextFiled.textColor          = [UIColor grayColor];
    _CustomTextFiled.placeholder        = @"请输入姓名";
    [self addSubview:_CustomTextFiled];
}

@end
