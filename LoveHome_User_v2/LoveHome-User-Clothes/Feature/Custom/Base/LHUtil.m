//
//  LHUtil.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/16.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "LHUtil.h"
#import "LHLoginViewController.h"

BOOL isNormalMoney(NSString* money)
{
    NSString *patten = @"^\\d+(\\.\\d{1,2})?$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:patten options:0 error:nil];
    NSArray *results = [regex matchesInString:money options:0 range:NSMakeRange(0,money.length)];
    return [results count] > 0;
}


NSString * getCurrentTime(void)
{
    UInt64 time = [[NSDate date] timeIntervalSince1970] *100000;
    NSString *timeStr = [NSString stringWithFormat:@"%llu",time];
    return timeStr;
}

BOOL JudgeContainerIsEmptyOrNull(id container) {
    if (!container) {
        return YES;
    }
    
    if ([container isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)container;
        if ([array count] > 0) {
            return NO;
        }else {
            return YES;
        }
    }
    
    if ([container isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = (NSDictionary *)container;
        if ([[dictionary allKeys] count] > 0)
        {
            return NO;
        }else
        {
            return YES;
        }
    }
    
    if ([container isKindOfClass:[NSString class]]) {
        NSString *string = (NSString *)container;
        if ([string length] > 0) {
            if ([string isEqualToString:@"(null)"] || [string isEqualToString:@"(NULL)"] || [string isEqualToString:@"null"] || [string isEqualToString:@"NULL"] || [string isEqualToString:@"<null>"] || [string isEqualToString:@"<NULL>"])
            {
                return YES;
            }
            else if ([string exTrim].length == 0)
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
    
    if ([container isKindOfClass:[NSNumber class]]) {
        //            NSNumber *number = (NSNumber *)container;
        //            if ([number isEqualToNumber:[NSNumber numberWithInt:0]])
        //            {
        //                return YES;
        //            }else
        //            {
        //                return NO;
        //            }
        return NO;
    }
    
    return YES;
}

UIBarButtonItem * CreateBackBarItem(id target) {
    return JXCreateLeftBarItem(target);
}

void ConfigButtonStyle(UIButton *button) {
    [button setBackgroundImage:[UIImage exImageWithColor:ColorHex(0x29d8d6)] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage exImageWithColor:ColorHex(0x26c8c6)] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage exImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    [button exSetBorder:[UIColor clearColor] width:0.1 radius:4];
}

void ConfigButtonRedStyle(UIButton *button) {
    [button setBackgroundImage:[UIImage exImageWithColor:ColorHex(0xff2b2a)] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage exImageWithColor:ColorHex(0xd41c1c)] forState:UIControlStateHighlighted];
    [button exSetBorder:[UIColor clearColor] width:0.1 radius:4];
}

CGFloat DistanceBetweenPoints(CGPoint point1, CGPoint point2) {
    CGFloat distance2 = ABS((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));
    return sqrtf(distance2);
}

CGFloat DegreeBetweenPoints(CGPoint start, CGPoint end) {
    CGFloat tan = atan(ABS((end.y - start.y) / (end.x - start.x))) * 180 / M_PI;
    if (end.x > start.x && end.y > start.y) {
        return -tan;
    }else if (end.x > start.x && end.y < start.y) {
        return tan;
    }else if (end.x < start.x && end.y > start.y) {
        return tan - 180;
    }else {
        return 180 - tan;
    }
}

NSString * MD5Bit32Encrypt(NSString *original) {
    return [original exMD5Bit32];
}




