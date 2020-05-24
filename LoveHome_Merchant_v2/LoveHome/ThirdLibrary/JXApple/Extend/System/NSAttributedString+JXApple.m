//
//  NSAttributedString+JXApple.m
//  LiLottery
//
//  Created by 杨建祥 on 15/3/29.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "NSAttributedString+JXApple.h"

@implementation NSAttributedString (JXApple)
+ (NSAttributedString *)exAttributedStringWithString:(NSString *)string
                                               color:(UIColor *)color
                                                font:(UIFont *)font
                                               range:(NSRange)range {
    NSMutableAttributedString *mtAttrString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [mtAttrString addAttribute:NSForegroundColorAttributeName
                                  value:(id)color
                                  range:range];
    [mtAttrString addAttribute:NSFontAttributeName
                                  value:(id)font
                                  range:range];
    return mtAttrString;
}
@end
