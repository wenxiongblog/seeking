//
//  NSArray+XWUtils.h
//  Project
//
//  Created by xuwen on 2018/4/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (XWUtils)

/**
 *  充填的数组
 *
 *  @param count  数组对象个数
 *  @param array  用以填充的数组
 *  @param object 不足位补足的对象
 *
 *  @return 已填充的数组
 */
+ (NSArray *)fillArraySomeCount:(NSUInteger)count byOtherArray:(NSArray *)array withPlaceholderObject:(id)object;
//翻转数组
- (NSArray *)turnOver;


@end
