//
//  NSDate+JXApple.m
//  MyiOS
//
//  Created by Thundersoft on 10/20/14.
//  Copyright (c) 2014 Thundersoft. All rights reserved.
//

#import "NSDate+JXApple.h"
#import "JXApple.h"

#define kJXDateWeekdayStyle1Val1            (@"周日")
#define kJXDateWeekdayStyle1Val2            (@"周一")
#define kJXDateWeekdayStyle1Val3            (@"周二")
#define kJXDateWeekdayStyle1Val4            (@"周三")
#define kJXDateWeekdayStyle1Val5            (@"周四")
#define kJXDateWeekdayStyle1Val6            (@"周五")
#define kJXDateWeekdayStyle1Val7            (@"周六")

@implementation NSDate (JXApple)
// 获取星期
- (NSString *)exWeekday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitWeekday)
                                               fromDate:self];
    
    NSString *result;
    switch (components.weekday) {
        case 1:
            result = kJXDateWeekdayStyle1Val1;
            break;
        case 2:
            result = kJXDateWeekdayStyle1Val2;
            break;
        case 3:
            result = kJXDateWeekdayStyle1Val3;
            break;
        case 4:
            result = kJXDateWeekdayStyle1Val4;
            break;
        case 5:
            result = kJXDateWeekdayStyle1Val5;
            break;
        case 6:
            result = kJXDateWeekdayStyle1Val6;
            break;
        case 7:
            result = kJXDateWeekdayStyle1Val7;
            break;
        default:
            result = nil;
            break;
    }
    return result;
}

// 获取一段日期
+ (NSArray *)exDatesFromDate:(NSDate *)date ToDay:(NSInteger)day {
    if (!date || day < 0) {
        return nil;
    }
    
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:day];
    [results addObject:date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    for (int i = 1; i < 7; ++i) {
        [components setHour:24 * i];
        [components setMinute:0];
        [components setSecond:0];
        NSDate *cur = [calendar dateByAddingComponents:components toDate:date options:0];
        [results addObject:cur];
    }
    
    return results;
}

+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:string];
}

- (NSString *)stringWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
}

- (NSDictionary *)intervalWithFormat:(NSString *)format
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond )
                                               fromDate:self];

    // 今天
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [calendar dateByAddingComponents:components toDate:self options:0];

    // 昨天
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [calendar dateByAddingComponents:components toDate: today options:0];

    // 明天
    [components setHour:24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *tomorrow = [calendar dateByAddingComponents:components toDate: today options:0];

    // 上周的今天
    components = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                             fromDate:self];
    [components setDay:(components.day - 7)];
    NSDate *todayOfLastWeek  = [calendar dateFromComponents:components];

    // 下周的今天
    [components setDay:(components.day + 7 * 2)];
    NSDate *todayOfNextWeek  = [calendar dateFromComponents:components];

    // 本周第一天
    [components setDay:(components.day - 7 - (components.weekday - 1))];
    NSDate *firstDayOfThisWeek  = [calendar dateFromComponents:components];

    // 本周最后一天
    [components setDay:(components.day + 6)];
    NSDate *finalDayOfThisWeek  = [calendar dateFromComponents:components];

    // 上周第一天
    [components setDay:(components.day - 7 * 2 + 1)];
    NSDate *firstDayOfLastWeek  = [calendar dateFromComponents:components];

    // 上周最后一天
    [components setDay:(components.day + 6)];
    NSDate *finalDayOfLastWeek  = [calendar dateFromComponents:components];

    // 下周第一天
    [components setDay:(components.day + 7 + 1)];
    NSDate *firstDayOfNextWeek  = [calendar dateFromComponents:components];

    // 下周最后一天
    [components setDay:(components.day + 6)];
    NSDate *finalDayOfNextWeek  = [calendar dateFromComponents:components];

    // 上月的今天
    components = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                             fromDate:self];
    [components setMonth:(components.month - 1)];
    NSDate *todayOfLastMonth  = [calendar dateFromComponents:components];

    // 下月的今天
    [components setMonth:(components.month + 1 * 2)];
    NSDate *todayOfNextMonth  = [calendar dateFromComponents:components];

    // 本月第一天
    [components setMonth:(components.month - 1)];
    [components setDay:1];
    NSDate *firstDayOfThisMonth  = [calendar dateFromComponents:components];

    // 本月最后一天
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:firstDayOfThisMonth];
    components.day = range.length;
    NSDate *finalDayOfThisMonth  = [calendar dateFromComponents:components];

    // 上月第一天
    components.month = components.month - 1;
    components.day = 1;
    NSDate *firstDayOfLastMonth  = [calendar dateFromComponents:components];

    // 上月最后一天
    range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:firstDayOfLastMonth];
    components.day = range.length;
    NSDate *finalDayOfLastMonth  = [calendar dateFromComponents:components];

    // 下月第一天
    components.month = components.month + 1 * 2;
    components.day = 1;
    NSDate *firstDayOfNextMonth  = [calendar dateFromComponents:components];

    // 下月最后一天
    range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:firstDayOfNextMonth];
    components.day = range.length;
    NSDate *finalDayOfNextMonth  = [calendar dateFromComponents:components];

    NSDictionary *result = @{kJXDateToday: [today stringWithFormat:format],
                             kJXDateYesterday: [yesterday stringWithFormat:format],
                             kJXDateTomorrow: [tomorrow stringWithFormat:format],
                             kJXDateTodayOfLastWeek: [todayOfLastWeek stringWithFormat:format],
                             kJXDateTodayOfNextWeek: [todayOfNextWeek stringWithFormat:format],
                             kJXDateFirstDayOfThisWeek: [firstDayOfThisWeek stringWithFormat:format],
                             kJXDateFinalDayOfThisWeek: [finalDayOfThisWeek stringWithFormat:format],
                             kJXDateFirstDayOfLastWeek: [firstDayOfLastWeek stringWithFormat:format],
                             kJXDateFinalDayOfLastWeek: [finalDayOfLastWeek stringWithFormat:format],
                             kJXDateFirstDayOfNextWeek: [firstDayOfNextWeek stringWithFormat:format],
                             kJXDateFinalDayOfNextWeek: [finalDayOfNextWeek stringWithFormat:format],
                             kJXDateTodayOfLastMonth: [todayOfLastMonth stringWithFormat:format],
                             kJXDateTodayOfNextMonth: [todayOfNextMonth stringWithFormat:format],
                             kJXDateFirstDayOfThisMonth: [firstDayOfThisMonth stringWithFormat:format],
                             kJXDateFinalDayOfThisMonth: [finalDayOfThisMonth stringWithFormat:format],
                             kJXDateFirstDayOfLastMonth: [firstDayOfLastMonth stringWithFormat:format],
                             kJXDateFinalDayOfLastMonth: [finalDayOfLastMonth stringWithFormat:format],
                             kJXDateFirstDayOfNextMonth: [firstDayOfNextMonth stringWithFormat:format],
                             kJXDateFinalDayOfNextMonth: [finalDayOfNextMonth stringWithFormat:format]};

    return result;
}

// 日期转字符串
- (NSString *)exStringWithFormat:(NSString *)format locale:(NSString *)locale {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:self];
    NSDate *adjustDate = [self dateByAddingTimeInterval:(interval * -1)];
    
    return [[NSDateFormatter exInstanceWithFormat:format locale:locale] stringFromDate:adjustDate];
}

// 日期转字符串
- (NSString *)exStringWithFormat:(NSString *)format {
    return [[NSDateFormatter exInstanceWithFormat:format] stringFromDate:self];
}
@end















