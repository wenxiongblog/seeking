/***************************************************************************************************
 **  Copyright © 2016年 Jinn Chang. All rights reserved.
 **  Giuhub: https://github.com/Jinnchang
 **
 **  FileName: XXLockConfig.h
 **  Description: 配置文件
 **
 **  Author:  Jinnchang
 **  Date:    2016/9/22
 **  Version: 1.0.0
 **  Remark:  Create New File
 **************************************************************************************************/

#import <UIKit/UIKit.h>

#ifndef XXLockConfig_h
#define XXLockConfig_h

// 背景颜色
#define XX_LOCK_COLOR_BACKGROUND [UIColor whiteColor]

// 正常主题颜色
#define XX_LOCK_COLOR_NORMAL [UIColor colorWithRed:78/255.0 green:140/255.0 blue:238/255.0 alpha:1.0]

// 错误提示颜色
#define XX_LOCK_COLOR_ERROR [UIColor redColor]

// 重设按钮颜色
#define XX_LOCK_COLOR_BUTTON [UIColor grayColor]

/**
 *  指示器大小
 */
static const CGFloat kIndicatorSideLength = 30.f;

/**
 *  九宫格大小
 */
static const CGFloat kSudokoSideLength = 300.f;

/**
 *  圆圈边框粗细(指示器和九宫格的一样粗细)
 */
static const CGFloat kCircleWidth = 0.5f;

/**
 *  指示器轨迹粗细
 */
static const CGFloat kIndicatorTrackWidth = 0.5f;

/**
 *  九宫格轨迹粗细
 */
static const CGFloat kSudokoTrackWidth = 4.f;

/**
 *  圆圈选中效果中心点和圆圈比例
 */
static const CGFloat kCircleCenterRatio = 0.4f;

/**
 *  最少连接个数
 */
static const NSInteger kConnectionMinNum = 3;

/**
 *  指示器标签基数(不建议更改)
 */
static const NSInteger kIndicatorLevelBase = 1000;

/**
 *  九宫格标签基数(不建议更改)
 */
static const NSInteger kSudokoLevelBase = 2000;

/**
 *  手势解锁开关键(不建议更改)
 */
//static NSString * const kXXLockGestureUnlockEnabled = @"XXLockGestureUnlockEnabled";

/**
 *  指纹解锁开关键(不建议更改)
 */
//static NSString * const kXXLockTouchIdUnlockEnabled = @"XXLockTouchIdUnlockEnabled";

/**
 *  手势密码键(不建议更改)
 */
//static NSString * const kXXLockPasscode = @"XXLockPasscode";

/**
 *  应用进入后台时间(不建议更改)
 */
static NSString * const XXLockEnterBackgroundTime = @"XXLockEnterBackgroundTime";

/**
 *  应用进入后台的有效时间（不用解锁验证）
 */
static CGFloat const XXLockEffectiveTime = 30.f;

/**
 *  提示文本
 */
static NSString * const kXXLockTouchIdText  = @"指纹验证";
static NSString * const kXXLockResetText    = @"重新设置";
static NSString * const kXXLockForgetText   = @"忘记密码？";
static NSString * const kXXLockNewText      = @"请设置新密码";
static NSString * const kXXLockVerifyText   = @"请输入密码";
static NSString * const kXXLockAgainText    = @"请再次确认新密码";
static NSString * const kXXLockNotMatchText = @"两次密码不匹配";
static NSString * const kXXLockReNewText    = @"请重新设置新密码";
static NSString * const kXXLockReVerifyText = @"请重新输入密码";
static NSString * const kXXLockOldText      = @"请输入旧密码";
static NSString * const kXXLockOldErrorText = @"密码不正确";
static NSString * const kXXLockReOldText    = @"请重新输入旧密码";

#define XX_LOCK_NOT_ENOUGH [NSString stringWithFormat:@"最少连接%ld个点，请重新输入", (long)kConnectionMinNum]

#endif
