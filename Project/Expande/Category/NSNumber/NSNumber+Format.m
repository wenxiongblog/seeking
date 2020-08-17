//
//  NSNumber+Format.m
//  CarWash
//
//  Created by solehe on 2019/2/12.
//  Copyright © 2019 solehe. All rights reserved.
//

#import "NSNumber+Format.h"

@implementation NSNumber (Format)

/**
 格式化成日期字符串
 
 @param format 日期格式
 @return 格式化后的日期字符串
 */
- (NSString *)dateString:(NSString *)format {
    NSTimeInterval sec = [self integerValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sec];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

@end
