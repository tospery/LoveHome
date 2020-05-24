//
//  NSString+JXApple.m
//  MyiOS
//
//  Created by Thundersoft on 10/20/14.
//  Copyright (c) 2014 Thundersoft. All rights reserved.
//

#import "NSString+JXApple.h"
#import "JXApple.h"
#import <CoreLocation/CoreLocation.h>
#import <CommonCrypto/CommonDigest.h>
#import <objc/message.h>
#import <objc/runtime.h>

@implementation NSString (JXApple)
// TODO 重新实现该方法
+ (NSString *)getDistanceWithLatitude:(double)latitude longitude:(double)longitude
{
    CLLocationCoordinate2D lo =CLLocationCoordinate2DMake(latitude,longitude);
    CLLocation *loLocation = [[CLLocation alloc] initWithLatitude:lo.latitude longitude:lo.longitude];
    CLLocation *toLocation = [[CLLocation alloc] initWithLatitude:/*g_coordinate.latitude*/latitude longitude:/*g_coordinate.longitude*/longitude];
    CLLocationDistance dis = [loLocation distanceFromLocation:toLocation];

    if (dis >= 1000)
        return [NSString stringWithFormat:@"%0.0fkm",dis/1000];
    else
        return [NSString stringWithFormat:@"%0.0fm",dis];
}

- (NSNumber *)lengthAsNumber {
    NSUInteger length = self.length;
    return ([NSNumber numberWithUnsignedInteger:length]);
}

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding)));
}

- (CGSize)exSizeWithFont:(UIFont *)font width:(CGFloat)width {
    CGSize result = CGSizeZero;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *textParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        textParagraphStyle.alignment = NSTextAlignmentCenter;
        textParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        result = [self boundingRectWithSize:CGSizeMake(width, UINT16_MAX)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName: font,
                                              NSParagraphStyleAttributeName: textParagraphStyle}
                                    context:nil].size;
    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font
                  constrainedToSize:CGSizeMake(width, UINT16_MAX)
                      lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    }
    return result;
}

- (NSString *)deleteSpecialCharacterInFix:(NSString *)specialCharacter {
    NSMutableString *temp = [NSMutableString stringWithString:self];
    while (YES) {
        if ([temp hasPrefix:specialCharacter]) {
            [temp deleteCharactersInRange:NSMakeRange(0, 1)];
        }else {
            break;
        }
    }
    while (YES) {
        if ([temp hasSuffix:specialCharacter]) {
            [temp deleteCharactersInRange:NSMakeRange(temp.length - 1, 1)];
        }else {
            break;
        }
    }

    return temp;
}

- (NSString *)replaceUnicodeValue {
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

- (NSString *)substringToIndexSafely:(NSUInteger)to {
    if (self.length < to) {
        return self;
    }
    return [self substringToIndex:to];
}

- (NSUInteger)lengthInByte {
    NSUInteger bytes = 0;
    NSUInteger unicodes = self.length;

    NSRange range;
    NSString *uString;
    const char *cString;
    for (NSUInteger i = 0; i < unicodes; ++i) {
        range = NSMakeRange(i, 1);
        uString = [self substringWithRange:range];
        cString = [uString UTF8String];
        if (cString == NULL || strlen(cString) == 1 ) {
            ++bytes;
        }else {
            bytes += 2;
        }
    }
    return bytes;
}

- (NSString *)exHexToDec {
    return JXStringFromInteger(strtoul([self UTF8String], 0, 16));
}

- (BOOL)exCompareToIgnoreCase:(NSString *)other {
    if (NSOrderedSame == [self compare:other options:NSCaseInsensitiveSearch]) {
        return YES;
    }
    return NO;
}

- (NSString *)substringByBytes:(NSUInteger)count {
    NSUInteger bytes = [self lengthInByte];
    if (count >= bytes) {
        return self;
    }

    NSUInteger i = 0;
    NSUInteger unicodes = self.length;
    NSUInteger remaining = count;

    NSRange range;
    NSString *uString;
    const char *cString;
    for (; i < unicodes && remaining > 0; ++i) {
        range = NSMakeRange(i, 1);
        uString = [self substringWithRange:range];
        cString = [uString UTF8String];
        if (cString == NULL || strlen(cString) == 1) {
            --remaining;
        }else {
            if (1 == remaining) {
                break;
            }
            remaining -= 2;
        }
    }

    return [self substringToIndex:i];
}

- (NSString *)exTrim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)exDrawInRect:(CGRect)rect font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment {
    if ([self respondsToSelector:@selector(drawWithRect:options:attributes:context:)]) {
        NSMutableParagraphStyle *textParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        textParagraphStyle.alignment = alignment;
        textParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

        [self drawWithRect:rect
                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                attributes:@{NSFontAttributeName: font,
                             NSParagraphStyleAttributeName: textParagraphStyle,
                             NSForegroundColorAttributeName: color}
                   context:nil];
    }else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self drawInRect:rect
                 withFont:font
            lineBreakMode:NSLineBreakByWordWrapping
                alignment:alignment];
#pragma clang diagnostic pop
    }
}

+ (NSString *)stringWithFilename:(NSString *)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    return [documents stringByAppendingPathComponent:filename];
}


- (NSString *)exStringWithReplaces:(NSDictionary *)replaces {
    NSString *result = self;
    for (NSString *key in replaces.keyEnumerator) {
        result = [result stringByReplacingOccurrencesOfString:[[NSString alloc] initWithFormat:@"%%%%%@%%%%", key]
                                                   withString:replaces[key]];
    }
    return result;
}

+ (NSString *)getMd5_32Bit_String:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

// 32位MD5加密方式
- (NSString *)exMD5Bit32 {
    const char *cStr = self.UTF8String;
    unsigned char digits[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digits);
    NSMutableString *result = [NSMutableString stringWithCapacity:2 * CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [result appendFormat:@"%02x", digits[i]];
    }
    return result;
}

// 16位MD5加密方式
- (NSString *)exMD5Bit16 {
    NSString *md5Bit32 = [self exMD5Bit32]; // 提取32位MD5散列的中间16位
    NSString *result = [[md5Bit32 substringToIndex:24] substringFromIndex:8]; // 即9～25位
    return result;
}

// 字符串转NSDate
- (NSDate *)exDateWithFormat:(NSString *)format locale:(NSString *)locale {
    NSDate *date = [[NSDateFormatter exInstanceWithFormat:format locale:locale] dateFromString:self];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    return [date dateByAddingTimeInterval:interval];
}

// 字符串转NSDate
- (NSDate *)exDateWithFormat:(NSString *)format {
    return [[NSDateFormatter exInstanceWithFormat:format] dateFromString:self];
}

- (CGFloat)exFloatValue {
    CGFloat first = [self floatValue];
    NSString *second = [NSString stringWithFormat:@"%.2f", first];
    return [second floatValue];
}
@end

















