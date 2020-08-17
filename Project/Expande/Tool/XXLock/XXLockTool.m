/***************************************************************************************************
 **  Copyright © 2016年 Jinn Chang. All rights reserved.
 **  Giuhub: https://github.com/Jinnchang
 **
 **  FileName: XXLockTool.m
 **  Description: 密码管理工具
 **
 **  Author:  Jinnchang
 **  Date:    2016/9/22
 **  Version: 1.0.0
 **  Remark:  Create New File
 **************************************************************************************************/

#import "XXLockTool.h"
#import "XXLockConfig.h"
#import "XXLockViewController.h"

@implementation XXLockTool

#pragma mark - 手势密码管理

/**
 是否允许手势解锁(应用级别的)
 
 @return BOOL
 */
+ (BOOL)isGestureUnlockEnabled
{
//    return [[NSUserDefaults standardUserDefaults] boolForKey:kXXLockGestureUnlockEnabled];
    return YES;
}

/**
 设置是否允许手势解锁功能
 
 @param enabled enabled
 */
+ (void)setGestureUnlockEnabled:(BOOL)enabled
{
//    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kXXLockGestureUnlockEnabled];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 当前已经设置的手势密码
 
 @return NSString
 */
+ (NSString *)currentGesturePasscode
{
//    return [[NSUserDefaults standardUserDefaults] objectForKey:kXXLockPasscode];
    return @"";
}

/**
 设置新的手势密码
 
 @param passcode passcode
 */
+ (void)setGesturePasscode:(NSString *)passcode
{
//    [[NSUserDefaults standardUserDefaults] setObject:passcode forKey:kXXLockPasscode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 指纹解锁管理

/**
 是否支持指纹识别(系统级别的)
 
 @return BOOL
 */
+ (BOOL)isTouchIdSupported
{
    NSError *error;
    
    return [[[LAContext alloc] init] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
}

/**
 是否允许指纹解锁(应用级别的)
 
 @return BOOL
 */
+ (BOOL)isTouchIdUnlockEnabled
{
//    return [[NSUserDefaults standardUserDefaults] boolForKey:kXXLockTouchIdUnlockEnabled];
    return YES;
}

/**
 设置是否允许指纹解锁功能
 
 @param enabled enabled
 */
+ (void)setTouchIdUnlockEnabled:(BOOL)enabled
{
//    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kXXLockTouchIdUnlockEnabled];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 判断是否需要进行手势或者指纹验证

 @return BOOL
 */
+ (BOOL)needGestureOrTouchIdVerify
{
    NSTimeInterval interval = [[NSUserDefaults standardUserDefaults] doubleForKey:XXLockEnterBackgroundTime];
    NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
    if (currentInterval - interval > XXLockEffectiveTime) {
        if ([XXLockTool isGestureUnlockEnabled] || [XXLockTool isTouchIdUnlockEnabled]) {
            return YES;
        }
    }
    return NO;
}

/**
 记录应用进入后台状态
 */
+ (void)setEnterBackgroundStatus
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    [[NSUserDefaults standardUserDefaults] setDouble:interval forKey:XXLockEnterBackgroundTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
