/***************************************************************************************************
 **  Copyright © 2016年 Jinn Chang. All rights reserved.
 **  Giuhub: https://github.com/Jinnchang
 **
 **  FileName: XXLockTool.h
 **  Description: 密码管理工具
 **
 **  Author:  Jinnchang
 **  Date:    2016/9/22
 **  Version: 1.0.0
 **  Remark:  Create New File
 **************************************************************************************************/

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LAContext.h>

@interface XXLockTool : NSObject

#pragma mark - 手势密码管理

/**
 是否允许手势解锁(应用级别的)

 @return BOOL
 */
+ (BOOL)isGestureUnlockEnabled;

/**
 设置是否允许手势解锁功能

 @param enabled enabled
 */
+ (void)setGestureUnlockEnabled:(BOOL)enabled;

/**
 当前已经设置的手势密码

 @return NSString
 */
+ (NSString *)currentGesturePasscode;

/**
 设置新的手势密码

 @param passcode passcode
 */
+ (void)setGesturePasscode:(NSString *)passcode;

#pragma mark - 指纹解锁管理

/**
 是否支持指纹识别(系统级别的)

 @return BOOL
 */
+ (BOOL)isTouchIdSupported;

/**
 是否允许指纹解锁(应用级别的)

 @return BOOL
 */
+ (BOOL)isTouchIdUnlockEnabled;

/**
 设置是否允许指纹解锁功能

 @param enabled enabled
 */
+ (void)setTouchIdUnlockEnabled:(BOOL)enabled;

/**
 判断是否需要进行手势或者指纹验证
 
 @return BOOL
 */
+ (BOOL)needGestureOrTouchIdVerify;

/**
 记录应用进入后台状态
 */
+ (void)setEnterBackgroundStatus;

@end
