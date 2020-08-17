//
//  NSNumber+Format.h
//  CarWash
//
//  Created by solehe on 2019/2/12.
//  Copyright © 2019 solehe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (Format)

/**
 格式化成日期字符串

 @param format 日期格式
 @return 格式化后的日期字符串
 */
- (NSString *)dateString:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
