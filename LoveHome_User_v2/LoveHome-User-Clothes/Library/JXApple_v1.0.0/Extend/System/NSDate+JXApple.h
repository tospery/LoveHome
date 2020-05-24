//
//  NSDate+JXApple.h
//  MyiOS
//
//  Created by Thundersoft on 10/20/14.
//  Copyright (c) 2014 Thundersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kJXDateLengthWhenNoTime         (10)

#define kJXDateToday                    (@"JXDateToday")                // 今天
#define kJXDateYesterday                (@"JXDateYesterday")            // 昨日
#define kJXDateTomorrow                 (@"JXDateTomorrow")             // 明天

#define kJXDateTodayOfLastWeek          (@"JXDateTodayOfLastWeek")
#define kJXDateTodayOfNextWeek          (@"JXDateTodayOfNextWeek")
#define kJXDateFirstDayOfThisWeek       (@"JXDateFirstDayOfThisWeek")
#define kJXDateFinalDayOfThisWeek       (@"JXDateFinalDayOfThisWeek")
#define kJXDateFirstDayOfLastWeek       (@"JXDateFirstDayOfLastWeek")
#define kJXDateFinalDayOfLastWeek       (@"JXDateFinalDayOfLastWeek")
#define kJXDateFirstDayOfNextWeek       (@"JXDateFirstDayOfNextWeek")
#define kJXDateFinalDayOfNextWeek       (@"JXDateFinalDayOfNextWeek")

#define kJXDateTodayOfLastMonth         (@"JXDateTodayOfLastMonth")
#define kJXDateTodayOfNextMonth         (@"JXDateTodayOfNextMonth")
#define kJXDateFirstDayOfThisMonth      (@"JXDateFirstDayOfThisMonth")
#define kJXDateFinalDayOfThisMonth      (@"JXDateFinalDayOfThisMonth")
#define kJXDateFirstDayOfLastMonth      (@"JXDateFirstDayOfLastMonth")
#define kJXDateFinalDayOfLastMonth      (@"JXDateFinalDayOfLastMonth")
#define kJXDateFirstDayOfNextMonth      (@"JXDateFirstDayOfNextMonth")
#define kJXDateFinalDayOfNextMonth      (@"JXDateFinalDayOfNextMonth")


@interface NSDate (JXApple)
/**
 *  获取星期
 *
 *  @return 星期
 */
- (NSString *)exWeekday;

/**
 *  获取一段日期
 *
 *  @param date 起始日期
 *  @param day  间隔天数
 *
 *  @return 日期集
 */
+ (NSArray *)exDatesFromDate:(NSDate *)date ToDay:(NSInteger)day;




+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSDictionary *)intervalWithFormat:(NSString *)format;

// 日期转字符串
- (NSString *)exStringWithFormat:(NSString *)format locale:(NSString *)locale;
// 日期转字符串
- (NSString *)exStringWithFormat:(NSString *)format;
@end
