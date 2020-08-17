//
//  XXLog.h
//  SCGov
//
//  Created by solehe on 2019/7/22.
//  Copyright © 2019 solehe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 调试日志打印
 */
@interface XXLog : NSObject

/**
 获取网络请求地址
 
 @param url 默认地址
 */
+ (NSString *)requestUrl:(NSString *)url;

/**
 是否展示日志打印浮窗

 @param isShow 展示：YES，隐藏：NO
 */
+ (void)show:(BOOL)isShow;

/**
 打印日志（记录的同时也会打印到控制台）

 @param msg 日志信息
 */
+ (void)log:(NSString *)msg,...;

/**
 清空日志
 */
+ (void)clear;

@end

NS_ASSUME_NONNULL_END

#define Log(fmt, ...)  [XXLog log:fmt, ##__VA_ARGS__]
