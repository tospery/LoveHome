//
//  TextCellModel.h
//  LoveHome
//
//  Created by MRH-MAC on 15/8/25.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TextCellModel : NSObject

@property (nonatomic,strong) NSString *placeString;
@property (nonatomic,strong) NSString *contentString;
@property (nonatomic,assign) BOOL isInteractionEnabled;
@property (nonatomic,assign) UIKeyboardType keybordType;

/*!
 *  @brief  配置输入框
 *
 *  @param place      占位符
 *  @param content    输入内容
 *  @param enbled     是否交互
 *  @param kebordType 键盘类型 默认DefaultType
 *
 *  @return
 */
- (instancetype)initWithPlaceString:(NSString *)place andContent:(NSString *)content isInteractionEnbled:(BOOL)enbled;

@end
