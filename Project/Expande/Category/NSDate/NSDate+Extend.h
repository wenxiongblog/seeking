//
//  NSDate+Extend.h
//  SCZW
//
//  Created by Sole on 2017/6/23.
//  Copyright © 2017年 sole. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extend)

/**
 是否是上午
 */
//- (BOOL)isAM;

//- (NSString *)time; //时间
- (NSString *)date;  //日期
- (NSString *)dateString;
- (NSString *)USDateString;
- (NSString *)USShortDateString;
- (NSString *)USShortTimeString;
- (NSString *)stringWithFormat:(NSString *)format;  //日期格式化

- (NSInteger)year;  //年
- (NSInteger)month;  //月
- (NSInteger)day;  //日
- (NSInteger)hour;  //时
- (NSInteger)min;  //分
- (NSInteger)sec;  //秒

- (NSInteger)dayOfWeek;  //一周的第几天
- (NSInteger)weekOfYear;  //一年的第几周
- (NSInteger)weeksOfMonth;  //一月的第几周

- (NSDate *)dateAfterDay:(NSInteger)day;  //多少天之后
- (NSDate *)dateAfterMonth:(NSInteger)month;  //多少月之后

- (NSDate *)beginOfMonth;  //一月的开始
- (NSDate *)endOfMonth;  //一月的结束

// 时间字符串必须为yyyy-MM-dd HH:mm:ss
+ (NSDate *)dateWithString:(NSString *)dateString;


//获取当前时间戳  （以毫秒单位）
+(NSString *)getNowTimeTimestamp3;

//判断是否是新用户 24小时以内
+ (BOOL)judgeisNews24HoursDate:(NSDate *)createDate;

@end
