//
//  NSDate+Extend.m
//  SmartLock
//
//  Created by Sole on 2017/6/23.
//  Copyright © 2017年 sole. All rights reserved.
//

#import "NSDate+Extend.h"

@implementation NSDate (Extend)

//获取当前时间
+ (NSString *)getNowTimeTimestamp3{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    //设置时区
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    NSString *strDate = [formatter stringFromDate:datenow];
    return strDate;
}

//- (BOOL)isAM {
//    //获取系统是24小时制或者12小时制
//    NSString*formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
//    NSRange containsA =[formatStringForHours rangeOfString:@"a"];
//    return containsA.location != NSNotFound;
//}
        
//- (NSString *)time {
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
////    NSDateComponents *comps    = [[NSDateComponents alloc] init];
//    NSInteger        unitFlags = NSCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay | kCFCalendarUnitHour
//    | kCFCalendarUnitMinute | kCFCalendarUnitSecond | kCFCalendarUnitWeekday;
//    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
//    NSInteger hour  = [comps hour];
//    NSInteger min   = [comps minute];
//    
//    if ([self isAM]) {
//        
//        if (hour < 12) {
//            return [NSString stringWithFormat:@"%02ld:%02ld AM", hour, min];
//        } else {
//            return [NSString stringWithFormat:@"%02ld:%02ld PM", hour%12, min];
//        }
//        
//    } else {
//        return [NSString stringWithFormat:@"%02ld:%02ld", hour, min];
//    }
//    
//}

- (NSString *)date {
 
    NSCalendar       *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents *comps    = [[NSDateComponents alloc] init];
    NSInteger        unitFlags = NSCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay | kCFCalendarUnitHour
    | kCFCalendarUnitMinute | kCFCalendarUnitSecond | kCFCalendarUnitWeekday;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    NSInteger year  = [comps year]; //取年分时间后两位
    NSInteger month = [comps month];
    NSInteger day   = [comps day];

    return [NSString stringWithFormat:@"%02ld/%02ld/%02ld", day, month, year%2000];
}

- (NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate转NSString
    return [dateFormatter stringFromDate:self];
}

- (NSString *)USDateString {
    //日期处理
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterMediumStyle;
    dateFormatter.timeStyle = kCFDateFormatterMediumStyle;
    return [dateFormatter stringFromDate:self];
}

- (NSString *)USShortDateString {
    //日期处理
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterLongStyle;
    dateFormatter.timeStyle = kCFDateFormatterNoStyle;
    return [dateFormatter stringFromDate:self];
}

- (NSString *)USShortTimeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterNoStyle;
    dateFormatter.timeStyle = kCFDateFormatterShortStyle;
    return [dateFormatter stringFromDate:self];
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    NSString *timestamp_str = [outputFormatter stringFromDate:self];
    return timestamp_str;
}

- (NSInteger)year {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitYear) fromDate:self];
    return [dayComponents year];
}
- (NSInteger)month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMonth) fromDate:self];
    return [dayComponents month];
}
- (NSInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitDay) fromDate:self];
    return [dayComponents day];
}
- (NSInteger)hour {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | kCFCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    NSInteger hour = [components hour];
    return (NSInteger)hour;
}
- (NSInteger)min {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | kCFCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    NSInteger minute = [components minute];
    return (NSInteger)minute;
}
- (NSInteger)sec {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | kCFCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    NSInteger second = [components second];
    return (NSInteger)second;
}

- (NSInteger)dayOfWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSCalendarUnitWeekday) fromDate:self];
    return [weekdayComponents weekday];
}
- (NSInteger)weekOfYear {
    NSInteger i;
    NSInteger year = [self year];
    NSDate *date = [self endWeek];
    for (i = 1; [[date dateAfterDay:-7 * i] year] == year; i++);
    return i;
}
- (NSInteger)weeksOfMonth {
    return [[self endOfMonth] weekOfYear] - [[self beginOfMonth] weekOfYear] + 1;
}

- (NSDate *)dateAfterDay:(NSInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:day];
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    return dateAfterDay;
}
- (NSDate *)dateAfterMonth:(NSInteger)month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setMonth:month];
    NSDate *dateAfterMonth = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    return dateAfterMonth;
}

- (NSDate *)endWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:self];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:(7 - [weekdayComponents weekday])];
    NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    return endOfWeek;
}

- (NSDate *)beginOfMonth {
    return [self dateAfterDay:-[self day] + 1];
}

- (NSDate *)endOfMonth {
    return [[[self beginOfMonth] dateAfterMonth:1] dateAfterDay:-1];
}

// 时间字符串必须为yyyy-MM-dd HH:mm:ss
+ (NSDate *)dateWithString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:dateString];
}

+ (BOOL)judgeisNews24HoursDate:(NSDate *)createDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *startDate = createDate;
    NSDate *endDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitHour;//只比较天数差异
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    NSLog(@"%ld",delta.hour);
    if(delta.hour <= 24){
        return YES;
    }
    return NO;
}
@end
