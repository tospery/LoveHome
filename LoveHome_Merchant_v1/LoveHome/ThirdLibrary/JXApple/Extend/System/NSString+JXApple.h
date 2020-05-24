//
//  NSString+JXApple.h
//  MyiOS
//
//  Created by Thundersoft on 10/20/14.
//  Copyright (c) 2014 Thundersoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (JXApple)
// 32位MD5加密方式
- (NSString *)exMD5Bit32;
// 16位MD5加密方式
- (NSString *)exMD5Bit16;
// 字符串转NSDate
- (NSDate *)exDateWithFormat:(NSString *)format locale:(NSString *)locale;
// 字符串转NSDate
- (NSDate *)exDateWithFormat:(NSString *)format;

- (NSNumber *)lengthAsNumber;
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
- (NSString *)deleteSpecialCharacterInFix:(NSString *)specialCharacter;
- (NSString *)replaceUnicodeValue; // Android\\u65B9\\u6CD5 -> Android方法
- (NSString *)substringToIndexSafely:(NSUInteger)to;
- (NSUInteger)lengthInByte;
- (NSString *)substringByBytes:(NSUInteger)count;
- (NSString *)exTrim;
- (NSString *)exStringWithReplaces:(NSDictionary *)replaces;
- (NSString *)exHexToDec;
- (BOOL)exCompareToIgnoreCase:(NSString *)other;

- (void)exDrawInRect:(CGRect)rect font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment;
- (CGSize)exSizeWithFont:(UIFont *)font width:(CGFloat)width;


+ (NSString *)getDistanceWithLatitude:(double)latitude longitude:(double)longitude;
+ (NSString *)stringWithFilename:(NSString *)filename;
@end
