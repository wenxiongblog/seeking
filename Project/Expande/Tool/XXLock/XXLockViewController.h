/***************************************************************************************************
 **  Copyright © 2016年 Jinn Chang. All rights reserved.
 **  Giuhub: https://github.com/Jinnchang
 **
 **  FileName: XXLockViewController.h
 **  Description: 解锁密码控制器
 **
 **  Author:  Jinnchang
 **  Date:    2016/9/22
 **  Version: 1.0.0
 **  Remark:  Create New File
 **************************************************************************************************/

#import "XXLockTool.h"
#import "XXLockSudoko.h"
#import "XXLockIndicator.h"

/**
 控制器类型
 */
typedef NS_ENUM(NSInteger, XXLockType)
{
    XXLockTypeCreate, ///< 创建密码控制器
    XXLockTypeModify, ///< 修改密码控制器
    XXLockTypeVerify, ///< 验证密码控制器
    XXLockTypeRemove  ///< 移除密码控制器
};

typedef NS_ENUM(NSInteger, XXLockAppearMode)
{
    XXLockAppearModePush,
    XXLockAppearModePresent
};

@class XXLockViewController;

@protocol XXLockViewControllerDelegate <NSObject>

@optional

/**
 密码创建成功

 @param passcode passcode
 */
- (void)passcodeDidCreate:(NSString *)passcode;

/**
 密码修改成功

 @param passcode passcode
 */
- (void)passcodeDidModify:(NSString *)passcode;

/**
 密码验证成功

 @param passcode passcode
 */
- (void)passcodeDidVerify:(NSString *)passcode;

/**
 密码移除成功
 */
- (void)passcodeDidRemove;

/**
 点击了忘记密码
 */
- (void)passcodeDidForget;

@end

@interface XXLockViewController : UIViewController

- (instancetype)initWithDelegate:(id<XXLockViewControllerDelegate>)delegate
                            type:(XXLockType)type
                      appearMode:(XXLockAppearMode)appearMode;

@end
