//
//  LHReceiptFooterView.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/25.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHReceiptFooterView.h"

@interface LHReceiptFooterView ()
@property (nonatomic, copy) LHReceiptFooterViewAddPressedBlock addPressedBlock;
@end

@implementation LHReceiptFooterView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self initView];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(kScreenWidth, 76.0f);
}

- (void)initView {
    self.backgroundColor = ColorHex(0xF4F4F4);
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [addButton setTitle:@"添加收货地址" forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    ConfigButtonStyle(addButton);
    [self addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(12, 12, 20, 12));
    }];
}

- (void)setupAddPressedBlock:(LHReceiptFooterViewAddPressedBlock)addPressedBlock {
    self.addPressedBlock = addPressedBlock;
}

- (void)addButtonPressed:(id)sender {
    if (self.addPressedBlock) {
        self.addPressedBlock(sender);
    }
}
@end
