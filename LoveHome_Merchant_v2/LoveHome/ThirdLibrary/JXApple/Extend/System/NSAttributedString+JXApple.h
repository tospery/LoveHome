//
//  NSAttributedString+JXApple.h
//  LiLottery
//
//  Created by 杨建祥 on 15/3/29.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSAttributedString (JXApple)
+ (NSAttributedString *)exAttributedStringWithString:(NSString *)string
                                               color:(UIColor *)color
                                                font:(UIFont *)font
                                               range:(NSRange)range;
@end
